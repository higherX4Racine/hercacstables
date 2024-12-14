#' Query the Census API for the most recent release year of a dataset.
#'
#' @param survey_type e.g. "acs" or "dec"
#' @param table_or_survey_code e.g. "acs5" or "pl"
#'
#' @return an integer, probably at least 2024
#' @export
most_recent_vintage <- function(survey_type, table_or_survey_code){

    current_year <- the_year_right_now()

    while (current_year > 1985) {

        probe_url <- file.path("https://api.census.gov/data",
                               current_year,
                               survey_type,
                               table_or_survey_code)

        response <- httr::HEAD(probe_url)

        if (response$status_code == 200L)
            return(current_year)

        current_year <- current_year - 1
    }

    rlang::abort(
        paste0("no data available for '",
               table_or_survey_code,
               "' within '",
               survey_type,
               "'.")
    )
}
