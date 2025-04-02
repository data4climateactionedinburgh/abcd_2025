# README  - dashboard folder

Attempting to plot rainfall data from SEPA on Posit's shiny.io, 
following tutorial at https://shiny.posit.co/r/getstarted/ .

Cannot rename server.R. 

Remember to run the following in the console: 

setwd("dashboard")
library(shiny)
runApp()

When ready to publish: 

deployApp()

Excluded the Torduff data, as it contained over two hundred stations, 
with just one row each in the CSV, ie different layout to other data files. 