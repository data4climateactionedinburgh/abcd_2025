library(shiny)
library(ggplot2)
library(tidyverse)

# adapting for rainfall plot with SEPA data for edinburgh
# based on Posit demo using diamonds dataset
function(input, output) {
  
  rainfall_tbl <- tibble()
  stations <- read_csv("../open_data/rainfall/rain_stations_edinburgh.txt")
  
  dataset <- reactive({
    diamonds[sample(nrow(diamonds), input$sampleSize),]
  })
  
  output$plot <- renderPlot({
    
    p <- ggplot(dataset(), aes_string(x=input$x, y=input$y)) + geom_point()
    
    if (input$color != 'None')
      p <- p + aes_string(color=input$color)
    
    facets <- paste(input$facet_row, '~', input$facet_col)
    if (facets != '. ~ .')
      p <- p + facet_grid(facets)
    
    if (input$jitter)
      p <- p + geom_jitter()
    if (input$smooth)
      p <- p + geom_smooth()
    
    print(p)
    
  }, height=700)
  
}