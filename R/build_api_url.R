#' Create an API call to send to api.census.gov
#'
#' @param variables a vector of variable names, like `"B01001_001E"`
#' @param for_geo the geographical level the data will describe, e.g. `"tract"`
#' @param for_items the specific instances of `for_geo` desired, e.g. `"*"` or `"000200"`
#' @param survey_type e.g. "acs" or "dec"
#' @param table_or_survey_code e.g. "acs5" or "pl"
#' @param year an integer year, e.g. `2021L`
#' @param ... <[`dynamic dots`][rlang::dyn-dots]> other items to pass to the query
#' @param use_key optional, should the query include a Census API key from the system environment. Defaults to `TRUE`
#'
#' @return one URL, as a string
#' @examples
#' hercacstables:::build_api_url(paste0("B25003_00", 1:3, "E"),
#'                               "tract",
#'                               "*",
#'                               "acs",
#'                               "acs5",
#'                               2020L,
#'                               state = 55L,
#'                               county = 101L,
#'                               use_key = FALSE)
#'
#' hercacstables:::build_api_url(paste0("P1_00", c(1, 3, 4), "N"),
#'                               "tract",
#'                               "*",
#'                               "dec",
#'                               "pl",
#'                               2020L,
#'                               state = 55L,
#'                               county = 101L,
#'                               use_key = FALSE)
build_api_url <- function(variables,
                          for_geo,
                          for_items,
                          survey_type,
                          table_or_survey_code,
                          year,
                          ...,
                          use_key = TRUE) {

    url_components <- list(
        scheme = CENSUS_API_SCHEME,
        hostname = CENSUS_API_HOSTNAME,
        path = c(CENSUS_API_PATHROOT,
                 year,
                 survey_type,
                 table_or_survey_code),
        query = build_query_parameters(variables,
                                       for_geo,
                                       for_items,
                                       in_geos = list(...),
                                       use_key)
    )

    class(url_components) <- "url"
    url_components |>
        httr::build_url() |>
        URLencode()
}
