test_that("noaa_annual validates its dates", {
  expect_error(noaa_annual("USW00094728", "bad", "2024-01-01"), "YYYY-MM-DD")
  expect_error(
    noaa_annual("USW00094728", "2024-01-01", "2020-01-01"),
    "must be before"
  )
})

test_that("noaa_annual returns one row per year", {
  skip_on_cran()
  skip_if_offline()
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_annual"))
  on.exit(options(op))

  df <- noaa_annual("USW00094728", "2020-01-01", "2024-01-01",
                    datatypes = "TAVG")
  expect_s3_class(df, "data.frame")
  expect_s3_class(df$date, "Date")
  expect_equal(nrow(df), 5)
  expect_false(is.unsorted(df$date))
})
