library(shiny)
library(ggplot2)
library(tidyverse)
library(here)

# adapting for rainfall plot with SEPA data for edinburgh
# based on Posit demo using diamonds dataset

function(input, output) {
  
  rainfall_tbl <- tibble()
  # If below path producing an error, remember to run following in console: 
  # setwd(dashboard) # as per README_dashboard.md
  stations <- read_csv("../open_data/rainfall/rain_stations_edinburgh.csv")
  aggreg_rain_df <- read_csv(here("open_data", "rainfall", "aggreg_edinburgh_rainfall.csv"))
  
  dataset <- reactive({
    aggreg_rain_df
  })
  
  output$plot <- renderPlot({
    
    p <- ggplot(dataset(), aes_string(x=input$timestamp_slider, y=input$rainfall_station_dropdown)) + geom_point()
    
    if (input$facet_row != 'None')
      p <- p + aes_string(Individual_station=input$facet_row)
    
    facets <- paste(input$facet_col, '~', input$facet_col)
    if (facets != '. ~ .')
      p <- p + facet_grid(facets)
    
    if (input$jitter)
      p <- p + geom_jitter()
    if (input$smooth)
      p <- p + geom_smooth()
    
    print(p)
    
  }, height=700)
  
}
