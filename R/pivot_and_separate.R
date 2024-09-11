#' Take a wide-formatted response from the Census API and convert it to long
#'
#' @param .frame a data frame from the census with columns named like `B01001_001E`
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> named regular expressions for extracting fields from the column names
#'
#' @return a pivoted data frames where the columns that matched the regular expression are converted to rows that are described by the extracted fields.
#' @keywords internal
#'
#' @seealso [tidyr::pivot_longer()]
#' @seealso [tidyr::separate_wider_regex()]
pivot_and_separate <- function(.frame, ...) {
    tryCatch(
        error = \(.ignored) .frame,
        .frame |>
            tidyr::pivot_longer(
                cols = tidyselect::matches(paste0(...)),
                names_to = "Variable",
                values_to = "Value"
            ) |>
            dplyr::mutate(
                Value = as.numeric(.data$Value)
            ) |>
            tidyr::separate_wider_regex(
                "Variable",
                patterns = c(...),
            )
    )
}
