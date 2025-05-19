# Temperatures in Edinburgh 2024 

library(ncdf4)
#library(ncdf4.helpers)
library(RNetCDF)
library(here)
library(tidyverse)
library(stringi)

# Plot a chart of the daily temperature max and min, and monthly avg, in Edinburgh in 2024.

# Data from Met Office's HadUK Grid, released by Met Office under the OGL 
# - see README.md for further details. 

data_dir_name <- "open_data" 
data_subdir <- "temperature_HadUK_Grid"

# Identify OS grid refs for Edinburgh - grid square NT
# one 1km grid in central Edinburgh, inc the ECCAN office on Forth St
single_location_gridref <- "NT 25981 74498"
# Cannot find variable for gridref in the data, so use lat and longitude, 14 Forth St
single_location_latlong <- c(55.91174,-3.27710)

# Cannot find a gridreference variable to use to filter / slice data. 
# Whereas, there are lat and longitude fields in both annual and month files. 
# Time units: hours since 1800-01-01 00:00:00

# function to return values
get_data_from_file <- function(filename, single_location_latlong, variable_name){
  # Might not use location - simpler approach, save data to a CSV first,
  # for manipulation in Excel. 
  # for testing, name of December min temp file
  # filename <- "tasmax_hadukgrid_uk_1km_day_20241201-20241231.nc"
  # variable_name <- "tasmax"
  nc_conn <- open.nc(here(data_dir_name, data_subdir, filename)) 
  # Make an inquiry with RNetCDF function
  # print(c("Num of dimensions: ", file.inq.nc(nc_conn)["ndims"]))
  # print(c("Num of global attributes: ", file.inq.nc(nc_conn)["ngatts"]))
  # print(c("Num of variables: ", file.inq.nc(nc_conn)["nvars"]))
  # print.nc(nc_conn)
  data_from_file <- list()
  # Extract data for Edinburgh, for elevation starts and ends at 1,
  # and number of data points is the whole series starting at 1, count = 31 for 31 days
  data_from_file$variable_values <- var.get.nc(nc_conn, 
                                              variable_name, 
                                              start = c(single_location_latlong[1], single_location_latlong[2],1,1), 
                                              count = c(1,1,1,31)) 
  data_from_file$time  <- var.get.nc(nc_conn, 
                                     "time",
                                     start = c(single_location_latlong[1], single_location_latlong[2],1,1),
                                     count = c(1,1,1,31)) 

  rm(nc_conn)
  
  return(data_from_file)
}


# 2024 monthly daily provisional data 

# use dir() to get filenames, similar to glob
files_temprtr_folder <- dir(path = here(data_dir_name,data_subdir))
data_files_daily_max_temprtr <-  stri_subset_regex(files_temprtr_folder, pattern = "tasmax_hadukgrid_uk_1km_day") 
data_files_daily_min_temprtr <-  stri_subset_regex(files_temprtr_folder, pattern = "tasmin_hadukgrid_uk_1km_day") 

# Use purrr::map() to call the function multiple times with all the parameters 

all_temperature_data <- list()


# read in max data
for (i in 1:length(data_files_daily_temprtr)){ 
   the_tasmax_data <- get_data_from_file("tasmax")
   the_tasmin_data <- get_data_from_file("tasmin")
   #  daily_temperature_to_plot <- 
 #   rbind(daily_temperature_to_plot, get_tas_from_file(data_files_months_temprtr[i], single_location_latlong)) 
}

# read in max data
for (i in 1:length(data_files_daily_temprtr)){ 
  the_tasmax_data <- get_data_from_file("tasmax")
  the_tasmin_data <- get_data_from_file("tasmin")
  #  daily_temperature_to_plot <- 
  #   rbind(daily_temperature_to_plot, get_tas_from_file(data_files_months_temprtr[i], single_location_latlong)) 
}


# SAve out the max temp to csv
temperature_data_csv_filename <- "my_csv_temperature.csv"
write_csv(temperature_to_plot, temperature_data_csv_filename)
plot(temperature_to_plot)


# 2024 monthly provisional data 
# One figure the monthly avg

# use dir() to get filenames, similar to glob
files_temprtr_folder <- dir(path = here(data_dir_name,data_subdir))
data_files_months_temprtr <-  stri_subset_regex(files_temprtr_folder, pattern = "tas_hadukgrid_uk_1km_mon") 

