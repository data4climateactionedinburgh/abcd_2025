# Don't forget to setwd() as a one-off operation: 
# setwd("tutorial_dashbd")

library(shiny)
library(bslib) # bootstrap library

# Shiny apps live in a single script called app.R 
# with a ui *object* and a server *function*. 
# https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/



# Define UI for app that draws a histogram ----
ui <- page_sidebar(
  # App title ----
  title = "Hello Shiny!",
  # Sidebar panel for inputs ----
  sidebar = sidebar(
    # Input: Slider for the number of bins ----
    sliderInput(
      inputId = "bins",
      label = "Give me the number of bins pls asap:",
      min = 1,
      max = 50,
      value = 30
    )
  ),
  # Output: Histogram ----
  plotOutput(outputId = "distPlot")
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$distPlot <- renderPlot({
    
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # Nice colours to represent rain:
    # #11AAFF bright blue
    # #AABBCC bluish grey
    hist(x, breaks = bins, col = "#11AAFF", border = "#AABBCC",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of geyser pause times")
    
  })
  
}
shinyApp(ui = ui, server = server)
# runApp()
