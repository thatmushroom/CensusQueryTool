
source('./ui_components/state_selector.R')
source('./ui_components/county_selector.R')
source('./ui_components/year_selector.R')

selection_sidebar <- function(state_list, county_list, year_list) {
  sidebarPanel(
    # Insert geography
    state_selector(state_list),
    county_selector(county_list),
    year_selector(year_list)
  )
}