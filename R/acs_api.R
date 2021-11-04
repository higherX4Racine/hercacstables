# Copyright (C) 2021 by Higher Expectations for Racine County
# URL Utilities for the American Community Survey from the U.S. Census


CENSUS_API_ROOT_URL <- "https://api.census.gov/data"


#' Use look up fields to build a glob to search for downloaded ACS data.
#'
#' @param code this is a string containing table and (maybe?) year info
#' @param vintage an integer, usually 1 or 5, but sometimes 3
#' @param is_metadata logical
#'
#' @return a file name as a string
#' @export
#'
#' @examples
#' make_census_file_regex("C23002A", 5)

make_census_file_regex <- function (code, vintage, is_metadata = FALSE) {
    type_string = ifelse(is_metadata,
                         "_metadata_",
                         "_data_with_overlays_")

    stringr::str_c("ACS",
          code, vintage,
          ".*",
          type_string,
          ".*\\.csv")
}



acs_url_for_year_and_type <- function(year, vintage) {
    stringr::str_c(year, "/acs/acs", vintage, collapse = "")
}


acs_query_for_table <- function(table_name) {
    stringr::str_c("get=group(",
          table_name,
          ")")
}


acs_query_all_counties_in_state <- function(state_fips) {
    stringr::str_c("&for=county:*&in=state:",
          state_fips)
}
