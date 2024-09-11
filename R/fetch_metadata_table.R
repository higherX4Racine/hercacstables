#' Fetch metadata about a specific ACS data set from the Census API.
#'
#' This function downloads a large JSON object and parses it into a tibble.
#'
#' @param .info_type See [`build_info_url()`].
#' @param .year See [`build_info_url()`].
#' @param .year_span See [`build_info_url`].
#'
#' @return A tibble.
#'
#' @seealso [`build_info_url()`]
#' @export
fetch_metadata_table <- function(.info_type, .year, .year_span) {
    .pluck_map <- list(
        geography = "fips",
        groups = "groups",
        variables = "variables"
    )

    .table <- .info_type |>
        build_info_url(
            .year,
            .year_span
        ) |>
        jsonlite::read_json() |>
        purrr::pluck(
            .pluck_map[[.info_type]]
        ) |>
        purrr::list_transpose(
            simplify = NA
        ) |>
        tibble::as_tibble() |>
        dplyr::rename_with(
            stringr::str_squish
        )

    switch(
        .info_type,
        geography = .wrangle_geography(.table),
        groups = .wrangle_groups(.table),
        variables = .wrangle_variables(.table)
    )
}

.wrangle_geography <- function(.table) {
    .table |>
        dplyr::mutate(
            referenceDate = lubridate::ymd(.data$referenceDate)
        )
}

.wrangle_groups <- function(.table) {
    .table <- .table |>
        dplyr::arrange(
            .data$name
        )
}

.wrangle_variables <- function(.table) {
    .table |>
        dplyr::select(
            "label",
            "concept",
            "group"
        ) |>
        dplyr::filter(
            stringr::str_detect(.data$group,
                                pattern = "N/A",
                                negate = TRUE),
            nchar(.data$group) < 8L
        ) |>
        dplyr::mutate(
            variable = names(.data$concept),
            concept = .data$concept |>
                rlang::set_names(nm = NULL) |>
                as.character()
        ) |>
        dplyr::relocate(
            "concept",
            "group",
            "variable",
            "label"
        ) |>
        dplyr::arrange(
            .data$variable
        )
}
