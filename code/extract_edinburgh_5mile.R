#!/usr/bin/env Rscript
# extract_edinburgh_5mile.R
# Extract HadUK-Grid temperature values and compute area-average for all grid cells
# within 5 miles of 14 Forth St, Edinburgh. Produces CSVs consumed by the Shiny app.
#
# Usage:
#   Rscript code/extract_edinburgh_5mile.R
#
# Dependencies:
#   install.packages(c("ncdf4", "here", "tidyverse", "lubridate", "geosphere"))

library(ncdf4)
library(here)
library(tidyverse)
library(lubridate)
library(geosphere)

# CONFIG
data_dir <- here("open_data", "temperature_HadUK_Grid")
output_dir <- here()
# 14 Forth St coordinate (as requested)
site_name <- "14 Forth St, Edinburgh"
site_lat <- 55.91174
site_lon <- -3.27710
radius_m <- 5 * 1609.344  # five miles in meters ~ 8046.72

# Helper: parse time units (handles 'hours since ...', 'days since ...', etc.)
parse_nc_time <- function(nc, time_vals) {
  tu <- ncatt_get(nc, "time", "units")$value
  if (is.null(tu)) stop("time variable has no units attribute")
  m <- regexec("^\s*([^ ]+) since (.+)$", tu)
  parts <- regmatches(tu, m)[[1]]
  if (length(parts) < 3) stop("Unexpected time units format: ", tu)
  unit <- parts[2]
  origin_str <- parts[3]
  origin <- as.POSIXct(origin_str, tz = "UTC")
  if (is.na(origin)) origin <- as.POSIXct(paste0(origin_str, " 00:00:00"), tz = "UTC")
  if (unit %in% c("seconds", "second", "secs", "sec")) {
    times <- origin + time_vals
  } else if (unit %in% c("minutes", "minute", "mins", "min")) {
    times <- origin + time_vals * 60
  } else if (unit %in% c("hours", "hour", "hrs", "hr")) {
    times <- origin + time_vals * 3600
  } else if (unit %in% c("days", "day")) {
    times <- origin + time_vals * 86400
  } else {
    times <- origin + time_vals * 86400
    warning("Unknown time unit '", unit, "'. Interpreting as days since origin.")
  }
  return(times)
}

# Helper: get grid cell indices within radius (returns matrix of index rows/cols)
get_indices_within_radius <- function(ncfile, lat0, lon0, radius_m) {
  nc <- nc_open(ncfile)
  on.exit(nc_close(nc), add = TRUE)
  # Find lat/lon variable names
  latname <- if("latitude" %in% names(nc$var)) "latitude" else if("lat" %in% names(nc$var)) "lat" else NULL
  lonname <- if("longitude" %in% names(nc$var)) "longitude" else if("lon" %in% names(nc$var)) "lon" else NULL
  if (is.null(latname) || is.null(lonname)) stop("Cannot find latitude/longitude variables in ", ncfile)
  lat <- ncvar_get(nc, latname)
  lon <- ncvar_get(nc, lonname)
  if (!all(dim(lat) == dim(lon))) stop("latitude/longitude dims mismatch")
  # Compute distances (vectorized)
  # geosphere::distHaversine expects (lon,lat) pairs
  coords_mat <- cbind(as.vector(lon), as.vector(lat))
  center <- c(lon0, lat0)
  dists <- distHaversine(coords_mat, center)
  inside <- which(dists <= radius_m)
  if (length(inside) == 0) stop("No grid cell within radius found - maybe radius too small or coordinate mismatch")
  # Convert linear indices back to matrix indices
  idx_mat <- arrayInd(inside, .dim = dim(lat))
  return(list(indices = idx_mat, lat = lat, lon = lon))
}

