#' Condense geographical hierarchy fields into one `"GEOID"` field.
#'
#' @param .x a tibble from calling [`fetch_data`][hercacstables::fetch_data()]
#'
#' @return a tibble with geographical fields replaced by their concatenation as `"GEOID"`
#' @export
#'
#' @examples
#' tibble::tribble(
#' ~ state, ~ county, ~ tract,  ~ Group,  ~ Index,  ~ Value, ~ Year,
#' 55L,     101L,     "000200", "B01001", 1L,        5078L,   2021L
#' ) |> replace_geographies_with_geoid()
replace_geographies_with_geoid <- function(.x){
    dplyr::mutate(
        .x,
        GEOID = purrr::pmap_chr(
            dplyr::pick(!c("Group",
                           "Index",
                           "Value",
                           "Year")),
            stringr::str_c
        ),
        .keep = "unused"
    )
}
