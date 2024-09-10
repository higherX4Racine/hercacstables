#' Create an API call to send to api.census.gov
#'
#' @inheritParams api_query
#' @param survey_type e.g. "acs" or "dec"
#' @param table_or_survey_code e.g. "acs5" or "pl"
#' @param year an integer year, e.g. `2021L`
#'
#' @return one URL, as a string
#' @export
#' @seealso [api_query()]
#' @examples
#' api_url(paste0("B25003_00", 1:3, "E"),
#'               "tract",
#'               "*",
#'               "acs",
#'               "acs5",
#'               2020L,
#'               state = 55L,
#'               county = 101L,
#'               use_key = FALSE)
#'
#' api_url(paste0("P1_00", c(1, 3, 4), "N"),
#'               "tract",
#'               "*",
#'               "dec",
#'               "pl",
#'               2020L,
#'               state = 55L,
#'               county = 101L,
#'               use_key = FALSE)
api_url <- function(variables,
                    for_geo,
                    for_items,
                    survey_type,
                    table_or_survey_code,
                    year,
                    ...,
                    use_key = TRUE) {
    query <- api_query(variables,
                       for_geo,
                       for_items,
                       ...,
                       use_key = use_key)

    hercacstables::CENSUS_API_URL |>
        paste(
            as.character(year),
            survey_type,
            paste0(table_or_survey_code,
                   "?get=",
                   query),
            sep = "/"
        ) |>
        URLencode()

}
