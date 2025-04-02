# prep_data_rainfall.R
# Pauline Ward
# 2 April 2025

library(tidyverse)
library(here)


rain_data_struc <- list()

# Read in the filenames of rain data
rain_filenames <- 
  list.files(path = here("open_data", "rainfall"), pattern = '.csv', full.names = TRUE)
rain_filenames <- 
  rain_filenames[!str_detect(rain_filenames, "rain_stations")]

rain_data_struc <- map(rain_filenames, read_csv)

map()