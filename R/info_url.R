#' Get the URL for JSON metadata about one table of ACS data
#'
#' This will be a complete URL, including protocol and file extension, for
#' downloading metadata about geographies, groups of variables, or specific
#' variables.
#'
#' @param .info_type One of "geography", "groups", or "variables".
#' @param .year An integer year between 2004 and the current year, inclusive.
#' @param .year_span Either 1, 3, or 5, depending upon the desired time resolution.
#'
#' @return A string that contains a URL.
#' @export
#'
#' @examples
#' info_url("groups", 2021L, 5L)
info_url <- function(.info_type, .year, .year_span) {
  rlang::arg_match(
    .info_type,
    c("geography", "groups", "variables")
  )

  paste(glue::glue("https://{.CENSUS_API_DOMAIN}"),
    acs_path(.year, .year_span),
    glue::glue("{.info_type}.json"),
    sep = "/"
  )
}
