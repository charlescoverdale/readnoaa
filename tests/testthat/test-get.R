test_that("noaa_get validates its dates", {
  expect_error(noaa_get("daily-summaries", start_date = "bad"), "YYYY-MM-DD")
  expect_error(
    noaa_get("daily-summaries", start_date = "2024-06-01", end_date = "2024-01-01"),
    "must be before"
  )
})

test_that("ncei_error_detail extracts field and message pairs", {
  body <- paste0(
    '{"errorCode":400,"errorMessage":"Bad Request","errors":[',
    '{"field":"boundingBox","message":"A bounding box is required.","value":null}]}'
  )
  expect_equal(ncei_error_detail(body), "boundingBox: A bounding box is required.")

  expect_equal(
    ncei_error_detail('{"errorCode":400,"errorMessage":"Bad Request"}'),
    "Bad Request"
  )
  expect_length(ncei_error_detail(""), 0)
})

test_that("noaa_get surfaces the API's own explanation of a bad request", {
  skip_on_cran()
  skip_if_offline()
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_get"))
  on.exit(options(op))

  expect_error(
    noaa_get("does-not-exist", station = "USW00094728",
             start_date = "2024-01-01", end_date = "2024-01-05"),
    "Unsupported dataset"
  )

  # global-marine is organised by area, so a station-only request must
  # explain that a bounding box is needed
  expect_error(
    noaa_get("global-marine", station = "USW00094728",
             start_date = "2024-01-01", end_date = "2024-01-05"),
    "bounding box"
  )
})

test_that("noaa_get returns hourly data with usable timestamps", {
  skip_on_cran()
  skip_if_offline()
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_get"))
  on.exit(options(op))

  df <- noaa_get("global-hourly", station = "72505394728",
                 start_date = "2024-06-01", end_date = "2024-06-02",
                 datatypes = c("TMP", "WND"))
  expect_s3_class(df, "data.frame")
  expect_gt(nrow(df), 0)
  expect_s3_class(df$date, "POSIXct")
  expect_false(anyNA(df$date))
})
