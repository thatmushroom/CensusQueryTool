county_selector <- function(county_list) {
    selectInput(
    "input_county",
    h3("Select county"),
    choices = county_list,
    selected = county_list[1]
  )
}