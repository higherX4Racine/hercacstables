#' Query the Census API for the most recent release year of a dataset.
#'
#' @param survey_type e.g. "acs" or "dec"
#' @param table_or_survey_code e.g. "acs5" or "pl"
#'
#' @return an integer, probably at least 2024
#' @export
most_recent_vintage <- function(survey_type, table_or_survey_code){

    .base_request <- "" |>
        httr2::url_modify(
            scheme = CENSUS_API_SCHEME,
            hostname = CENSUS_API_HOSTNAME
        ) |>
        httr2::request() |>
        httr2::req_method(
            "HEAD"
        )

    current_year <- the_year_right_now()

    while (current_year > 1985) {

        .request <- httr2::req_url_path(.base_request,
                                        CENSUS_API_PATHROOT,
                                        current_year,
                                        survey_type,
                                        table_or_survey_code)

        .response <- tryCatch(
            httr2::req_perform(.request),
            httr2_http_404 = \(.cnd) .cnd$resp
        )

        if (.response$status_code == 200L)
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
