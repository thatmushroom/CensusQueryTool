#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidycensus)
library(tidyverse)
library(magrittr)

# Load config file
source('./UI_config.R')

# Define UI for application that draws a histogram
ui <- fluidPage(# Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        "bins",
        "Number of bins:",
        min = 1,
        max = 50,
        value = 30
      ),
      # Insert geography
      selectInput(
        "input_state",
        h3("Select state"),
        choices = state_list,
        selected = state_list[1]
      ),
      selectInput(
        "input_county",
        h3("Select county"),
        choices = county_list,
        selected = county_list[1]
      ),
      selectInput(
        "input_year",
        h3("Select data year"),
        choices = year_list,
        selected = year_list[1]
      )
    ),
    
    # Show a plot of the generated distribution
    # mainPanel(plotOutput("distPlot"))
    mainPanel(tableOutput("cars"))
  ))

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x,
         breaks = bins,
         col = 'darkgray',
         border = 'white')
  })
  
  # Fetch raw data ####
  output$cars <- renderTable({
    cars_df <- get_acs(
      state = input$input_state,
      county = input$input_county,
      geography = "tract",
      variables = c(
        "B25044_003",
        "B25044_004",
        "B25044_005",
        "B25044_006",
        "B25044_007",
        "B25044_008",
        "B25044_010",
        "B25044_011",
        "B25044_012",
        "B25044_013",
        "B25044_014",
        "B25044_015"
      ),
      cache_table = TRUE,
      geometry = FALSE,
      year = strtoi(input$input_year)
    )
    # Subset for testing sake
    cars_df %<>% slice_head(n = 10)
    
    
    hh <- get_acs(
      state = input$input_state,
      county = input$input_county,
      geography = "tract",
      variables = "B11001_001",
      year = strtoi(input$input_year)
    )
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
