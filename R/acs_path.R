#' Check for valid options and return the path part of an API call for ACS data.
#'
#' @param .year An integer year between 2004 and the current year, inclusive.
#' @param .year_span Either 1, 3, or 5, depending upon the desired time resolution.
#'
#' @return a slash-separated URL path.
#' @export
acs_path <- function(.year, .year_span) {
  .this_year <- lubridate::year(lubridate::today())

  if (!dplyr::between(.year, 2004L, .this_year)) {
    cli::cli_abort(c("ACS data are only available from 2004-present",
      "x" = "You passed in {.year}."
    ))
  }

  if (.year_span != 5L && .year_span != 3L && .year_span != 1L) {
    cli::cli_abort(c("{.var .year_span} must be 1, 3, or 5.",
      "x" = "You passed in {.year_span}."
    ))
  }

  if (.year_span == 3L && !dplyr::between(.year, 2007L, 2013L)) {
    cli::cli_abort(c("The 3-year ACS was only available between 2007-13",
      "x" = "You asked for the year {.year}."
    ))
  }

  if (.year_span == 1L && .year == 2020L) {
    cli::cli_abort(c("There is no 1-year ACS from 2020 because of COVID-19."))
  }

  glue::glue("data/{.year}/acs/acs{.year_span}")
}
