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
  filter(!(withinExpectedLimits == "false"))|> # approx 36,000 rows from 200,000
  rename(cycles_count = count) # rename to avoid confusion with R keyword 'count'

# Check dates are consistent
daily_cycling <- daily_cycling |>
  mutate(period_measured = as.Date(endTime) - as.Date(startTime))

# The following check confirms that the gap between start and end time
# is always 1 day. 
# unique(daily_cycling[["period_measured"]])
# [1] 1

# Plot
cycling_plot_data <- daily_cycling |>
  select(endTime, cycles_count)|>
  mutate(CountDate = as.Date(endTime)) |>
  group_by(CountDate) |>
  summarise(daily_total = sum(cycles_count)) 

  plot(cycling_plot_data)
  
daily_cycling_plot <- cycling_plot_data |>
  ggplot(aes(x = CountDate, y = sum))


# WALKING
CEC_daily_walking_COD_alldates <- read_csv(
  "open_data/travel/CEC_daily_walking_COD_alldates_30754514-027d-4365-9a50-d6672e099970.csv", 
                                            col_types = cols(endTime = col_character(), 
                                            startTime = col_character(), 
                                            validCountsDetected = col_character(), 
                                            withinExpectedLimits = col_character()))
