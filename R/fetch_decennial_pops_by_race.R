#' Get decennial census estimates of per-block populations by race/ethnicity
#'
#' This function retrieves data from tables that split people into race and
#' Hispanic/Latin\@ ethnicity.
#'
#' @inheritDotParams build_api_url -variables -survey_type -table_or_survey_code -year
#'
#' @return a [`tibble`][tibble::tibble()] with at least four columns:
#'   \describe{
#'    \item{Vintage}{The decennial year, currently 2000, 2010, or 2020}
#'    \item{Race/Ethnicity}{OMB text descriptions of Race/Ethnicities}
#'    \item{...}{additional columns that identify a geographic unit}
#'    \item{Population}{The number of people in that block in that year of that race/ethnicity}
#'   }
#' @export
fetch_decennial_pops_by_race <- function(...) {
    hercacstables::DECENNIAL_POPULATION_FIELDS |>
        tidyr::nest(
            vars = "Variable",
            .by = "Vintage"
        ) |>
        purrr::pmap(
            \(vars, Vintage) fetch_data(
                variables = vars$Variable,
                year = Vintage,
                survey_type = "dec",
                table_or_survey_code = "pl",
                ...)
        ) |>
        purrr::list_rbind() |>
        dplyr::inner_join(
            dplyr::select(
                hercacstables::DECENNIAL_POPULATION_FIELDS,
                !"Variable"
            ),
            by = c(Year = "Vintage", "Group", "Index")
        ) |>
        dplyr::rename(
            Population = "Value",
            Vintage = "Year"
        ) |>
        dplyr::select(
            !tidyselect::any_of(c("Group", "Index"))
        ) |>
        dplyr::relocate(
            "Vintage",
            "Race/Ethnicity"
        ) |>
        dplyr::relocate(
            "Population",
            .after = tidyselect::last_col()
        )
}
