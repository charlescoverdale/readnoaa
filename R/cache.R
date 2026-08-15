#' Clear the readnoaa cache
#'
#' Deletes all locally cached NOAA data files. The next call to any data
#' function will re-download from the NCEI API.
#'
#' @return Invisible `NULL`.
#'
#' @family data access
#' @seealso [cache_info()] to inspect the cache before clearing it.
#' @export
#' @examples
#' \donttest{
#' op <- options(readnoaa.cache_dir = tempdir())
#' clear_cache()
#' options(op)
#' }
clear_cache <- function() {
  cache_dir <- noaa_cache_dir()
  if (dir.exists(cache_dir)) {
    files <- list.files(cache_dir, full.names = TRUE)
    if (length(files)) unlink(files, recursive = TRUE)
    cli::cli_alert_success("Cache cleared.")
  } else {
    cli::cli_alert_info("No cache to clear.")
  }
  invisible(NULL)
}


#' Inspect the readnoaa cache
#'
#' Lists the cached responses currently on disk, with their size and age.
#' Useful for checking whether a result is being served from a stale copy.
#'
#' Cached responses expire automatically. Requests whose window ends within
#' the last five weeks are treated as provisional and expire after one day,
#' because NCEI publishes recent observations with a lag and continues to
#' revise them. Older windows are treated as settled and expire after 30
#' days. Both thresholds are configurable through the options
#' `readnoaa.cache_days_recent` and `readnoaa.cache_days`, and any single
#' call can bypass the cache entirely with `refresh = TRUE`.
#'
#' @return A data frame with columns `file`, `size_kb`, and `age_days`,
#'   returned invisibly if the cache is empty.
#'
#' @family data access
#' @export
#' @examples
#' \donttest{
#' op <- options(readnoaa.cache_dir = tempdir())
#' cache_info()
#' options(op)
#' }
cache_info <- function() {
  cache_dir <- noaa_cache_dir()
  if (!dir.exists(cache_dir)) {
    cli::cli_alert_info("No cache directory yet.")
    return(invisible(data.frame(
      file = character(), size_kb = numeric(), age_days = numeric(),
      stringsAsFactors = FALSE
    )))
  }

  files <- list.files(cache_dir, full.names = TRUE)
  if (!length(files)) {
    cli::cli_alert_info("Cache is empty.")
    return(invisible(data.frame(
      file = character(), size_kb = numeric(), age_days = numeric(),
      stringsAsFactors = FALSE
    )))
  }

  info <- file.info(files)
  out <- data.frame(
    file     = basename(files),
    size_kb  = round(info$size / 1024, 1),
    age_days = round(as.numeric(difftime(Sys.time(), info$mtime, units = "days")), 2),
    stringsAsFactors = FALSE
  )
  out <- out[order(-out$size_kb), , drop = FALSE]
  rownames(out) <- NULL
  out
}