# read in monthly data
for (mth in 1:length(data_files_months_temprtr)){ #should be 12(!)
  temperature_to_plot <- 
    rbind(temperature_to_plot, get_tas_from_file(data_files_months_temprtr[mth], single_location_latlong)) 
}

# SAve out the temp to csv
temperature_data_csv_filename <- "my_csv_monthly_temperature.csv"
write_csv(temperature_to_plot, temperature_data_csv_filename)
plot(temperature_to_plot)




# Explore the spatial grid in a netcdf file
# with aim of checking it is consistent with expectations
# ie should be British National Grid
# Should be able to identify Edinburgh
explore_spatial_nc <- function(inputfile) {
  places_file <- "ABCD_places.csv"
  places <- read_csv(here(data_dir_name, places_file))
  
  nc_conn <- open.nc(here(data_dir_name, data_subdir, inputfile))
  print(c("Num of dimensions: ", file.inq.nc(nc_conn)["ndims"]))
  # print(c("Num of global attributes: ", file.inq.nc(nc_conn)["ngatts"]))
  # print(c("Num of variables: ", file.inq.nc(nc_conn)["nvars"]))
  # print.nc(nc_conn)
  lat_from_file  <-  ncvar_get(nc_conn, varid = "lat")
  
  long_from_file  <-  ncvar_get(nc_conn, varid = "long")
  
  
  
  
}
# explore_spatial_nc("tasmin_hadukgrid_uk_1km_day_20241201-20241231.nc")

# Appendix: Metadata - output from print.nc 

# Output from print.nc on daily file
# NC_CHAR tasmin:grid_mapping = "transverse_mercator" ;
# NC_CHAR tasmin:coordinates = "latitude longitude" ;
# NC_INT transverse_mercator ;
# NC_CHAR transverse_mercator:grid_mapping_name = "transverse_mercator" ;
# NC_DOUBLE transverse_mercator:longitude_of_prime_meridian = 0 ;
# NC_DOUBLE transverse_mercator:semi_major_axis = 6377563.396 ;
# NC_DOUBLE transverse_mercator:semi_minor_axis = 6356256.909 ;
# NC_DOUBLE transverse_mercator:longitude_of_central_meridian = -2 ;
# NC_DOUBLE transverse_mercator:latitude_of_projection_origin = 49 ;
# NC_DOUBLE transverse_mercator:false_easting = 4e+05 ;
# NC_DOUBLE transverse_mercator:false_northing = -1e+05 ;
# NC_DOUBLE transverse_mercator:scale_factor_at_central_meridian = 0.9996012717 ;
# NC_INT64 time(time) ;
# NC_CHAR time:axis = "T" ;


