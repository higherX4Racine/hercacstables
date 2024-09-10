#' Download a set of data from the US Census API
#'
#' @inheritParams api_url
#' @param other_geos optional, a named list of other geographies, e.g. `list(state = 55L, county = 101L)`
#'
#' @return a tibble with "Group", "Index", "Value", and "Year" fields, as well as one field for each geography.
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

    .json <- fetch_json_as_list(variables = variables,
                                for_geo = for_geo,
                                for_items = for_items,
                                year = year,
                                survey_type = survey_type,
                                table_or_survey_code = table_or_survey_code,
                                other_geos = other_geos,
                                ...,
                                use_key = use_key)

    .json |>
        tail(
            -1
        ) |>
        purrr::list_transpose() |>
        rlang::set_names(
            as.character(.json[[1]])
        ) |>
        tibble::as_tibble() |>
        dplyr::mutate(
            dplyr::across(tidyselect::where(is.list),
                          ~ dplyr::na_if(as.character(.), "NULL"))
        ) |>
        tidyr::pivot_longer(
            !c(for_geo, names(other_geos)),
            names_to = "Variable",
            values_to = "Value"
        ) |>
        tidyr::separate_wider_regex(
            "Variable",
            patterns = c(Group = "^[^_]+", # this hard-codes the separator and could be a problem
                         "_?", # same as previous comment
                         Index = "\\d{3}",
                         ".*")
        ) |>
        dplyr::mutate(
            Year = year,
            Index = as.integer(.data$Index),
            Value = as.numeric(.data$Value)
        )
}
