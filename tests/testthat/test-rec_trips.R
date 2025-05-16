test_that("rec_trips is a data frame with expected columns", {
  # Use the pipeline output — not a fresh call
  expect_s3_class(rec_trips, "data.frame")
  expect_true(all(c("YEAR", "TRIPS") %in% names(rec_trips)))
})

