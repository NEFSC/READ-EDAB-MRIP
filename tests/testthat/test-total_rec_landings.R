test_that("total_rec_landings returns expected structure", {
  expect_s3_class(total_rec_landings, "data.frame")
  expect_true("TOTAL_LANDINGS" %in% names(total_rec_landings))
})
