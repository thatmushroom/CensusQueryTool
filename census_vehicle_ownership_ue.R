
# 1. Load packages --------------------------------------------------------
library(tidycensus)
library(leaflet)
library(mapview)
library(tidyverse)
library(magrittr)

# census_api_key("YOUR_KEY_HERE", install = TRUE)

# 2. Load data ------------------------------------------------

yr = 2018
county = "Sacramento"

cars <- get_acs(state = "CA", 
                county = county, 
                geography = "tract", 
                variables = c("B25044_003", 
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
                              "B25044_015"), 
                geometry = TRUE,
                year = yr)

hh <- get_acs(state = "CA",
              county = county,
              geography = "tract",
              variables = "B11001_001",
              year = yr)

# rail transit
# http://opendata.mtc.ca.gov/datasets/passenger-rail-stations-2019?geometry=-122.594%2C37.730%2C-122.333%2C37.777
# http://tidytransit.r-transit.org/articles/frequency.html

# 3. Process data ---------------------------------------------------------

cars %<>%
  rename(cars_estimate = estimate,
         cars_moe = moe) %>%
  mutate(cars_total_estimate = case_when(
    variable %in% c("B25044_003", "B25044_010") ~ 0 * cars_estimate,
    variable %in% c("B25044_004", "B25044_011") ~ 1 * cars_estimate,
    variable %in% c("B25044_005", "B25044_012") ~ 2 * cars_estimate,
    variable %in% c("B25044_006", "B25044_013") ~ 3 * cars_estimate,
    variable %in% c("B25044_007", "B25044_014") ~ 4 * cars_estimate,
    variable %in% c("B25044_008", "B25044_015") ~ 5 * cars_estimate
  )
  ) %>%
  mutate(cars_total_moe = case_when(
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

# https://acsdatacommunity.prb.org/acs-data-issues/acs-basics/f/10/t/292
# https://www2.census.gov/programs-surveys/acs/tech_docs/statistical_testing/2015StatisticalTesting5year.pdf
cars_by_geoid <- cars %>%
  group_by(GEOID) %>%
  summarise(cars_total_estimate = sum(cars_total_estimate),
            # cars_total_moe_sum = sum(cars_total_se),
            cars_total_moe = 1.645 * sqrt(sum(cars_total_se_2)),
            NAME = unique(NAME)) 

hh %<>%
  rename(hh_estimate = estimate,
         hh_moe = moe)

geoid <- left_join(cars %>%
                     select(-variable), 
                   hh %>%
                     select(-c("NAME", "variable")), 
                   by = "GEOID")

df <- left_join(cars_by_geoid %>%
                  select(-geometry), 
                hh %>%
                  select(-c("NAME", "variable")), 
                by = "GEOID") %>%
  filter(GEOID != "06075980401") %>%
  mutate(cars_per_hh_estimate = cars_total_estimate / hh_estimate)

head(df) 

df %>%
  ggplot(aes(fill = cars_per_hh_estimate)) +
  geom_sf(color = NA) + 
  coord_sf(crs = 26910) + 
  scale_fill_viridis_c(option = "magma") 
