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
#' clear_cache()
#' }
clear_cache <- function() {
  cache_dir <- tools::R_user_dir("readnoaa", "cache")
  if (dir.exists(cache_dir)) {
    unlink(cache_dir, recursive = TRUE)
    cli::cli_alert_success("Cache cleared.")
  } else {
    cli::cli_alert_info("No cache to clear.")
  }
  invisible(NULL)
}
