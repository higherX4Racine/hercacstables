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
#'
#' @examples
#' hercacstables:::build_info_url("groups", 2021L, 5L)
build_info_url <- function(.info_type, .year, .year_span) {
    rlang::arg_match(
        .info_type,
        c("geography", "groups", "variables")
    )

    query_parameters <- list(`key` = Sys.getenv("CENSUS_API_KEY"))

    url_components <- list(
        scheme = CENSUS_API_SCHEME,
        hostname = CENSUS_API_HOSTNAME,
        path = c(CENSUS_API_PATHROOT,
                 .year,
                 "acs",
                 paste0("acs", .year_span),
                 paste0(.info_type, ".json")),
        query = query_parameters
    )

    class(url_components) <- "url"
    url_components |>
        httr::build_url() |>
        URLencode()
}
