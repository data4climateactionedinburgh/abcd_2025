# Temperatures in Edinburgh and Scotland. 

# Read in the twelve files for each month's data from HadUK grid. 

library(ncdf4)
#library(ncdf4.helpers)
#library(tidync) 
library(here)
library(tidyverse)
library(stringi)

# Plot a chart of the daily temperature in Edinburgh in 2023 and 2024.

# Data from Met Office's HadUK Grid, released by Met Office under the OGL 
# - see README.md for further details. 

data_dir_name <- "open_data" 
data_subdir <- "temperature_HadUK_Grid"

# Identify OS grid refs for Edinburgh - grid square NT
# one 1km grid in central Edinburgh, inc the ECCAN office on Forth St
single_location_gridref <- "NT 25981 74498"
# Cannot find variable for gridref, so use lat and longitude
single_location_latlong <- c(55.91174,-3.27710)

# Cannot find a gridreference variable to use to filter / slice data. 
# Whereas, there are lat and longitude fields in both annual and month files. 
# Time units: hours since 1800-01-01 00:00:00

temperature_to_plot <- tibble()

# function to return tibble of daily tas values with dates
get_tas_from_file <- function(filename, single_location_latlong){
  nc_conn <- nc_open(here(data_dir_name, data_subdir, filename))
  tas_from_file <- tibble()
  tas_from_file$tas  <- ncvar_get(nc_conn, varid = "tas")
  tas_from_file$time  <- ncvar_get(nc_conn, varid = "time")
  
  return(tas_from_file)
}

# 2023 Annual data

# Import the 2023 annual data file ie not provisional
# tas_hadukgrid_uk_1km_ann_202301-202312.nc
filenm_temprtr_annual <- "tas_hadukgrid_uk_1km_ann_202301-202312.nc"
#nc_conn <- nc_open(here(data_dir_name, data_subdir, filenm_temprtr_annual))

temperature_to_plot <- get_tas_from_file(filenm_temprtr_annual, single_location_latlong)
# Error in `$<-`:
#   ! Assigned data `ncvar_get(nc_conn, varid = "tas")` must be compatible with existing data.
# ✖ Existing data has 0 rows.
# ✖ Assigned data has 900 rows.
# ℹ Only vectors of size 1 are recycled.

# 2024 monthly provisional data 

# use dir() to get filenames, similar to glob
files_temprtr_folder <- dir(path = here(data_dir_name,data_subdir))
data_files_months_temprtr <-  stri_subset_regex(files_temprtr_folder, pattern = "tas_hadukgrid_uk_1km_mon") 


for (i in 1:length(data_files_months_temprtr)){ #should be 12(!)
  temperature_to_plot <- 
    rbind(temperature_to_plot, get_tas_from_file(data_files_months_temprtr[i], single_location_latlong)) 
}

temperature_data_csv_filename <- "my_csv_temperature.csv"
write.csv2(temperature_to_plot, temperature_data_csv_filename)
plot(temperature_to_plot)
