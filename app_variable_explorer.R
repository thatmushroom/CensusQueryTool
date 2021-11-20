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
  titlePanel("Variable Explorer"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      # Insert year and data product
      # TODO: Validate based on acs_valid_options
      selectInput(
        "input_dataset",
        h3(
          "Select data product - Note that not all options are available for all years"
        ),
        choices = unique(acs_valid_options$dataset_name)
      ),
      selectInput(
        "input_year",
        h3("Select data year"),
        choices = unique(acs_valid_options$year)
      ),
      
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(tableOutput("available_variables"))
  ))

# Define server logic required to draw a histogram
server <- function(input, output) {
  # Fetch raw data ####
  output$available_variables <- renderTable({
    available_variables <- load_variables(
      year = input$input_year,
      dataset = input$input_dataset,
      cache = TRUE
    )
    # year = 2020,
    # dataset = "pl",
    # cache = TRUE)
    # Subset for testing sake
    available_variables %<>% slice_head(n = 10)
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
