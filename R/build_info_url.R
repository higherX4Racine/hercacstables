#' Get the URL for JSON glossary about one table of ACS data
#'
#' This will be a complete URL, including protocol and file extension, for
#' downloading glossary about geographies, groups of variables, or specific
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

    .request <- "" |>
        httr2::url_modify(
            scheme = CENSUS_API_SCHEME,
            hostname = CENSUS_API_HOSTNAME,
            path = CENSUS_API_PATHROOT
        ) |>
        httr2::request() |>
        httr2::req_url_path_append(
            .year,
            "acs",
            paste0("acs", .year_span),
            paste0(.info_type, ".json")
        )

    if (api_key_is_set()) {
        .request <- httr2::req_url_query(.request,
                                         key = api_key_value())
    }

    httr2::req_get_url(.request)
}
