test_that("noaa_daily returns expected structure", {
  skip_on_cran()
  skip_if_offline()

  df <- noaa_daily("USW00094728", "2024-01-01", "2024-01-07",
                   datatypes = c("TMAX", "TMIN"))

  expect_s3_class(df, "data.frame")
  expect_true("station" %in% names(df))
  expect_true("date" %in% names(df))
  expect_s3_class(df$date, "Date")
  expect_type(df$station, "character")
  expect_true(nrow(df) > 0)
})

test_that("noaa_daily validates dates", {
  expect_error(noaa_daily("USW00094728", "bad-date", "2024-01-07"), "YYYY-MM-DD")
})

test_that("noaa_daily rejects start after end", {
  expect_error(
    noaa_daily("USW00094728", "2024-06-01", "2024-01-01"),
    "must be before"
  )
})

test_that("noaa_daily accepts YYYY-MM dates", {
  skip_on_cran()
  skip_if_offline()

  df <- noaa_daily("USW00094728", "2024-01", "2024-01",
                   datatypes = c("TMAX"))
  expect_s3_class(df, "data.frame")
})

test_that("noaa_daily temperature values are plausible", {
  skip_on_cran()
  skip_if_offline()

  df <- noaa_daily("USW00094728", "2024-07-01", "2024-07-07",
                   datatypes = c("TMAX"))
  if ("tmax" %in% names(df)) {
    expect_true(all(df$tmax > -60 & df$tmax < 60, na.rm = TRUE))
  }
})
