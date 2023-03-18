# Copyright (C) 2021 by Higher Expectations for Racine County
# Process American Community Survey Data Variables from the U.S. Census

#' Build the URL for the JSON data file for an ACS summary table.
#'
#' The fourth argument, "state_fips," must ultimately be replaced with a string
#' that captures the geographical part of the API query.
#'
#' @param year int, The reference year for the survey product
#' @param vintage int, Denotes the time-span the data are averaged over
#' @param table_name char, The full name of the ACS table, e.g. "C23002A"
#' @param state_fips int, The FIPS code for a state, e.g. 55 for Wisconsin.
#' @returns string, The URL of a JSON file on the Census's website
#' @export
#' @examples
#' counts_url(2020, 5, "C23002A", 55)
counts_url <- function(year,
                       vintage,
                       table_name,
                       state_fips) {
  stringr::str_c(
    CENSUS_API_ROOT_URL,
    "/",
    url_for_year_and_type(
      year,
      vintage
    ),
    "?",
    query_for_table(table_name),
    query_all_counties_in_state(state_fips)
  )
}
