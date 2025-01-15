# Copyright (C) 2025 by Higher Expectations for Racine County

.reductive <- function(.field) {
    function(.so_far, .next_term) dplyr::filter(
        .so_far,
        grepl(.next_term, .data[[.field]], ignore.case = TRUE)
    )
}

#' Search for terms in a glossary in case-insensitive ways
#'
#' Each of the dynamic arguments to this function must be a named array of
#' strings.
#' The function will look for each string in the column of `.glossary` that
#' corresponds to the argument's name. For example, providing the argument
#' `Universe = c("Wom[ae]n", "years?")` will search the "Universe" column for any
#' elements that include both "women"  or "woman" and "year" or "years".
#' The search is NOT case-sensitive.
#'
#' @param .glossary the glo
#' @param ... &lt;[rlang::dyn-dots]&gt; Named arrays of search terms.
#'
#' @returns &lt;dfr&gt; a filtered version of `.glossary`
#' @export
#'
#' @examples
#' hercacstables::search_in_glossary(
#'   hercacstables::GLOSSARY_OF_ACS_GEOGRAPHIES,
#'   `Wildcard Option` = "."
#' )
search_in_glossary <- function(.glossary, ...) {
    .termlist <- rlang::list2(...)
    purrr::reduce2(names(.termlist),
                   .termlist,
                   \(.dataframe, .field, .terms) purrr::reduce(
                       .x = .terms,
                       .f = .reductive(.field),
                       .init = .dataframe
                   ),
                   .init = .glossary)
}
