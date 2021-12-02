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
source('./app_server.R')
source('./app_UI.R')



# Run the application
shinyApp(ui = ui, server = server)
