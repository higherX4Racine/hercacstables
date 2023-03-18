#' Unite the grouping variables that define them to the counts from the ACS
#'
#' @param acs_counts A data frame of counts per "Table" and "Row"
#' @param acs_groups A data frame of grouping variables for "Table" and "Row"
#'
#' @return A data frame where the counts and grouping variables are joined
#' @export
#'
#' @examples
#' TBD <- NULL
join_counts_and_groups <- function(acs_counts,
                                   acs_groups) {
  dplyr::left_join(acs_groups,
    acs_counts,
    by = c("Table", "Row")
  )
}
