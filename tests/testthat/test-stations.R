test_that("noaa_stations returns expected structure with bbox", {
  skip_on_cran()
  skip_if_offline()

  df <- noaa_stations(bbox = c(51.3, -0.5, 51.7, 0.3), limit = 5)

  expect_s3_class(df, "data.frame")
  expect_true(all(c("station", "name", "latitude", "longitude") %in% names(df)))
  expect_true(nrow(df) <= 5)
})

test_that("noaa_stations returns expected structure with text", {
  skip_on_cran()
  skip_if_offline()

  df <- noaa_stations(text = "HEATHROW", limit = 10)

  expect_s3_class(df, "data.frame")
  if (nrow(df) > 0) {
    expect_true(all(grepl("HEATHROW", df$name, ignore.case = TRUE)))
  }
})

test_that("noaa_nearby returns expected structure", {
  skip_on_cran()
  skip_if_offline()

  df <- noaa_nearby(51.5, -0.1, radius_km = 25, limit = 10)

  expect_s3_class(df, "data.frame")
  if (nrow(df) > 0) {
    expect_true("distance_km" %in% names(df))
    expect_true(all(df$distance_km <= 25))
    # Check sorted by distance
    expect_equal(df$distance_km, sort(df$distance_km))
  }
})

test_that("noaa_nearby handles location with no stations", {
  skip_on_cran()
  skip_if_offline()

  # Middle of Pacific Ocean with tiny radius
  df <- noaa_nearby(0, -160, radius_km = 1)
  expect_s3_class(df, "data.frame")
  expect_true("distance_km" %in% names(df))
  expect_equal(nrow(df), 0)
})

test_that("fetch_station_list returns correct columns", {
  skip_on_cran()
  skip_if_offline()

  df <- readnoaa:::fetch_station_list(cache = TRUE)
  expect_s3_class(df, "data.frame")
  expect_true(all(c("station", "name", "latitude", "longitude", "elevation") %in% names(df)))
  expect_true(nrow(df) > 100000)
})
