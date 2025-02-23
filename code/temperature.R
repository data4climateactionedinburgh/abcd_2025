# Temperatures in Edinburgh and Scotland. 

# Read in the twelve files for each month's data from HadUK grid. 

library(ncdf4)
library(ncdf4.helpers)
library(tidync)
library(here)

data_dir_name <- "data" 
data_subdir <- "temperature_HadUK_Grid"
# Use March as an example data file
data_filenm_temprtr <- "tas_hadukgrid_uk_1km_mon_202403.nc"

# import one month's data
temperature_data <- nc_open(here(data_dir_name, data_subdir, data_filenm_temprtr))


# call ncvar_get() to access data from a varbl
temperature_data |> 
  ncvar_get(varid = "format")

print(temperature_data)

# Identify grid refs for Edinburgh