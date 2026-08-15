test_that("filter_bbox validates its input", {
  df <- data.frame(latitude = 1, longitude = 1)
  expect_error(filter_bbox(df, c(1, 2)), "length 4")
  expect_error(filter_bbox(df, c(1, 2, 3, NA)), "length 4")
})

test_that("filter_bbox keeps only points inside the box", {
  df <- data.frame(
    station  = c("in", "out_lat", "out_lon", "missing"),
    latitude  = c(51.5, 20.0, 51.5, NA),
    longitude = c(-0.1, -0.1, 90.0, -0.1)
  )
  out <- filter_bbox(df, c(51.3, -0.5, 51.7, 0.3))
  expect_equal(out$station, "in")
})

test_that("match_name treats text literally by default", {
  names_vec <- c("HEATHROW", "ST. LOUIS (LAMBERT)", "BEATHROW")

  expect_equal(sum(match_name(names_vec, "HEATHROW", regex = FALSE)), 1)
  # A regex metacharacter must not act as a wildcard
  expect_equal(sum(match_name(names_vec, ".EATHROW", regex = FALSE)), 0)
  expect_equal(sum(match_name(names_vec, ".EATHROW", regex = TRUE)), 2)
  # Unbalanced parentheses would be an invalid regex
  expect_no_error(match_name(names_vec, "ST. LOUIS (", regex = FALSE))
  expect_equal(sum(match_name(names_vec, "ST. LOUIS (", regex = FALSE)), 1)
})

test_that("match_name is case-insensitive in both modes", {
  expect_true(match_name("HEATHROW", "heathrow", regex = FALSE))
  expect_true(match_name("HEATHROW", "heathrow", regex = TRUE))
})

test_that("noaa_stations returns documented columns", {
  skip_on_cran()
  skip_if_offline()
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_stations"))
  on.exit(options(op))

  df <- noaa_stations(text = "Heathrow")
  expect_s3_class(df, "data.frame")
  expect_true(all(c("station", "name", "latitude", "longitude", "elevation",
                    "state", "gsn_flag", "hcn_crn_flag", "wmo_id") %in% names(df)))
  expect_gt(nrow(df), 0)
})

test_that("missing elevations are NA rather than the -999.9 sentinel", {
  skip_on_cran()
  skip_if_offline()
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_stations"))
  on.exit(options(op))

  df <- noaa_stations(limit = Inf)
  expect_equal(sum(df$elevation == -999.9, na.rm = TRUE), 0)
  expect_gt(sum(is.na(df$elevation)), 0)
})

test_that("noaa_nearby sorts by distance and respects the radius", {
  skip_on_cran()
  skip_if_offline()
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_stations"))
  on.exit(options(op))

  df <- noaa_nearby(51.5, -0.1, radius_km = 25)
  expect_true("distance_km" %in% names(df))
  expect_true(all(df$distance_km <= 25))
  expect_false(is.unsorted(df$distance_km))
})

test_that("noaa_nearby handles a location with no stations nearby", {
  skip_on_cran()
  skip_if_offline()
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_stations"))
  on.exit(options(op))

  # Middle of the South Pacific
  df <- noaa_nearby(-40, -140, radius_km = 20)
  expect_s3_class(df, "data.frame")
  expect_equal(nrow(df), 0)
  expect_true("distance_km" %in% names(df))
})
