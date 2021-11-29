# README

Initial readme for this shiny app. It has two separate apps at the moment, one
for exploring Census+ACS variables, and one for processing specific data
questions.

## To get started w/in RStudio

New Project -> Version Control -> Git -> put in this repository URL. You can
then open the app.R or app_variable_explorer.R file w/in Rstudio and hit the Run
App button to test-drive it.

## Get git

Git is a lot to take in, but this is an RStudio-specific workflow for getting
set up. It's worth a read, and - at some point - work through Installation and
Connecting Git, GitHub, RStudio sections. That will at least get you set up to
collaborate through github <https://happygitwithr.com/index.html>

## Census API Key

You'll have to get one here: <https://api.census.gov/data/key_signup.html>

You'll have to load it into your environment file by running this in your
RStudio console: `tidycensus::census_api_key()`.
