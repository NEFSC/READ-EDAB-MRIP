test_that("rec_trips has intended columns", {
  # Define a mock groupby_state for test context
  groupby_state <- function(.data, groupby = FALSE) {
    if (groupby) {
      dplyr::group_by(.data, STATE)
    } else {
      dplyr::mutate(.data, STATE = "All") |> dplyr::group_by(STATE)
    }
  }

  test_file <- testthat::test_path("test-data", "rec_trips_test.csv")

  rec_trips <- create_rec_trips(
    files = test_file,
    group_by_state_fn = groupby_state,
    group_by_state = FALSE
  )


  expect_equal(
    names(rec_trips),
    c('CATEGORY', 'INDICATOR_TYPE', 'INDICATOR_NAME', 'INDICATOR_UNITS', 'STATE', 'DATA_VALUE')
  )
})


