# wee_flowers_tests.R
# Just some test code 
# to try out rowwise data manipulation
# so I can use it for the rainfall dashboard. 

wee_flowers <- head(iris, 5)

wee_flowers <- rbind(wee_flowers, head(iris|>filter(Species=="virginica"), 7))

wee_flowers |> rowwise() # at the console, makes little visible difference

wee_flowers |> ungroup()  # at the console, makes little visible difference

other_precipitation <- tibble(date_of_measurement <- c("Monday1", "Tuesday2",
                                                       "Weds3rd", "Thurs", "Mon 8th"),
                              rain_mm <- c(5.7, 4.9, 2.8, 1.1, 0.3))

# Geeks for geeks https://www.geeksforgeeks.org/row-wise-operation-in-r-using-dplyr/?ref=header_outind
# Using summarise method
# The summarise method is used to create a summary of the values across the 
# data rows that fall within one column. It is preferably used with a group_by 
# method and the output data contains one row for each of the groups present 
# in the column for which the group_by method is invoked. 
# Good explanation of Across!
# Actually found code I need in 
# https://stackoverflow.com/questions/72044720/r-insert-row-with-mean-after-group-of-values 
