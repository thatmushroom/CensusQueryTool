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
  
  # Sidebar with dropdowns for different possible ACS+Census choices
  sidebarLayout(
    sidebarPanel(
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
      # Insert year
      selectInput(
        "input_year",
        h3("Select data year"),
        choices = year_list,
        selected = year_list[1]
      )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(plotOutput("cars"))
  ))

# Define server logic required to draw a histogram
server <- function(input, output) {
  # Fetch raw data ####
  output$cars <- renderPlot({
    # TODO: Break into pull_data(), transform_data(),  join_data()?
    #
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
      geometry = TRUE,
      # cache = TRUE,
      year = strtoi(input$input_year)
    )
    
    hh_df <- get_acs(
      state = input$input_state,
      county = input$input_county,
      geography = "tract",
      variables = "B11001_001",
      # TODO: Look up + comment this ACS varaible
      year = strtoi(input$input_year)
    )
    # End fetching of data
    
    # Begin data transformation
    cars_df %<>%
      rename(cars_estimate = estimate,
             cars_moe = moe) %>%
      mutate(
        cars_total_estimate = case_when(
          variable %in% c("B25044_003", "B25044_010") ~ 0 * cars_estimate,
          variable %in% c("B25044_004", "B25044_011") ~ 1 * cars_estimate,
          variable %in% c("B25044_005", "B25044_012") ~ 2 * cars_estimate,
          variable %in% c("B25044_006", "B25044_013") ~ 3 * cars_estimate,
          variable %in% c("B25044_007", "B25044_014") ~ 4 * cars_estimate,
          variable %in% c("B25044_008", "B25044_015") ~ 5 * cars_estimate
        )
      ) %>%
      mutate(
        cars_total_moe = case_when(
          variable %in% c("B25044_003", "B25044_010") ~ 0 * cars_moe,
          variable %in% c("B25044_004", "B25044_011") ~ 1 * cars_moe,
          variable %in% c("B25044_005", "B25044_012") ~ 2 * cars_moe,
          variable %in% c("B25044_006", "B25044_013") ~ 3 * cars_moe,
          variable %in% c("B25044_007", "B25044_014") ~ 4 * cars_moe,
          variable %in% c("B25044_008", "B25044_015") ~ 5 * cars_moe
        )
      ) %>%
      mutate(cars_total_se = cars_moe / 1.645,
             cars_total_se_2 = cars_total_se ^ 2)
    
    
    cars_by_geoid <- cars_df %>%
      group_by(GEOID) %>%
      summarise(
        cars_total_estimate = sum(cars_total_estimate),
        # cars_total_moe_sum = sum(cars_total_se),
        cars_total_moe = 1.645 * sqrt(sum(cars_total_se_2)),
        NAME = unique(NAME)
      )
    
    hh_df %<>%
      rename(hh_estimate = estimate,
             hh_moe = moe)
    # End data transformation
    
    # Begin geography - TODO -
    geoid <- left_join(cars_df %>%
                         select(-variable),
                       hh_df %>%
                         select(-c("NAME", "variable")),
                       by = "GEOID")
    
    df <- left_join(cars_by_geoid,
                    hh_df %>%
                      select(-c("NAME", "variable")),
                    by = "GEOID") %>%
      filter(GEOID != "06075980401") %>%
      mutate(cars_per_hh_estimate = cars_total_estimate / hh_estimate)
    
    
    
    # End geography
    # Assign the dataframe to the output object so it can be used elsewhere
    # Not entirely sure how to do within a reactive context
    #output$car_df <- isolate(df)???
    # TODO. May end up wrapping one function to create both output
    
    
    df %>%
      ggplot(aes(fill = cars_per_hh_estimate)) +
      geom_sf(color = NA) +
      coord_sf(crs = 26910) +
      scale_fill_viridis_c(option = "magma")
    
  })
  
  
}

# Run the application
shinyApp(ui = ui, server = server)