# on annual data file
# # > print.nc(nc_conn)
# netcdf netcdf4 {
#   dimensions:
#     time = 1 ;  #[Just one value, per geospatial point, the avg temperature for the whole year]
#     projection_y_coordinate = 1450 ; #[same as daily]
#     projection_x_coordinate = 900 ;
#     bnds = 2 ;
#     variables:
#       NC_DOUBLE tas(projection_x_coordinate, projection_y_coordinate, time) ;
#     NC_DOUBLE tas:_FillValue = 1e+20 ;
#     NC_CHAR tas:standard_name = "air_temperature" ;
#     NC_CHAR tas:long_name = "Mean air temperature" ;
#     NC_CHAR tas:units = "degC" ;
#     NC_CHAR tas:description = "Mean air temperature" ;
#     NC_STRING tas:label_units = "°C" ;
#     NC_CHAR tas:level = "1.5m" ;
#     NC_STRING tas:plot_label = "Mean air temperature at 1.5m (°C)" ;
#     NC_CHAR tas:cell_methods = "time: mid_range within days time: mean over days" ;
#     NC_CHAR tas:grid_mapping = "transverse_mercator" ;
#     NC_CHAR tas:coordinates = "latitude longitude" ;
#     NC_INT transverse_mercator ;
#     NC_CHAR transverse_mercator:grid_mapping_name = "transverse_mercator" ;
#     NC_DOUBLE transverse_mercator:longitude_of_prime_meridian = 0 ;
#     NC_DOUBLE transverse_mercator:semi_major_axis = 6377563.396 ;
#     NC_DOUBLE transverse_mercator:semi_minor_axis = 6356256.909 ;
#     NC_DOUBLE transverse_mercator:longitude_of_central_meridian = -2 ;
#     NC_DOUBLE transverse_mercator:latitude_of_projection_origin = 49 ;
#     NC_DOUBLE transverse_mercator:false_easting = 4e+05 ;
#     NC_DOUBLE transverse_mercator:false_northing = -1e+05 ;
#     NC_DOUBLE transverse_mercator:scale_factor_at_central_meridian = 0.9996012717 ;
#     NC_INT64 time(time) ;
#     NC_CHAR time:axis = "T" ;
#     NC_CHAR time:bounds = "time_bnds" ;
#     NC_CHAR time:units = "hours since 1800-01-01 00:00:00" ;
#     NC_CHAR time:standard_name = "time" ;
#     NC_CHAR time:calendar = "standard" ;
#     NC_INT64 time_bnds(bnds, time) ;
#     NC_DOUBLE projection_y_coordinate(projection_y_coordinate) ;
#     NC_CHAR projection_y_coordinate:axis = "Y" ;
#     NC_CHAR projection_y_coordinate:bounds = "projection_y_coordinate_bnds" ;
#     NC_CHAR projection_y_coordinate:units = "m" ;
#     NC_CHAR projection_y_coordinate:standard_name = "projection_y_coordinate" ;
#     NC_DOUBLE projection_y_coordinate_bnds(bnds, projection_y_coordinate) ;
#     NC_DOUBLE projection_x_coordinate(projection_x_coordinate) ;
#     NC_CHAR projection_x_coordinate:axis = "X" ;
#     NC_CHAR projection_x_coordinate:bounds = "projection_x_coordinate_bnds" ;
#     NC_CHAR projection_x_coordinate:units = "m" ;
#     NC_CHAR projection_x_coordinate:standard_name = "projection_x_coordinate" ;
#     NC_DOUBLE projection_x_coordinate_bnds(bnds, projection_x_coordinate) ;
#     NC_DOUBLE latitude(projection_x_coordinate, projection_y_coordinate) ;
#     NC_CHAR latitude:units = "degrees_north" ;
#     NC_CHAR latitude:standard_name = "latitude" ;
#     NC_DOUBLE longitude(projection_x_coordinate, projection_y_coordinate) ;
#     NC_CHAR longitude:units = "degrees_east" ;
#     NC_CHAR longitude:standard_name = "longitude" ;
# 
#     // global attributes:
#       NC_CHAR :comment = "Annual resolution gridded climate observations" ;
#       NC_CHAR :creation_date = "2024-05-17T09:50:50" ;
#       NC_CHAR :frequency = "ann" ;
#       NC_CHAR :institution = "Met Office" ;
#       NC_CHAR :references = "doi: 10.1002/gdj3.78" ;
#       NC_CHAR :short_name = "annual_meantemp" ;
#       NC_CHAR :source = "HadUK-Grid_v1.3.0.0" ;
#       NC_CHAR :title = "Gridded surface climate observations data for the UK" ;
#       NC_CHAR :version = "v20240514" ;
#       NC_CHAR :Conventions = "CF-1.7" ;
# }
# 
# ## monthly
# > nc_conn <- open.nc(here(data_dir_name, data_subdir, data_files_months_temprtr[7L]))
# > print.nc(nc_conn)
# netcdf netcdf4 {
#   dimensions:
#     time = 1 ;
#     projection_y_coordinate = 1450 ;
#     projection_x_coordinate = 900 ;
#     bnds = 2 ;
#     variables:
#       NC_DOUBLE tas(projection_x_coordinate, projection_y_coordinate, time) ;
#     NC_DOUBLE tas:_FillValue = 1e+20 ;
#     NC_INT64 tas:least_significant_digit = 3 ;
#     NC_CHAR tas:standard_name = "air_temperature" ;
#     NC_CHAR tas:long_name = "Mean air temperature" ;
#     NC_CHAR tas:units = "degC" ;
#     NC_CHAR tas:description = "Mean air temperature" ;
#     NC_STRING tas:label_units = "°C" ;
#     NC_CHAR tas:level = "1.5m" ;
#     NC_STRING tas:plot_label = "Mean air temperature at 1.5m (°C)" ;
#     NC_CHAR tas:cell_methods = "time: mid_range within days time: mean over days" ;
#     NC_CHAR tas:grid_mapping = "transverse_mercator" ;
#     NC_CHAR tas:coordinates = "latitude longitude month_number season_year" ;
#     NC_INT transverse_mercator ;
#     NC_CHAR transverse_mercator:grid_mapping_name = "transverse_mercator" ;
#     NC_DOUBLE transverse_mercator:longitude_of_prime_meridian = 0 ;
#     NC_DOUBLE transverse_mercator:semi_major_axis = 6377563.396 ;
#     NC_DOUBLE transverse_mercator:semi_minor_axis = 6356256.909 ;
#     NC_DOUBLE transverse_mercator:longitude_of_central_meridian = -2 ;
#     NC_DOUBLE transverse_mercator:latitude_of_projection_origin = 49 ;
#     NC_DOUBLE transverse_mercator:false_easting = 4e+05 ;
#     NC_DOUBLE transverse_mercator:false_northing = -1e+05 ;
#     NC_DOUBLE transverse_mercator:scale_factor_at_central_meridian = 0.9996012717 ;
#     NC_INT64 time(time) ;
#     NC_CHAR time:axis = "T" ;
#     NC_CHAR time:bounds = "time_bnds" ;
#     NC_CHAR time:units = "hours since 1800-01-01 00:00:00" ;
#     NC_CHAR time:standard_name = "time" ;
#     NC_CHAR time:calendar = "standard" ;
#     NC_INT64 time_bnds(bnds, time) ;
#     NC_DOUBLE projection_y_coordinate(projection_y_coordinate) ;
#     NC_CHAR projection_y_coordinate:axis = "Y" ;
#     NC_CHAR projection_y_coordinate:bounds = "projection_y_coordinate_bnds" ;
#     NC_CHAR projection_y_coordinate:units = "m" ;
#     NC_CHAR projection_y_coordinate:standard_name = "projection_y_coordinate" ;
#     NC_DOUBLE projection_y_coordinate_bnds(bnds, projection_y_coordinate) ;
#     NC_DOUBLE projection_x_coordinate(projection_x_coordinate) ;
#     NC_CHAR projection_x_coordinate:axis = "X" ;
#     NC_CHAR projection_x_coordinate:bounds = "projection_x_coordinate_bnds" ;
#     NC_CHAR projection_x_coordinate:units = "m" ;
#     NC_CHAR projection_x_coordinate:standard_name = "projection_x_coordinate" ;
#     NC_DOUBLE projection_x_coordinate_bnds(bnds, projection_x_coordinate) ;
#     NC_DOUBLE latitude(projection_x_coordinate, projection_y_coordinate) ;
#     NC_CHAR latitude:units = "degrees_north" ;
#     NC_CHAR latitude:standard_name = "latitude" ;
#     NC_DOUBLE longitude(projection_x_coordinate, projection_y_coordinate) ;
#     NC_CHAR longitude:units = "degrees_east" ;
#     NC_CHAR longitude:standard_name = "longitude" ;
#     NC_INT64 month_number ;
#     NC_CHAR month_number:units = "1" ;
#     NC_CHAR month_number:long_name = "month_number" ;
#     NC_INT64 season_year ;
#     NC_CHAR season_year:units = "1" ;
#     NC_CHAR season_year:long_name = "season_year" ;
#     
#     // global attributes:
#       NC_CHAR :comment = "Monthly resolution gridded climate observations" ;
#       NC_CHAR :creation_date = "2024-08-06T10:07:26" ;
#       NC_CHAR :frequency = "mon" ;
#       NC_CHAR :institution = "Met Office" ;
#       NC_CHAR :references = "doi: 10.1002/gdj3.78" ;
#       NC_CHAR :short_name = "monthly_meantemp" ;
#       NC_CHAR :source = "HadUK-Grid_Provisional" ;
#       NC_CHAR :title = "Gridded surface climate observations data for the UK" ;
#       NC_CHAR :version = "provisional" ;
#       NC_CHAR :Conventions = "CF-1.7" ;
# }