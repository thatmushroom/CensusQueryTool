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
        choices = sort(unique(acs_valid_options$year))
      ),
      actionButton("go","Fetch Data")
    ),
    
    # Show the table results
    mainPanel(dataTableOutput("available_variables"))
  ))

# Define server logic required to pull data
server <- function(input, output) {
  # Fetch raw data ####
  
  
  data_return <- eventReactive(input$go,{
    available_variables <- load_variables(
      year = input$input_year,
      dataset = input$input_dataset,
      cache = TRUE
    )
  })
  
  output$available_variables <- renderDataTable(data_return())
  
}

# Run the application
shinyApp(ui = ui, server = server)
