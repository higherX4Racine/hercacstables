#' Make a call to the Census API and convert the JSON response to an R list.
#'
#' @inheritParams build_api_url
#'
#' @return a list of items read from json
#' @keywords internal
#'
#' @seealso [build_api_url()]
#' @seealso [jsonlite::read_json()]
fetch_json_as_list <- function(variables,
                               year,
                               for_geo,
                               for_items,
                               survey_type,
                               table_or_survey_code,
                               ...,
                               use_key = TRUE) {
    variables |>
        build_api_url(
            variables = _,
            for_geo = for_geo,
            for_items = for_items,
            year = year,
            survey_type = survey_type,
            table_or_survey_code = table_or_survey_code,
            ...,
            use_key = use_key
        ) |>
        jsonlite::read_json()
}
