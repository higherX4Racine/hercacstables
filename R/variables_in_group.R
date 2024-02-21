## Copyright (C) 2023 by Higher Expectations for Racine County

#' Extract each variable for one group of 5-year ACS data
#'
#' @param .group one ACS group, e.g. "B21005"
#'
#' @return a tibble with x columns
#' @export
variables_in_group <- function(.group){
    hercacstables::METADATA_ACS5 |>
        purrr::pluck("variables") |>
        dplyr::filter(.data$Group == .group) |>
        dplyr::select(!.data$Group)
}
