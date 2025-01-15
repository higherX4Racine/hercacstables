#' Today's year in the Gregorian calendar.
#'
#' @return &lt;int&gt; probably 2024 or later
#' @export
#'
#' @examples
#' the_year_right_now()
#'
#' @seealso [as.POSIXlt()], [Sys.Date()]
the_year_right_now <- function(){
    as.POSIXlt(Sys.Date())$year + 1900L
}
