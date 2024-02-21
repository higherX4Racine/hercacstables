#' Pull data from the 5-year American Community Survey
#'
#' The default years span the entire offering of 5-year ACS data.
#' Your variables will probably not all be available for every year.
#'
#' @param variables a character vector of variables like "B03002_001E"
#' @param state the two-digit FIPS code for the state, like 55 for Wisconsin
#' @param county the three-digit FIPS code for the county, like 101 for Racine
#' @param years, optional, the years to fetch data for. Defaults to 2009-2021
#'
#' @return a tibble of year, vintage, tract, group, index, variable, and value
#' @export
fetch_acs5_tract_data <- function(variables, state, county, years = 2009:2021L) {
    years |>
        purrr::map(
            hercacstables::fetch_data,
            variables = variables,
            for_geo = "tract",
            for_items = "*",
            survey_type = "acs",
            table_or_survey_code = "acs5",
            other_geos = list(state = state,
                              county = county)
        ) |>
        purrr::list_rbind() |>
        dplyr::mutate(
            Tract = stringr::str_c(.data$state, .data$county, .data$tract),
            Variable = build_api_variable(.data$Group, "", .data$Index),
            Vintage = 10L * (.data$Year %/% 10L)
        ) |>
        dplyr::select(
            !c("state", "county", "tract")
        )
}
