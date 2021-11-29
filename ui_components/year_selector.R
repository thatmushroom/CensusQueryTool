year_selector <- function(year_list) {
    selectInput(
    "input_year",
    h3("Select data year"),
    choices = year_list,
    selected = year_list[1]
  )
}