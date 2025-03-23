# Active Travel statistics
# Show baseline statistics for active travel 

library(tidyverse)

# Cycling
CEC_daily_cycling_COD_alldates <- read_csv(
  "open_data/travel/CEC_daily_cycling_COD_81ffd7b0-e615-47e4-8c42-54cc62fca3cd.csv", 
                                          col_types = cols(endTime = col_character(), 
                                          startTime = col_character(), update = col_character(), 
                                          validCountsDetected = col_character(), 
                                          withinExpectedLimits = col_character()))
# data cleaning
# remove outliers
daily_cycling <- CEC_daily_cycling_COD_alldates |>
  filter(!is.na(withinExpectedLimits))


# WALKING
CEC_daily_walking_COD_alldates <- read_csv(
  "open_data/travel/CEC_daily_walking_COD_alldates_30754514-027d-4365-9a50-d6672e099970.csv", 
                                            col_types = cols(endTime = col_character(), 
                                            startTime = col_character(), 
                                            validCountsDetected = col_character(), 
                                            withinExpectedLimits = col_character()))
