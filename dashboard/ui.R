library(shiny)
library(ggplot2)
library(readr)
library(here)

dataset <- read_csv(here("open_data", "rainfall", "aggreg_edinburgh_rainfall.csv"))
num_of_dates <- nrow(unique(test_dataset['Timestamp']))

fluidPage(
  
  titlePanel("Edinburgh Rainfall according to D4CAE"),
  
  sidebarPanel(
    
    sliderInput('timestamp', "dates", min=1, max=num_of_dates,
                value=nrow(dataset), step=10, round=0),
    
    selectInput('data column', 'rainfall aspects', names(dataset)),
    selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
    selectInput('rain_station', 'Rain station name', c('None', unique(dataset[["rain_station"]]))),
    
    checkboxInput('jitter', 'Jitter'),
    checkboxInput('smooth', 'Smooth'),
    
    selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
    selectInput('facet_col', 'Facet Column', c(None='.', names(dataset)))
  ),
  
  mainPanel(
    plotOutput('plot')
  )
)