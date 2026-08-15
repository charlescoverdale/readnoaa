test_that("clear_cache runs without error", {
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_clear"))
  on.exit(options(op))
  expect_no_error(clear_cache())
})

test_that("cache keys stay within filesystem name limits", {
  many <- sprintf("USW000%05d", 1:200)
  key <- noaa_cache_key("daily-summaries", stations = many,
                        start_date = "2024-01-01", end_date = "2024-12-31")
  expect_lt(nchar(key), 255)
  expect_match(key, "\\.csv$")
})

test_that("cache keys distinguish requests that differ in any argument", {
  base <- noaa_cache_key("daily-summaries", stations = "A",
                         start_date = "2024-01-01", end_date = "2024-01-31")
  expect_false(identical(base, noaa_cache_key(
    "daily-summaries", stations = "B",
    start_date = "2024-01-01", end_date = "2024-01-31")))
  expect_false(identical(base, noaa_cache_key(
    "daily-summaries", stations = "A", datatypes = "TMAX",
    start_date = "2024-01-01", end_date = "2024-01-31")))
  expect_false(identical(base, noaa_cache_key(
    "daily-summaries", stations = "A", units = "standard",
    start_date = "2024-01-01", end_date = "2024-01-31")))
  expect_identical(base, noaa_cache_key(
    "daily-summaries", stations = "A",
    start_date = "2024-01-01", end_date = "2024-01-31"))
})

test_that("cache keys do not collide across long station lists", {
  a <- noaa_cache_key("daily-summaries", stations = sprintf("S%04d", 1:100))
  b <- noaa_cache_key("daily-summaries", stations = sprintf("S%04d", 2:101))
  expect_false(identical(a, b))
})

test_that("recent windows expire sooner than settled ones", {
  op <- options(readnoaa.cache_days = 30, readnoaa.cache_days_recent = 1)
  on.exit(options(op))

  recent <- as.character(Sys.Date() - 3)
  expect_equal(cache_max_age(recent), 1)
  expect_equal(cache_max_age("2015-06-30"), 30)
  expect_equal(cache_max_age(NULL), 30)
})

test_that("cache_is_fresh respects the age threshold", {
  dir <- file.path(tempdir(), "readnoaa_fresh")
  dir.create(dir, showWarnings = FALSE, recursive = TRUE)
  f <- file.path(dir, "x.csv")
  writeLines("a", f)

  settled <- "2015-06-30"
  expect_true(cache_is_fresh(f, settled))

  Sys.setFileTime(f, Sys.time() - as.difftime(45, units = "days"))
  expect_false(cache_is_fresh(f, settled))

  expect_false(cache_is_fresh(file.path(dir, "missing.csv"), settled))
})

test_that("write_cache is atomic and leaves no temporary files", {
  dir <- file.path(tempdir(), "readnoaa_atomic")
  unlink(dir, recursive = TRUE)
  f <- file.path(dir, "x.csv")

  expect_true(write_cache("hello,world\n1,2\n", f))
  expect_true(file.exists(f))
  expect_equal(read_cache(f), "hello,world\n1,2\n")
  expect_length(list.files(dir, pattern = "\\.tmp"), 0)
})

test_that("cache_info reports an empty cache without error", {
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_empty_info"))
  on.exit(options(op))
  res <- suppressMessages(cache_info())
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 0)
})
