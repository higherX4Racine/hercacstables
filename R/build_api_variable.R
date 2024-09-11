# Copyright (C) 2023 by Higher Expectations for Racine County

#' Vectorized Creation of Census ACS Variables
#'
#' All detail group variables have the format "B000OO*_000E", where the "B" and
#' "E" are literal and the "*" is a race code.
#'
#' @param group_code the group code, like "B18101"
#' @param item_number some integer between 0 and 999
#' @param race_code optional, either an empty string or one of \[A..I\]
#' @param separator optional, usually "_" for ACS variables.
#' @param suffix optional, usually "E" for ACS variables, but sometimes "N" for decennial data.
#'
#' @return a vector of strings, each of which is a variable name
#' @export
#'
#' @examples
#' groups <- c("B19013", "B18101", "B18101")
#' races <- c("", "", "I")
#' numbers <- 1
#' build_api_variable(groups, numbers, races)
build_api_variable <- function(group_code,
                               item_number,
                               race_code = "",
                               separator = "_",
                               suffix = "E"){
    paste0(
        group_code,
        race_code,
        separator,
        sprintf("%03d", item_number),
        suffix
    )
}
