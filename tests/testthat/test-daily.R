test_that("noaa_daily validates its dates", {
  expect_error(noaa_daily("USW00094728", "bad", "2024-01-31"), "YYYY-MM-DD")
  expect_error(noaa_daily("USW00094728", "2024-01-01", "bad"), "YYYY-MM-DD")
  expect_error(
    noaa_daily("USW00094728", "2024-06-01", "2024-01-01"),
    "must be before"
  )
})

test_that("noaa_daily returns tidy daily observations", {
  skip_on_cran()
  skip_if_offline()
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_daily"))
  on.exit(options(op))

  df <- noaa_daily("USW00094728", "2024-01-01", "2024-01-31",
                   datatypes = c("TMAX", "TMIN"))
  expect_s3_class(df, "data.frame")
  expect_true(all(c("station", "date", "tmax", "tmin") %in% names(df)))
  expect_s3_class(df$date, "Date")
  expect_type(df$station, "character")
  expect_equal(nrow(df), 31)
  expect_false(is.unsorted(df$date))
})

test_that("an unfiltered request drops the columns the station never reports", {
  skip_on_cran()
  skip_if_offline()
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_daily"))
  on.exit(options(op))

  wide <- noaa_daily("USW00094728", "2024-01-01", "2024-01-31",
                     drop_empty = FALSE)
  trim <- noaa_daily("USW00094728", "2024-01-01", "2024-01-31")

  expect_lt(ncol(trim), ncol(wide))
  expect_true(all(c("station", "date", "tmax", "tmin") %in% names(trim)))
})

test_that("multi-year requests are chunked and recombined", {
  skip_on_cran()
  skip_if_offline()
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_daily"))
  on.exit(options(op))

  df <- noaa_daily("USW00094728", "2022-06-01", "2024-06-01",
                   datatypes = "TMAX")
  expect_gt(nrow(df), 700)
  expect_false(is.unsorted(df$date))
  expect_equal(sum(duplicated(df$date)), 0)
})

test_that("a window past the published record returns no rows without erroring", {
  skip_on_cran()
  skip_if_offline()
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_future"))
  on.exit(options(op))

  future_start <- as.character(Sys.Date() + 30)
  future_end   <- as.character(Sys.Date() + 40)

  df <- noaa_daily("USW00094728", future_start, future_end, datatypes = "TMAX")
  expect_s3_class(df, "data.frame")
  expect_equal(nrow(df), 0)

  # An empty response must not be cached, or it would mask the real data
  # once NCEI publishes it
  cached <- list.files(file.path(tempdir(), "readnoaa_future"),
                       pattern = "daily-summaries")
  expect_length(cached, 0)
})
