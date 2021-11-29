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

# Load UI Components
source('./ui_components/selection_sidebar.R')

# Load data models
source('./models/car_data_frame.R')

# Define UI for application that draws a histogram
ui <- fluidPage(# Application title
  titlePanel("Census Data"),
  
  
  sidebarLayout(
    # Sidebar with a slider input for number of bins, and drop down selectors
    # for county state and year
    selection_sidebar(state_list, county_list, year_list),
    
    # A table of "cars"
    mainPanel(tableOutput("cars"))
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  # Fetch raw data #### 
  output$cars <- renderTable({
    cars_df <- car_data_frame(input)
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
