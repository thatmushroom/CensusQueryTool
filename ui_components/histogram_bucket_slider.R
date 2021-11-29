
library(shiny)

histogram_buckets_slider <- sliderInput(
  "bins",
  "Number of bins:",
  min = 1,
  max = 50,
  value = 30
)