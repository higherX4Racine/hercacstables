# Copyright (C) 2025 by Higher Expectations for Racine County

.reductive <- function(.field) {
    if (grepl("^-", .field)) {
        .field <- substr(.field, 2, nchar(.field))
        .postop <- \(.) !.
    } else {
        .postop <- I
    }
    function(.so_far, .next_term) dplyr::filter(
        .so_far,
        .next_term |>
            grepl(.data[[.field]], ignore.case = TRUE) |>
            .postop()
    )
}

#' Search for terms in a glossary in case-insensitive ways
#'
#' Each of the dynamic arguments to this function must be a named array of
#' strings.
#' The function will look for each string in the column of `.dataframe` that
#' corresponds to the argument's name. For example, providing the argument
#' `Universe = c("Wom[ae]n", "years?")` will search the "Universe" column for
#'  any elements that include both "women"  or "woman" and "year" or "years".
#' The search is NOT case-sensitive.
#' You can also exclude patterns by prefacing the column name with "-".
#' For example, the argument `"-Universe" = "household"` will exclude rows
#' where the "Universe" column contains the string "household".
#'
#' @param .dataframe <dfr> the table to search in
#' @param ... &lt;[rlang::dyn-dots]&gt; Named arrays of search terms.
#'
#' @returns &lt;dfr&gt; a filtered version of `.dataframe`
#' @export
#'
#' @examples
#' hercacstables::search_in_columns(
#'   hercacstables::METADATA_FOR_ACS_GEOGRAPHIES,
#'   `Wildcard Option` = "."
#' )
#' hercacstables::search_in_columns(
#'   hercacstables::METADATA_FOR_ACS_GEOGRAPHIES,
#'   `-Wildcard Option` = "."
#' )
search_in_columns <- function(.dataframe, ...) {
    .termlist <- rlang::list2(...)
    .columns <- names(.termlist)
    if (length(.columns) != length(.termlist) ||
        any(nchar(.columns) == 0)) {
        rlang::abort("Each array of search terms must have a name.")
    }
    purrr::reduce2(.columns,
                   .termlist,
                   \(.df, .field, .terms) purrr::reduce(
                       .x = .terms,
                       .f = .reductive(.field),
                       .init = .df
                   ),
                   .init = .dataframe)
}
