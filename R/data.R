#' Employment in the area served by Racine Unified School District, WI in 2019
#'
#' A list containing several stages of parsing results from querying the US
#' Census Bureau's data API for the American Community Survey.
#'
#' @format A list with 4 items:
#' \describe{
#'   \item{url}{the actual URL used to query the Census's data API}
#'   \item{json}{The JSON-formatted string that the Census responded with}
#'   \item{list}{The list produced by \code{jsonlite::parse_json()}}
#'   \item{data}{A data frame produced by \code{acs_counts_list_to_tibble()}}
#' }
#' @source \url{https://www.census.gov/data/developers/guidance/api-user-guide.html}
"rusd_c23002a"
