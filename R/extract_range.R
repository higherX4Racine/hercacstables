## Copyright (C) 2026 by Higher Expectations for Racine County

extract_left_side_of_range <- function(.range_text) {
    .range_text |>
        stringr::str_extract("(?!<\\b)\\d+") |>
        as.integer()
}

extract_right_side_of_range <- function(.range_text, .left_side) {
    .range_text |>
        stringr::str_extract(
            paste0("(?<=", .left_side, " to )\\d+")
        ) |>
        as.integer()
}

#' Extract two numbers from a range in census variables
#'
#' @param .range_text `<chr>` a column of text with at least one number
#' @param .label `<chr>` part of the name of each output column
#' @param .defaults `<int[2]?>` the replacements for non-matches. Defaults to 0 and 999
#'
#' @returns a tibble with two integer columns, `Upper {.label}` and `Lower {.label}`
#' @export
extract_range <- function(.range_text, .label, .defaults = c(0L, 999L)) {
    tibble::tibble(
        L = extract_left_side_of_range(.range_text),
        U = extract_right_side_of_range(.range_text, .data$L)
    ) |>
        dplyr::mutate(
            L = dplyr::coalesce(.data$L, .defaults[1]),
            U = dplyr::coalesce(.data$U, .defaults[2])
        ) |>
        dplyr::rename(
            "Lower {.label}" := "L",
            "Upper {.label}" := "U",
        )
}
