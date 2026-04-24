#' Clear the readnoaa cache
#'
#' Deletes all locally cached NOAA data files. The next call to any data
#' function will re-download from the NCEI API.
#'
#' @return Invisible `NULL`.
#'
#' @family data access
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