# Extract area-average timeseries for a single netCDF file
extract_area_from_file <- function(ncfile, varname, idx_mat) {
  nc <- nc_open(ncfile)
  on.exit(nc_close(nc), add = TRUE)
  varinfo <- nc$var[[varname]]
  if (is.null(varinfo)) {
    warning("Variable ", varname, " not found in ", ncfile)
    return(tibble())
  }
  # Determine time dimension length
  var_dims <- sapply(varinfo$dim, function(d) d$name)
  ntime <- if ("time" %in% var_dims) {
    # The time variable is in the file; get its length from ncvar
    length(ncvar_get(nc, "time"))
  } else if (length(varinfo$dim) == 3) {
    varinfo$dim[[3]]$len
  } else {
    1
  }
  # Handle _FillValue
  fv <- ncatt_get(nc, varname, "_FillValue")$value
  if (is.null(fv)) fv <- ncatt_get(nc, varname, "missing_value")$value
  results <- vector("list", ntime)
  time_vals <- ncvar_get(nc, "time")
  dates <- as.Date(parse_nc_time(nc, time_vals))
  # Loop over time steps; read spatial slice for each time and compute mean of selected cells
  for (t in seq_len(ntime)) {
    # read slice (all x,y for given time)
    # assume var ordering is (x, y, time)
    vals_slice <- tryCatch(
      ncvar_get(nc, varname, start = c(1,1,t), count = c(-1, -1, 1)),
      error = function(e) ncvar_get(nc, varname)
    )
    # If returned as a matrix / array, extract the selected points
    if (is.null(dim(vals_slice))) {
      # single value
      values_vec <- as.numeric(vals_slice)
    } else {
      # flatten, then pick indices
      values_vec <- as.vector(vals_slice)[ ( (idx_mat[,2] - 1) * nrow(vals_slice) + idx_mat[,1] ) ]
      # but better to index by row/col directly:
      values_vec <- mapply(function(i,j) vals_slice[i,j], idx_mat[,1], idx_mat[,2])
    }
    if (!is.null(fv)) values_vec[values_vec == fv] <- NA
    results[[t]] <- tibble(date = dates[t], mean_value = mean(values_vec, na.rm = TRUE), n_cells = sum(!is.na(values_vec)))
  }
  bind_rows(results)
}

# High-level extraction: finds indices once (using a sample file) and loops across files for each variable
perform_extraction <- function(varname_pattern, out_csv_name, lat0, lon0, radius_m) {
  files <- list.files(data_dir, pattern = varname_pattern, full.names = TRUE) %>% sort()
  if (length(files) == 0) {
    message("No files found for pattern: ", varname_pattern)
    return(invisible(NULL))
  }
  # Use first file to get indices
  sample_file <- files[1]
  idx_info <- get_indices_within_radius(sample_file, lat0, lon0, radius_m)
  idx_mat <- idx_info$indices
  message("Found ", nrow(idx_mat), " grid cells within radius for sample file: ", basename(sample_file))
  # For each file, extract and store
  all_ts <- vector("list", length(files))
  for (i in seq_along(files)) {
    f <- files[i]
    message("Processing file: ", basename(f))
    # deduce varname by pattern: if varname_pattern contains 'tasmax' it'll match directly. But we need explicit varname string
    # extract varname from filename, e.g., tasmax_hadukgrid...
    fname <- basename(f)
    varname <- if (grepl("^tasmax", fname)) "tasmax" else if (grepl("^tasmin", fname)) "tasmin" else if (grepl("^tas_", fname) || grepl("^tas_hadukgrid", fname) || grepl("^tas_haduk", fname) || grepl("^tas_hadukgrid_uk_1km_mon", fname)) "tas" else {
      # fallback: try common vars
      "tas"
    }
    try({
      ts <- extract_area_from_file(f, varname, idx_mat)
      if (nrow(ts) == 0) next
      ts <- ts %>% mutate(file = fname, var = varname, site = site_name, site_lat = lat0, site_lon = lon0)
      all_ts[[i]] <- ts
    }, silent = TRUE)
  }
  df <- bind_rows(all_ts) %>% arrange(date)
  if (nrow(df) == 0) {
    message("No data extracted for pattern: ", varname_pattern)
    return(invisible(NULL))
  }
  write_csv(df, file.path(output_dir, out_csv_name))
  message("Saved ", out_csv_name, " with ", nrow(df), " rows")
  invisible(df)
}

# Run extraction for daily max, daily min, monthly mean
df_tasmax <- perform_extraction("tasmax_hadukgrid_uk_1km_day.*\.nc$", "edinburgh_area_tasmax_daily.csv", site_lat, site_lon, radius_m)
df_tasmin <- perform_extraction("tasmin_hadukgrid_uk_1km_day.*\.nc$", "edinburgh_area_tasmin_daily.csv", site_lat, site_lon, radius_m)
df_tasmon <- perform_extraction("tas_hadukgrid_uk_1km_mon.*\.nc$", "edinburgh_area_tas_monthly.csv", site_lat, site_lon, radius_m)

# Combine daily into a single CSV if desired
if (!is.null(df_tasmax) || !is.null(df_tasmin)) {
  daily_combined <- bind_rows(
    df_tasmax %>% mutate(type = "tasmax"),
    df_tasmin %>% mutate(type = "tasmin")
  ) %>% arrange(date)
  if (nrow(daily_combined) > 0) {
    write_csv(daily_combined, file.path(output_dir, "edinburgh_area_daily_combined.csv"))
    message("Saved edinburgh_area_daily_combined.csv")
  }
}

message("Extraction complete. CSVs are in project root. Now you can run the Shiny app (shiny/app.R).")
