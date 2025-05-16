source(here::here("tests/testthat/helper.R"))
source(here::here("R/groupby_state.R"))

test_that("rec_landings is correct structure", {
  # Set up input data
  input_data <- read.csv(here::here("inputs", "mrip_BLACK_SEA_BASS_harvest_update040325.csv"),
                         skip = 46,
                         na.strings = ".") |>
    janitor::clean_names(case = "all_caps")

  # Call the function you're testing
  total_rec_landings <- create_total_rec_landings(input_data)

  # Perform the test
  expect_true("INDICATOR_TYPE" %in% names(total_rec_landings))
})
