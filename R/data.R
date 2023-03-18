#' Employment in the area served by Racine Unified School District, WI in 2019
#'
#' A list containing several stages of parsing results from querying the US
#' Census Bureau's data API for the American Community Survey. This set contains
#' the results from searching for summary table "C23002A" for the Racine Unified
#' School district (code 12360) in Wisconsin (55). It contains counts for white
#' people broken down by sex, age, and employment status.
#'
#' @format A list with 4 items:
#'  \describe{
#'    \item{url}{the actual URL used to query the Census's data API}
#'    \item{json}{The JSON-formatted string that the Census responded with}
#'    \item{list}{The list produced by \code{jsonlite::parse_json()}}
#'    \item{data}{A data frame produced by \code{acs_counts_list_to_tibble()}}
#'  }
#' @source
#'  \url{https://www.census.gov/data/developers/guidance/api-user-guide.html}
"rusd_c23002a"

#' Groups available for breaking down ACS employment data by sex and age
#'
#' A list containing several stages of parsing results from querying the US
#' Census Bureau's data API for the American Community Survey. This set contains
#' the results from searching for the summary table called "C23002A". That table
#' contains counts for white people broken down by sex, age, and employment
#' status.
#'
#' @format A list with 5 items:
#'   \describe{
#'     \item{url}{the actual URL used to query the Census's data API}
#'     \item{json}{The JSON-formatted string that the Census responded with}
#'     \item{list}{The list produced by \code{jsonlite::parse_json()}}
#'     \item{fields}{The fields that \code{acs_groups_list_to_tibble} uses}
#'     \item{data}{A data frame produced by \code{acs_groups_list_to_tibble()}}
#'   }
#' @source
#'   \url{https://www.census.gov/data/developers/guidance/api-user-guide.html}
"c23002a_groups"

#' Race and ethnicity codes and labels used by the U.S. Census Bureau
#'
#' @format A tibble with two columns:
#'   \describe{
#'     \item{code}{A capital letter designating a race or ethnicity}
#'     \item{label}{A short description of a race or ethnicity}
#'   }
"race_or_ethnicity"

#' Group, Variable, and Geography information for the latest 5-Year ACS
#'
#' @format A list with three items
#'   \describe{
#'   \item{geography}{Available geographies and how to ask for them in the API.}
#'   \item{groups}{Each group's ID, its Universe, and its Description.}
#'   \item{variables}{Each variable's Group, its full code, and its Label.}
#'   }
"METADATA_ACS5"
