# Copyright (C) 2022 by Higher Expectations for Racine County

.BASE_URL <- "https://api.census.gov/data"


.colonic <- function(...) {
    list(...) %>%
        purrr::imap(~ paste0("in=", .y, ":", .x)) %>%
        paste0(collapse = "&")
}


#' Construct the query part of the URL for a call to the US Census API
#'
#' @param variables a vector of strings with variable codes
#' @param for_geo the geographic level of detail that you want
#' @param for_items the specific geographic entities that you want
#' @param ... other key-value pairs to pass to the query
#'
#' @return a string with the query part of a Census API call
#' @export
#'
#' @examples
#' api_query(paste0("B25003_00", 1:3, "E"),
#'                  "tract",
#'                  "*",
#'                  state = 55L,
#'                  county = 101L)
#'
#' api_query(paste0("P1_00", c(1, 3, 4), "N"),
#'                  "block%20group",
#'                  "*",
#'                  state = 55L,
#'                  county = 101L)
api_query <- function(variables,
                      for_geo,
                      for_items,
                      ...) {
    paste(paste0(variables,
                 collapse = ","),
          paste0("for=", for_geo, ":",
                 paste0(for_items,
                        collapse = ',')),
          .colonic(...),
          sep = "&")
}


#' Create an API call to send to api.census.gov
#'
#' @param variables a vector of variables
#' @param for_geo a single geographic level, like "tract" or "block"
#' @param for_items the specific geographies, or "*"
#' @param survey_type e.g. "acs" or "dec"
#' @param survey_or_table_code e.g. "acs5" or "pl"
#' @param year the year of the survey
#' @param ... <[`dynamic dots`][rlang::dyn-dots]> other items to pass to the query
#'
#' @return one URL, as a string
#' @export
#'
#' @examples
#' api_url(paste0("B25003_00", 1:3, "E"),
#'               "tract",
#'               "*",
#'               "acs",
#'               "acs5",
#'               2020L,
#'               state = 55L,
#'               county = 101L)
#'
#' api_url(paste0("P1_00", c(1, 3, 4), "N"),
#'               "tract",
#'               "*",
#'               "dec",
#'               "pl",
#'               2020L,
#'               state = 55L,
#'               county = 101L)
api_url <- function(variables,
                    for_geo,
                    for_items,
                    survey_type,
                    survey_or_table_code,
                    year,
                    ...) {
    query <- api_query(variables,
                       for_geo,
                       for_items,
                       ...)

    paste(.BASE_URL,
          as.character(year),
          survey_type,
          paste0(survey_or_table_code,
                 "?get=",
                 query),
          sep = "/"
    )

}


#' Create an API query URL for tract-level data from a 5-Year ACS
#'
#' @param for_items the tracts to fetch data for. Defaults to eastern Racine County
#' @param state the state to fetch data for. Defaults to Wisconsin
#' @param county the county to fetch data for. Defaults to Racine
#' @param ... <[`dynamic dots`][rlang::dyn-dots]> named arguments to pass to \code{\link[hiRx]{api_url}}
#'
#' @return one URL for an API call
#' @export
#'
#' @examples
#' acs5_tract_query_url(year = 2020,
#'                             variables = paste0("B25003_00", 1:3, "E"))
acs5_tract_query_url <- function(...,
                                 for_items = NULL,
                                 state = 55,
                                 county = 101){
    if (is.null(for_items)) {
        for_items <- unique(hiRx::racine_race_pop_weights_by_tract$tract)
    }

    api_url(
        ...,
        survey_type = "acs",
        survey_or_table_code = "acs5",
        for_geo = "tract",
        for_items = for_items,
        state = state,
        county = county
    )
}


#' Create an API query URL for a table from a decennial US Census
#'
#' @param summary_table the code for a summary table from a decennial census
#' @param ... <[`dynamic dots`][rlang::dyn-dots]> named arguments to pass to \code{\link[hiRx]{api_url}}
#'
#' @return one URL for an API call
#' @export
#'
#' @examples
#' hiRx::decennial_query_url(variables = paste0("P1_00", c(1, 3, 4), "N"),
#'                           summary_table = "pl",
#'                           year = 2020,
#'                           for_geo = "tract",
#'                           for_items = "*",
#'                           state = 55,
#'                           county = 101)
decennial_query_url <- function(summary_table,
                                ...) {
    api_url(survey_type = "dec",
            survey_or_table_code = summary_table,
            ...)
}
