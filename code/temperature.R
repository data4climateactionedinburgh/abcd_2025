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

# 2023 Annual data

# Import the 2023 annual data file ie not provisional
# tas_hadukgrid_uk_1km_ann_202301-202312.nc
filenm_temprtr_annual <- "tas_hadukgrid_uk_1km_ann_202301-202312.nc"
nc_conn <- nc_open(here(data_dir_name, data_subdir, filenm_temprtr_annual))

# Cannot find a gridreference variable to use to filter / slice data. 
# Whereas, there are lat and longitude fields in both annual and month files. 




# 2024 monthly provisional data 
# Use March as an example data file
data_filenm_month_temprtr <- "tas_hadukgrid_uk_1km_mon_202403.nc"

# try using tidync instead of nc_open()
tidy_temperature_conn <- tidync(here(data_dir_name, data_subdir, data_filenm_month_temprtr))



