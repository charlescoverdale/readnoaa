test_that("list_datasets returns a documented table", {
  df <- list_datasets()
  expect_s3_class(df, "data.frame")
  expect_named(df, c("dataset", "description", "frequency", "requires"))
  expect_gt(nrow(df), 0)
  expect_false(anyNA(df$dataset))
})

test_that("list_datasets only advertises supported identifiers", {
  df <- list_datasets()
  # Withdrawn: the NCEI data service rejects this one as an unsupported dataset
  expect_false("noaa-global-surface-temperature" %in% df$dataset)
  # The annual normals live under the annualseasonal identifier
  expect_true("normals-annualseasonal-1991-2020" %in% df$dataset)
  expect_false("normals-annual-1991-2020" %in% df$dataset)
})

test_that("list_datasets records datasets that need a bounding box", {
  df <- list_datasets()
  expect_equal(df$requires[df$dataset == "global-marine"], "bbox")
})

test_that("list_datatypes reports what a station records, not the schema", {
  skip_on_cran()
  skip_if_offline()
  op <- options(readnoaa.cache_dir = file.path(tempdir(), "readnoaa_types"))
  on.exit(options(op))

  all_time <- list_datatypes("daily-summaries", "USW00094728")
  expect_type(all_time, "character")
  expect_true(all(c("TMAX", "TMIN", "PRCP") %in% all_time))

  # The full GHCN-Daily element set runs to about 150 codes; no single
  # station reports anything close to that
  expect_lt(length(all_time), 100)

  recent <- list_datatypes("daily-summaries", "USW00094728",
                           start_date = "2025-01-01")
  expect_lt(length(recent), length(all_time))
  expect_true(all(c("TMAX", "TMIN", "PRCP") %in% recent))
})
