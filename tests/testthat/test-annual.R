test_that("noaa_annual returns expected structure", {
  skip_on_cran()
  skip_if_offline()

  df <- noaa_annual("USW00094728", "2020-01-01", "2024-01-01")

  expect_s3_class(df, "data.frame")
  expect_true("station" %in% names(df))
  expect_true("date" %in% names(df))
  expect_true(nrow(df) > 0)
})

test_that("noaa_annual validates dates", {
  expect_error(noaa_annual("USW00094728", "bad", "2024"), "YYYY-MM-DD")
})
