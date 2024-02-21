#' Grab data from table B03002, which has race/ethnicity counts by tract.
#'
#' @param state the 2-digit FIPS code for a state, e.g. `55L` for Wisconsin
#' @param county the 3-digit FIPS code for a county, e.g. `101L` for Racine
#' @param years an integer vector of years to query. 2009 is the earliest possible year
#'
#' @return a tibble with tract, vintage, year, race/ethnicity, and population data
#' @export
fetch_acs5_race_ethnicity_trends <- function(state, county, years) {
    hercacstables::ACS_RACE_ETHNICITY_VARIABLES$Variable |>
        hercacstables::fetch_acs5_tract_data(
            state = state,
            county = county,
            years = years
        ) |>
        dplyr::inner_join(
            hercacstables::ACS_RACE_ETHNICITY_VARIABLES,
            by = "Variable"
        ) |>
        dplyr::count(
            .data$Tract,
            .data$Vintage,
            .data$Year,
            .data$`Race/Ethnicity`,
            wt = .data$Value,
            name = "Population"
        )
}
