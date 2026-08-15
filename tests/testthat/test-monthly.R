test_that("noaa_monthly validates its dates", {
  expect_error(noaa_monthly("USW00094728", "bad", "2024-12"), "YYYY-MM-DD")
  expect_error(
    noaa_monthly("USW00094728", "2024-12", "2024-01"),
    "must be before"
  )
})

test_that("noaa_monthly returns one row per month", {
  skip_on_cran()
  skip_if_offline()
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_monthly"))
  on.exit(options(op))

  df <- noaa_monthly("USW00094728", "2024-01", "2024-12", datatypes = "TAVG")
  expect_s3_class(df, "data.frame")
  expect_s3_class(df$date, "Date")
  expect_equal(nrow(df), 12)
  expect_false(is.unsorted(df$date))
})
