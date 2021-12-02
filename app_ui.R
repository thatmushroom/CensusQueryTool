# Define UI for application 
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