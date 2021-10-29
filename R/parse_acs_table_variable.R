#' Break an ACS "Variable" value into its three components.
#'
#' @param .x tibble
#' @param col character
#'
#' @return tibble
#' @export
#' @examples
#' parse_acs_table_variable(dplyr::tibble(Variable = "ABC123_456E"))
#' #> # A tibble: 1 x 3
#' #>   Table    Row `Statistic Type`
#' #>   <chr>  <int> <chr>
#' #> 1 ABC123   456 E

parse_acs_table_variable <- function(.x, col = "Variable") {
    ACS_TABLE_REGEX <- "([[:alnum:]]+)_([[:digit:]]+)(.*)"

    tidyr::extract(.x,
                   col,
                   c("Table",
                     "Row",
                     "Statistic Type"),
                   ACS_TABLE_REGEX,
                   convert = TRUE)
}
