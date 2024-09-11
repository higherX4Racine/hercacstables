#' Download a set of data from the US Census API
#'
#' @inheritParams build_api_url
#' @param other_geos optional, a named list of other geographies, e.g. `list(state = 55L, county = 101L)`
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
                       other_geos = NULL,
                       ...,
                       use_key = TRUE) {

    variables |>
        fetch_json_as_list(
            for_geo = for_geo,
            for_items = for_items,
            year = year,
            survey_type = survey_type,
            table_or_survey_code = table_or_survey_code,
            !!!other_geos,
            ...,
            use_key = use_key
        ) |>
        rlang::inject() |>
        json_list_to_frame() |>
        pivot_and_separate(
            Group = "^[^_]+", # this hard-codes the separator and could be a problem
            "_?",             # same as previous comment
            Index = "\\d{3}",
            ".*"
        ) |>
        dplyr::mutate(
            Year = year,
            dplyr::across(tidyselect::any_of("Index"),
                          as.integer)
        )
}
