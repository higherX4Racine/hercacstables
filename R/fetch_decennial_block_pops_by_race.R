#' Get decennial census estimates of per-block populations by race/ethnicity
#'
#' This function retrieves data from tables that splits people into race and Hispanic/Latin\@ ethnicity.
#'
#'
#' @param state two-digit FIPS code for the state, e.g. 55L for Wisconsin
#' @param county three-digit FIPS code for the county within the state, e.g. 101L for Racine
#'
#' @return a [`tibble`][tibble::tibble()] with four columns:
#'   \describe{
#'    \item{Vintage}{The decennial year, currently 2000, 2010, or 2020}
#'    \item{Race/Ethnicity}{OMB text descriptions of Race/Ethnicities}
#'    \item{GEOID}{The full FIPS code for each census block}
#'    \item{Population}{The number of people in that block in that year of that race/ethnicity}
#'   }
#' @export
fetch_decennial_block_pops_by_race <- function(state, county) {
    hercacstables::DECENNIAL_POPULATION_FIELDS |>
        dplyr::select(
            "Variable",
            "Vintage"
        ) |>
        dplyr::summarize(
            Variables = list(.data$Variable),
            .by = "Vintage"
        ) |>
        dplyr::mutate(
            Data = purrr::map2(
                .data$Variables,
                .data$Vintage,
                ~ hercacstables::fetch_data(
                    variables = .x,
                    year = .y,
                    for_geo = "block",
                    other_geos = list(state = state,
                                      county = county),
                    for_items = "*",
                    survey_type = "dec",
                    table_or_survey_code = "pl"
                )
            )
        ) |>
        tidyr::unnest(
            "Data"
        ) |>
        dplyr::mutate(
            GEOID = paste0(.data$state,
                           .data$county,
                           .data$tract,
                           .data$block)
        ) |>
        dplyr::inner_join(
            hercacstables::DECENNIAL_POPULATION_FIELDS,
            by = c("Vintage", "Group", "Index")
        ) |>
        dplyr::select(
            "Vintage",
            "Race/Ethnicity",
            "GEOID",
            Population = "Value"
        )
}
