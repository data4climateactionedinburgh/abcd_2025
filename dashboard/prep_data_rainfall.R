# prep_data_rainfall.R
# Pauline Ward
# 2 April 2025

library(purrr)
library(here)


data_struc <- list()

rain_filenames <- 
  list.files(path = here("open_data", "rainfall"), pattern = '.csv')[!str_detect(rain_filenames, "rain_stations")]
map()