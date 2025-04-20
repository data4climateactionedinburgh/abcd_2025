# wee_flowers_tests.R
# Just some test code 
# to try out rowwise data manipulation
# so I can use it for the rainfall dashboard. 

library(stringi)
library(tidyverse)

# Iris dataset
wee_flowers <- head(iris, 5)

other_wee_flowers <- head( iris |> filter(stri_cmp_eq({Species}, "virginica")), 7)

wee_flowers <- rbind(wee_flowers, other_wee_flowers)

wee_flowers |> rowwise() # at the console, makes little visible difference

wee_flowers |> ungroup()  # at the console, makes little visible difference

# Made-up rainfall dummy data
rain_stations <- c("Morningside", "Leith", "Pentland Hills")
dummy_precipitation <- tibble(date_of_measurement = c("Monday1", "Tuesday2",
                                                       "Monday1", "Monday1",
                                                       "Tuesday2", "Tuesday2",
                                                       "Weds3rd", "Thurs", "Mon 8th"),
                              Morningside_rain_mm = c(5.7, 4.9, 2.8, 1.9, 1.8, 1.7, 1.6, 1.1, 0.3),
                              Leith_rain_mm = c(5.7, 4.9, 0.0, 0.9, 1.8, 0.7, 1.1, 1.1, 0.3),
                              Pentland_rain_mm = c(6.4, 7.9, 8.2, 5.9, 1.8, 3.7, 2.5, 1.4, 0.7),
)

# Geeks for geeks https://www.geeksforgeeks.org/row-wise-operation-in-r-using-dplyr/?ref=header_outind
# Using summarise method
# The summarise method is used to create a summary of the values across the 
# data rows that fall within one column. It is preferably used with a group_by 
# method and the output data contains one row for each of the groups present 
# in the column for which the group_by method is invoked. 
# Good explanation of Across!
# Actually may have found code I probably need (?! not working) in 
# https://stackoverflow.com/questions/72044720/r-insert-row-with-mean-after-group-of-values 
# not working
precipttn_wt_means <- other_precipitation |>
  group_by(date_of_measurement) |>
  mutate(mean_rain = mean(rain_mm)) |>
  ungroup()

# Iteration as per ch26 of R4DS2e ie use purrr and map() rather than loops 
# Create more verbose, nicer examples for learning
# count the number of observations and compute the median of every column
# copy and paste approach for the comparison
dummy_precipitation |> summarise(
 n = n(),
 medn_Mornside = median(Morningside_rain_mm),
 medn_Leith = median(Leith_rain_mm),
 medn_Pentland = median(Pentland_rain_mm)
) 

# Use across, slightly better
# 'across these columns, apply these functions across(.cols, .fns)
# .. where the dot just tells us it's an arg that may be passed to another funcn
# .. the dot avoids naming collisions. 
dummy_precipitation |> summarise(
  n = n(),
  across(Pentland_rain_mm:Morningside_rain_mm, median)
)

dummy_precipitation |> summarise(
  across(ends_with("rain_mm"), mean)
)
