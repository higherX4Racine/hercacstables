#' Make a call to the Census API and convert the JSON response to an R list.
#'
#' @inheritParams api_url
#'
#' @return a list of items read from json
#' @seealso [api_url()]
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
        api_url(
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
