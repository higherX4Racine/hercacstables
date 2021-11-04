#' Build the URL for the JSON metadata file for an ACS summary table
#'
#' @param year int, The reference year for the survey product
#' @param vintage int, Denotes the time-span the data are averaged over
#' @param table_name char, An ACS summary table's full name, e.g. "C23002A".
#'
#' @return char : The URL of a JSON file on the Census's website.
#' @export
#'
#' @examples
#' acs_groups_url(2020, 5, "C23002A")

acs_groups_url <- function(year, vintage, table_name) {
    stringr::str_c(
        CENSUS_API_ROOT_URL,
        "/",
        year,
        "/acs/acs",
        vintage,
        "/groups/",
        table_name,
        ".json"
    )
}
