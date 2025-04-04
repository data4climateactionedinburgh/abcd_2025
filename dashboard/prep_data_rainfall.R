# prep_data_rainfall.R
# Pauline Ward
# 2 April 2025

library(tidyverse)
library(here)
library(stringi)

rain_all_stations_data <- tibble()

# Read in the filenames of rain data
rain_filenames <- 
  list.files(path = here("open_data", "rainfall"), pattern = '.csv', full.names = TRUE)

# Exclude the lookup file containing the stations' names
rain_filenames <- 
  rain_filenames[!str_detect(rain_filenames, "rain_stations")]

for (onefile in rain_filenames){
  #Read in file to tibble, then add a column containing first word of name
  rain_df <- read_csv(onefile) |>
    mutate(rain_station = stri_match(onefile, "^.[1..20]\b"))
  rain_all_stations_data <- rbind(rain_all_stations_data, rain_df)
}

#rain_data_struc <- map(rain_filenames, read_csv)

map()