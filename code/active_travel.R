# Active Travel statistics
# Show baseline statistics for active travel 

library(tidyverse)

# WALKING
CEC_daily_walking_COD_alldates <- read_csv(
  "open_data/travel/CEC_daily_walking_COD_alldates_30754514-027d-4365-9a50-d6672e099970.csv", 
                                            col_types = cols(endTime = col_character(), 
                                            startTime = col_character(), 
                                            validCountsDetected = col_character(), 
                                            withinExpectedLimits = col_character()))
