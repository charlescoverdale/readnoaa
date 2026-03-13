test_that("noaa_monthly returns expected structure", {
  skip_on_cran()
  skip_if_offline()

  df <- noaa_monthly("USW00094728", "2024-01", "2024-06")

  expect_s3_class(df, "data.frame")
  expect_true("station" %in% names(df))
  expect_true("date" %in% names(df))
  expect_s3_class(df$date, "Date")
  expect_true(nrow(df) > 0)
})

test_that("noaa_monthly validates dates", {
  expect_error(noaa_monthly("USW00094728", "bad", "2024-06"), "YYYY-MM-DD")
})
