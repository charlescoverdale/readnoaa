test_that("validate_date accepts and normalises valid formats", {
  expect_equal(validate_date("2024-01-15"), "2024-01-15")
  expect_equal(validate_date("2024-01"), "2024-01-01")
  expect_null(validate_date(NULL))
})

test_that("validate_date rejects malformed input", {
  expect_error(validate_date("15/01/2024"), "YYYY-MM-DD")
  expect_error(validate_date("not a date"), "YYYY-MM-DD")
  expect_error(validate_date("2024"), "YYYY-MM-DD")
})

test_that("validate_date_range requires start before end", {
  expect_error(validate_date_range("2024-06-01", "2024-01-01"), "must be before")
  expect_silent(validate_date_range("2024-01-01", "2024-06-01"))
  expect_silent(validate_date_range(NULL, "2024-06-01"))
})

test_that("chunk_date_range splits long ranges at year boundaries", {
  one <- chunk_date_range("2024-01-01", "2024-06-30")
  expect_length(one, 1)

  many <- chunk_date_range("2023-06-01", "2025-03-01")
  expect_length(many, 3)
  expect_equal(many[[1]], c("2023-06-01", "2023-12-31"))
  expect_equal(many[[2]], c("2024-01-01", "2024-12-31"))
  expect_equal(many[[3]], c("2025-01-01", "2025-03-01"))
})

test_that("haversine computes known distances", {
  # London to Paris is roughly 344 km
  d <- haversine(51.5074, -0.1278, 48.8566, 2.3522)
  expect_gt(d, 330)
  expect_lt(d, 360)
  expect_equal(haversine(0, 0, 0, 0), 0)
})


# ---- CSV parsing -----------------------------------------------------------

test_that("parse_noaa_csv lowercases names and types columns", {
  csv <- paste(
    '"STATION","NAME","DATE","TMAX","TMIN"',
    '"USW00094728","CENTRAL PARK","2024-01-01","5.0","-1.1"',
    '"USW00094728","CENTRAL PARK","2024-01-02","6.1","0.0"',
    sep = "\n"
  )
  df <- parse_noaa_csv(csv)
  expect_named(df, c("station", "name", "date", "tmax", "tmin"))
  expect_s3_class(df$date, "Date")
  expect_type(df$tmax, "double")
  expect_type(df$station, "character")
  expect_equal(nrow(df), 2)
})

test_that("parse_noaa_csv preserves station IDs with leading zeros", {
  csv <- paste(
    '"STATION","DATE","TEMP"',
    '"03772099999","2024-01-01","5.1"',
    sep = "\n"
  )
  df <- parse_noaa_csv(csv)
  expect_identical(df$station, "03772099999")
})

test_that("parse_noaa_csv lowercases names even when there are no rows", {
  df <- parse_noaa_csv('"STATION","NAME","DATE","TMAX"')
  expect_equal(nrow(df), 0)
  expect_named(df, c("station", "name", "date", "tmax"))
})

test_that("parse_noaa_csv leaves all-NA columns alone", {
  csv <- paste(
    '"STATION","DATE","TMAX","TOBS"',
    '"USW00094728","2024-01-01","5.0",""',
    '"USW00094728","2024-01-02","6.1",""',
    sep = "\n"
  )
  df <- parse_noaa_csv(csv)
  expect_true(all(is.na(df$tobs)))
  expect_equal(df$tmax, c(5.0, 6.1))
})

test_that("parse_noaa_csv does not blank out text columns", {
  csv <- paste(
    '"STATION","DATE","TMAX_ATTRIBUTES"',
    '"USW00094728","2024-01-01",",,W,"',
    sep = "\n"
  )
  df <- parse_noaa_csv(csv)
  expect_identical(df$tmax_attributes, ",,W,")
})


# ---- date handling ---------------------------------------------------------

test_that("daily, monthly and annual dates become Date", {
  expect_s3_class(parse_noaa_csv('"DATE"\n"2024-01-31"')$date, "Date")
  expect_equal(parse_noaa_csv('"DATE"\n"2024-03"')$date, as.Date("2024-03-01"))
  expect_equal(parse_noaa_csv('"DATE"\n"2024"')$date, as.Date("2024-01-01"))
})

test_that("hourly ISO 8601 timestamps become POSIXct, not NA", {
  csv <- paste(
    '"STATION","DATE","TMP"',
    '"72505394728","2024-06-01T00:51:00","+0217,5"',
    '"72505394728","2024-06-01T01:51:00","+0211,5"',
    sep = "\n"
  )
  df <- parse_noaa_csv(csv)
  expect_s3_class(df$date, "POSIXct")
  expect_false(anyNA(df$date))
  expect_equal(format(df$date[1], "%Y-%m-%d %H:%M", tz = "UTC"), "2024-06-01 00:51")
})

test_that("normals pseudo-dates are kept and split into calendar parts", {
  monthly <- parse_noaa_csv('"STATION","DATE"\n"USW00094728","01"\n"USW00094728","02"')
  expect_identical(monthly$date, c("01", "02"))
  expect_identical(monthly$month, c(1L, 2L))

  daily <- parse_noaa_csv('"STATION","DATE"\n"USW00094728","01-31"')
  expect_identical(daily$date, "01-31")
  expect_identical(daily$month, 1L)
  expect_identical(daily$day, 31L)
})


# ---- assembly helpers ------------------------------------------------------

test_that("rbind_chunks unions differing column sets", {
  a <- data.frame(station = "X", date = as.Date("2024-01-01"), tmax = 1)
  b <- data.frame(station = "X", date = as.Date("2025-01-01"), tmax = 2, snow = 0)
  out <- rbind_chunks(list(a, b))
  expect_equal(nrow(out), 2)
  expect_true(all(c("tmax", "snow") %in% names(out)))
  expect_true(is.na(out$snow[1]))
})

test_that("rbind_chunks tolerates empty inputs", {
  expect_equal(nrow(rbind_chunks(list())), 0)
  expect_equal(nrow(rbind_chunks(list(data.frame()))), 0)
})

test_that("order_by_station_date copes with missing columns", {
  df <- data.frame(value = c(3, 1, 2))
  expect_equal(order_by_station_date(df)$value, c(3, 1, 2))
  expect_equal(nrow(order_by_station_date(data.frame())), 0)
})

test_that("order_by_station_date sorts by station then date", {
  df <- data.frame(
    station = c("B", "A", "A"),
    date = as.Date(c("2024-01-01", "2024-02-01", "2024-01-01"))
  )
  out <- order_by_station_date(df)
  expect_equal(out$station, c("A", "A", "B"))
  expect_equal(out$date[1], as.Date("2024-01-01"))
})

test_that("drop_empty_cols removes all-NA columns but keeps identifiers", {
  df <- data.frame(
    station = "X", date = as.Date("2024-01-01"),
    tmax = 5, tobs = NA_real_
  )
  out <- drop_empty_cols(df)
  expect_true(all(c("station", "date", "tmax") %in% names(out)))
  expect_false("tobs" %in% names(out))
})
