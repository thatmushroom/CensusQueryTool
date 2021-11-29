car_data_frame <- function(input) {
  get_acs(
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
}