library(shiny)
library(ggplot2)

#dataset <- diamonds

dataset <- read_csv(here("open_data", "rainfall", "aggreg_edinburgh_rainfall.csv"))

fluidPage(
  
  titlePanel("Edinburgh Rainfall by D4CAE"),
  
  sidebarPanel(
    
    sliderInput('timestamp', "the time/date hopefully", min=1, max=nrow(dataset),
                value=nrow(dataset), step=10, round=0),
    
    selectInput('value', 'mm rainfall', names(dataset)),
    selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
    selectInput('rain_station', 'Rain station name', c('None', names(dataset))),
    
    checkboxInput('jitter', 'Jitter'),
    checkboxInput('smooth', 'Smooth'),
    
    selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
    selectInput('facet_col', 'Facet Column', c(None='.', names(dataset)))
  ),
  
  mainPanel(
    plotOutput('plot')
  )
)