#' Download a set of data from the US Census API
#'
#' @inheritParams build_api_url
#'
#' @return a tibble with "Group", "Index", "Value", and "Year" fields, as well as one field for each geography.
#' @seealso [build_api_url()]
#' @export
fetch_data <- function(variables,
                       year,
                       for_geo,
                       for_items,
                       survey_type,
                       table_or_survey_code,
                       ...,
                       use_key = TRUE) {

    variables |>
        fetch_json_as_list(
            for_geo = for_geo,
            for_items = for_items,
            year = year,
            survey_type = survey_type,
            table_or_survey_code = table_or_survey_code,
            ...,
            use_key = use_key
        ) |>
        json_list_to_frame() |>
        pivot_and_separate(
            Group = "^[^_]+", # this hard-codes the separator and could be a problem
            "_?",             # same as previous comment
            Index = "\\d{3}",
            Measure = ".*"
        ) |>
        dplyr::mutate(
            Year = year,
            dplyr::across(tidyselect::any_of("Index"),
                          as.integer)
        )
}
