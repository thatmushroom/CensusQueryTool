state_selector <- function(state_list) {
  selectInput(
  "input_state",
  h3("Select state"),
  choices = state_list,
  selected = state_list[1]
)
}