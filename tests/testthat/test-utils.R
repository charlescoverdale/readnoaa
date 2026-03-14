test_that("validate_date accepts YYYY-MM-DD", {
  expect_equal(readnoaa:::validate_date("2024-01-15"), "2024-01-15")
})

test_that("validate_date converts YYYY-MM to YYYY-MM-01", {
  expect_equal(readnoaa:::validate_date("2024-06"), "2024-06-01")
})

test_that("validate_date returns NULL for NULL", {
  expect_null(readnoaa:::validate_date(NULL))
})

test_that("validate_date rejects invalid format", {
  expect_error(readnoaa:::validate_date("2024"), "YYYY-MM-DD")
  expect_error(readnoaa:::validate_date("not-a-date"), "YYYY-MM-DD")
})

test_that("validate_date rejects invalid date values", {
  expect_error(readnoaa:::validate_date("2024-13-01"), "not a valid date")
  expect_error(readnoaa:::validate_date("2024-02-30"), "not a valid date")
})

test_that("validate_date_range rejects start after end", {
  expect_error(
    readnoaa:::validate_date_range("2024-06-01", "2024-01-01"),
    "must be before"
  )
})

test_that("validate_date_range accepts valid range", {
  expect_silent(readnoaa:::validate_date_range("2024-01-01", "2024-06-01"))
})

test_that("validate_date_range accepts NULL dates", {
  expect_silent(readnoaa:::validate_date_range(NULL, "2024-01-01"))
  expect_silent(readnoaa:::validate_date_range("2024-01-01", NULL))
})

test_that("chunk_date_range returns single chunk for short range", {
  chunks <- readnoaa:::chunk_date_range("2024-01-01", "2024-06-30")
  expect_length(chunks, 1)
  expect_equal(chunks[[1]], c("2024-01-01", "2024-06-30"))
})

test_that("chunk_date_range splits multi-year range", {
  chunks <- readnoaa:::chunk_date_range("2020-06-15", "2023-03-10")
  expect_true(length(chunks) > 1)
  # First chunk ends at 2020-12-31
  expect_equal(chunks[[1]][2], "2020-12-31")
  # Last chunk ends at original end date
  expect_equal(chunks[[length(chunks)]][2], "2023-03-10")
})

test_that("chunk_date_range handles exact year boundary", {
  chunks <- readnoaa:::chunk_date_range("2024-01-01", "2024-12-31")
  expect_length(chunks, 1)
})

test_that("haversine computes known distance", {
  # London to Paris ~ 343 km
  d <- readnoaa:::haversine(51.5074, -0.1278, 48.8566, 2.3522)
  expect_true(d > 330 && d < 360)
})

test_that("haversine returns 0 for same point", {
  d <- readnoaa:::haversine(0, 0, 0, 0)
  expect_equal(d, 0)
})

test_that("parse_noaa_csv handles basic CSV", {
  csv <- "STATION,DATE,NAME,TMAX,TMIN\nUSW00094728,2024-01-01,CENTRAL PARK,5.0,1.2\n"
  df <- readnoaa:::parse_noaa_csv(csv)
  expect_s3_class(df, "data.frame")
  expect_s3_class(df$date, "Date")
  expect_type(df$station, "character")
  expect_type(df$tmax, "double")
  expect_equal(nrow(df), 1)
})

test_that("parse_noaa_csv handles empty CSV", {
  csv <- "STATION,DATE,NAME,TMAX\n"
  df <- readnoaa:::parse_noaa_csv(csv)
  expect_equal(nrow(df), 0)
})

test_that("parse_noaa_date handles daily dates", {
  result <- readnoaa:::parse_noaa_date(c("2024-01-15", "2024-06-30"))
  expect_s3_class(result, "Date")
  expect_equal(result, as.Date(c("2024-01-15", "2024-06-30")))
})

test_that("parse_noaa_date handles monthly dates", {
  result <- readnoaa:::parse_noaa_date(c("2024-01", "2024-12"))
  expect_equal(result, as.Date(c("2024-01-01", "2024-12-01")))
})

test_that("parse_noaa_date handles annual dates", {
  result <- readnoaa:::parse_noaa_date(c("2020", "2024"))
  expect_equal(result, as.Date(c("2020-01-01", "2024-01-01")))
})

test_that("parse_noaa_date returns NA for unrecognised formats", {
  result <- readnoaa:::parse_noaa_date(c("not-a-date", "2024-W01"))
  expect_true(all(is.na(result)))
})

test_that("parse_noaa_csv handles monthly CSV", {
  csv <- "STATION,DATE,NAME,TAVG\nUSW00094728,2024-01,CENTRAL PARK,2.8\n"
  df <- readnoaa:::parse_noaa_csv(csv)
  expect_s3_class(df$date, "Date")
  expect_equal(df$date, as.Date("2024-01-01"))
})

test_that("parse_noaa_csv handles annual CSV", {
  csv <- "STATION,DATE,NAME,TAVG\nUSW00094728,2020,CENTRAL PARK,14.1\n"
  df <- readnoaa:::parse_noaa_csv(csv)
  expect_s3_class(df$date, "Date")
  expect_equal(df$date, as.Date("2020-01-01"))
})
