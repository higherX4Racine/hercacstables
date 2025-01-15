#' Fetch glossary about a specific ACS data set from the Census API.
#'
#' This function downloads a large JSON object and parses it into a tibble.
#'
#' @inheritParams build_info_url
#'
#' @return A tibble.
#'
#' @export
#' @concept glossary
fetch_metadata_table <- function(.info_type, .year, .year_span) {
    .list <- .info_type |>
        build_info_url(.year, .year_span) |>
        jsonlite::read_json() |>
        purrr::pluck(1) |>
        purrr::map(.glossary_row_to_tibble)

    switch(
        .info_type,
        geography = .wrangle_geography(.list),
        groups = .wrangle_groups(.list),
        variables = .wrangle_variables(.list)
    )
}

.lists_to_wrapped_chars <- function(.list) {
    list(as.character(.list))
}

.glossary_row_to_tibble <- function(.element) {
    .element |>
        purrr::map_if(
            is.list, .lists_to_wrapped_chars
        ) |>
        tibble::as_tibble()
}

.wrangle_geography <- function(.list) {
    .list |>
        purrr::list_rbind() |>
        dplyr::mutate(
            referenceDate = lubridate::ymd(.data$referenceDate)
        ) |>
        dplyr::select(
            `Geographic Level` = "name",
            `Containing Geographies` = "requires",
            `Wildcard Option` = "optionalWithWCFor",
            `Reference Date` = "referenceDate"
        )
}

.wrangle_groups <- function(.list) {
    .list |>
        purrr::list_rbind() |>
        dplyr::select(
            "Group" = "name",
            "Description" = "description",
            "Universe" = "universe "
        ) |>
        dplyr::arrange(
            .data$Group
        )
}

.wrangle_variables <- function(.list) {
    .list |>
        purrr::list_rbind(
            names_to = "variable"
        ) |>
        dplyr::filter(
            stringr::str_detect(.data$group,
                                pattern = "N/A",
                                negate = TRUE),
            stringr::str_detect(.data$label,
                                "^Geography$",
                                negate = TRUE)
        ) |>
        dplyr::mutate(
            Index = .data$variable |>
                stringr::str_extract("\\d+(?=\\D?$)") |>
                as.integer(),
            Details = .data$label |>
                stringr::str_remove_all(":") |>
                stringr::str_remove("Estimate!!") |>
                stringr::str_remove("Total(!!|$)") |>
                stringr::str_split("( ?-+)?!+")
        ) |>
        dplyr::select(
            Concept = "concept",
            Group = "group",
            "Index",
            Variable = "variable",
            "Details"
        ) |>
        dplyr::arrange(
            .data$Variable
        )
}
