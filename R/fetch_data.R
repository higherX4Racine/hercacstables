#' Download a set of data from the US Census API
#'
#' @param .variables a vector of variable names, like `"B01001_001E"`
#' @param .for_geo the geographical level the data will describe, e.g. `"tract"`
#' @param .for_items the specific instances of `.for_geo` desired, e.g. `"*"` or `"000200"`
#' @param .other_geos a named list of other geos, e.g. `list(state = 55L, county = 101L)`
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> further arguments for <[`api_url`][hercacstables::api_url]>.
#'
#' @return a tibble with "Variable", "Index", and "Value" fields, as well as one field for each geography.
#' @export
fetch_data <- function(.variables,
                       .for_geo,
                       .for_items,
                       .other_geos,
                       ...) {
    .json <- api_url |>
        do.call(
            rlang::list2(variables = .variables,
                         for_geo = .for_geo,
                         for_items = .for_items,
                         ...,
                         !!!.other_geos)
        ) |>
        jsonlite::read_json()

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
            !c(.for_geo, names(.other_geos)),
            names_to = "Variable",
            values_to = "Value"
        ) |>
        tidyr::separate_wider_regex(
            "Variable",
            patterns = c(Group = "^[^_]+",
                         "_",
                         Index = "\\d+",
                         ".*")
        ) |>
        dplyr::mutate(
            Index = as.integer(.data$Index),
            Value = as.numeric(.data$Value)
        )
}
