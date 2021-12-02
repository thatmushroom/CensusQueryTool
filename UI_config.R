## Data input config ####
library(tidyverse)

options(tigris_use_cache = TRUE)
# TODO: Make geographic data frame so a user can select state -> county
# tidycensus::fips_codes has this, but it's important to have filtering on state -> county in dropdowns first.
# This is thus a useful stub for prototyping
county_list <- c("Sacramento", "San Francisco", "Denver")
state_list <- c("CA", "CO")
geography_granularity <- c("tract")

# Data availability year
# TODO: Error-handling around ACS vs Census
year_list <- c(2018, 2016)


# Variable discovery config options
acs_matrix_options <-
  matrix(c(
    c(2020, "pl"),
    c(2010, "sf1"),
    c(2010, "sf2"),
    c(2000, "sf1"),
    c(2000, "sf2"),
    c(2000, "sf3"),
    c(2000, "sf4")
  ),
  byrow = TRUE, ncol = 2)
acs_matrix_options <-
  rbind(acs_matrix_options, cbind(2005:2019, c("acs1")), cbind(2009:2018, c("acs5")))
colnames(acs_matrix_options) <- c("year", "dataset_name")
acs_valid_options <- as_tibble(acs_matrix_options)
# TODO: Does not include island-area summary files yet
