# prep_data_rainfall.R
# Pauline Ward
# 2 April 2025

library(tidyverse)
library(here)
library(stringi)

# run the data prep for daily, monthly or both
periodicity <- "monthly"

all_rain_stations_data <- tibble()

# Read in the filenames of rain data
rain_filenames <- 
  list.files(path = here("open_data", "rainfall"), pattern = '.csv')

# Exclude the lookup file containing the stations' names
rain_filenames <- 
  rain_filenames[!str_detect(rain_filenames, "rain_stations|aggreg")] 
  

# Add a column containing rain station name, parsed out of filename
for (onefile in rain_filenames){
  #Read in file to tibble, then add a column containing first word of name
  rain_df <- read_csv(here("open_data", "rainfall", onefile)) |>
    mutate(rain_station = as.character(stri_match(onefile, regex = "^.*?_", mode = 'last'))) |>
    mutate(rain_station = stri_replace(rain_station, fixed = "_", replacement = ""))|>
    rename(rainfall_in_mm = "Value")
  
  all_rain_stations_data <- rbind(all_rain_stations_data, rain_df)
}

# Add mean values for all Edinburgh stations, for a given timestamp
all_rain_stations_data |>
  group_by("Timestamp") |>
  summarise(Edinburgh_mean = avg(rainfall_in_mm))

# Save into a file for shiny to pick up. 
# Set row.names to not add unnamed column just containing row numbers.
write.csv(rain_all_stations_data, here("open_data", "rainfall", "aggreg_edinburgh_rainfall.csv"), row.names = FALSE)
