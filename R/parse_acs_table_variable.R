#' Break an ACS "Variable" value into its three components.
#'
#' @param .x data.frame
#' @param col character
#'
#' @return data.frame
#' @export
#' @examples
#' parse_acs_table_variable(data.frame(Variable = "ABC123_456E"))

parse_acs_table_variable <- function(.x, col = "Variable") {
    ACS_TABLE_REGEX <- "([[:alnum:]]+)_([[:digit:]]+)(.*)"

    tidyr::extract(.x,
                   {{ col }},
                   c("Table",
                     "Row",
                     "Statistic Type"),
                   ACS_TABLE_REGEX,
                   convert = TRUE)
}
