# prep_data_rainfall.R
# Pauline Ward
# 2 April 2025

library(tidyverse)
library(here)
library(stringi)

rain_all_stations_data <- tibble()

# Read in the filenames of rain data
rain_filenames <- 
  list.files(path = here("open_data", "rainfall"), pattern = '.csv')

# Exclude the lookup file containing the stations' names
rain_filenames <- 
  rain_filenames[!str_detect(rain_filenames, "rain_stations")]

# Add a column containing rain station name, parsed out of filename
for (onefile in rain_filenames){
  #Read in file to tibble, then add a column containing first word of name
  rain_df <- read_csv(here("open_data", "rainfall", onefile)) |>
    mutate(rain_station = as.character(stri_match(onefile, regex = "^.*?_", mode = 'last')))
  rain_all_stations_data <- rbind(rain_all_stations_data, rain_df)
}


