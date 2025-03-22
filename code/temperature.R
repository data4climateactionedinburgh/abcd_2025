# Temperatures in Edinburgh and Scotland. 

# Read in the twelve files for each month's data from HadUK grid. 

library(ncdf4)
#library(ncdf4.helpers)
library(tidync) 
library(here)
library(CFtime) #Climate and Forecast metadata conventions

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

temperature_to_plot <- tibble()

# 2023 Annual data

# Import the 2023 annual data file ie not provisional
# tas_hadukgrid_uk_1km_ann_202301-202312.nc
filenm_temprtr_annual <- "tas_hadukgrid_uk_1km_ann_202301-202312.nc"
#nc_conn <- nc_open(here(data_dir_name, data_subdir, filenm_temprtr_annual))

temperature_to_plot <- get_tas_from_file(filenm_temprtr_annual, single_location_latlong)

# Cannot find a gridreference variable to use to filter / slice data. 
# Whereas, there are lat and longitude fields in both annual and month files. 




# 2024 monthly provisional data 
# Use March as an example data file
data_files_months_temprtr <-c("tas_hadukgrid_uk_1km_mon_202401.nc",
                              "tas_hadukgrid_uk_1km_mon_202402.nc",
                              "tas_hadukgrid_uk_1km_mon_202403.nc",
                              "tas_hadukgrid_uk_1km_mon_202404.nc",
                              "tas_hadukgrid_uk_1km_mon_202405.nc",
                              "tas_hadukgrid_uk_1km_mon_202406.nc",
                              "tas_hadukgrid_uk_1km_mon_202407.nc",
                              "tas_hadukgrid_uk_1km_mon_202408.nc",
                              "tas_hadukgrid_uk_1km_mon_202409.nc",
                              "tas_hadukgrid_uk_1km_mon_202410.nc",
                              "tas_hadukgrid_uk_1km_mon_202411.nc",
                              "tas_hadukgrid_uk_1km_mon_202412.nc"
)

for (i in 1:length(data_files_months_temprtr)){ # should be 12(!)
  rbind(temperature_to_plot, get_tas_from_file(data_files_months_temprtr[i], single_location_latlong) 
        
}

# function to return tibble of daily tas values with dates
get_tas_from_file <- function(filename, single_location_latlong){
  nc_conn <- nc_open(here(data_dir_name, data_subdir, filename))
}
