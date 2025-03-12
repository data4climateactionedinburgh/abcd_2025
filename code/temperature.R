# Temperatures in Edinburgh and Scotland. 

# Read in the twelve files for each month's data from HadUK grid. 

library(ncdf4)
library(ncdf4.helpers)
library(tidync)
library(here)

# Data from Met Office's HadUK Grid, released by Met Office under the OGL 
# - see README.md for further details. 

data_dir_name <- "open_data" 
data_subdir <- "temperature_HadUK_Grid"
# Use March as an example data file
data_filenm_temprtr <- "tas_hadukgrid_uk_1km_mon_202403.nc"

# Or the annual one: 
# Import the 2023 annual data file ie not provisional
# tas_hadukgrid_uk_1km_ann_202301-202312.nc
data_filenm_temprtr <- "tas_hadukgrid_uk_1km_ann_202301-202312.nc"


# use tidync instead of nc_open()
imported_temperature <- tidync(here(data_dir_name, data_subdir, data_filenm_temprtr))

imported_temperature


# Identify OS grid refs for Edinburgh - grid square NT
# one 1km grid in central Edinburgh, inc the ECCAN office on Forth St
single_location <- "NT 25981 74498"



## Old
# import one month's data
# nctemperature_data <- nc_open(here(data_dir_name, data_subdir, data_filenm_temprtr))
# call ncvar_get() to access data from a varbl, not working
#temperature_data |> 
# ncvar_get(varid = "format")

#print(temperature_data)
