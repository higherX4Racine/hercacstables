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
#'  [https://www.census.gov/data/developers/guidance/api-user-guide.html]
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
#'   [https://www.census.gov/data/developers/guidance/api-user-guide.html]
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

#' Variables in B21005: Age x Veteran x Employed for Civilians 18-64
#'
#' @format A tibble with seven columns
#' \describe{
#'   \item{Name}{The name of the variable, e.g. B21005_0001E}
#'   \item{Age}{The Census's description of the age range described by this variable.}
#'   \item{Veteran}{`TRUE` if the variable describes veterans, and `NA` for subtotals.}
#'   \item{In Labor Force}{`TRUE`, `FALSE`, or `NA` for subtotals.}
#'   \item{Employed}{`TRUE`, `FALSE`, or `NA` for subtotals.}
#'   \item{Lower Age}{The lowest age that this variable describes.}
#'   \item{Upper Age}{The highest age that this variable describes.}
#' }
"B21005_VARIABLES"

#' Variables from the Decennial censuses
#'
#' @format A tibble with five columns
#' \describe{
#'   \item{Year}{The year of the decennial census.}
#'   \item{Group}{The table that the variables come from.}
#'   \item{Race/Ethnicity}{The OMB label for a race/ethnic group.}
#'   \item{Index}{The row in the table that corresponds to the race/ethnicity.}
#'   \item{Variable}{The name of the variable for an API call}
#' }
"DECENNIAL_POPULATION_FIELDS"

#' Geographic levels of organization for data from the US Census Bureau's API
#'
#' @format A tibble with four columns
#' \describe{
#'   \item{Label}{A short, title-case description of a geographic level}
#'   \item{Code}{The three-digit code for a level}
#'   \item{Geography}{The lowercase term used to query the API for a level}
#'   \item{Parent Geos}{A character vector of other Geographies that must be specified to query for this level.}
#' }
"GEOGRAPHY_HIERARCHY_METADATA"

#' The current URL for accessing the U.S. Census Bureau's API.
#' @source [https://api.census.gov/data]
"CENSUS_API_URL"

#' Variables for querying populations by race and ethnicity
"ACS_RACE_ETHNICITY_VARIABLES"

#' Census labels for different levels of educational achievement
#'
#' The census breaks down educational attainment to different levels of detail
#' in different tables. For example, there are 8 levels in
#' [`B15001`][https://api.census.gov/data/2021/acs/acs5/groups/B15001.html], but
#' only 5 in the
#' [`C15002*`][https://api.census.gov/data/2021/acs/acs5/groups/C15002H.html]
#' tables. Each row in this table connects a detailed level with a broader one.
#'
#' @format A tibble with two columns
#' \describe{
#'   \item{Detailed}{a factor with 8 levels}
#'   \item{Broad}{a factor with 5 levels}
#' }
#'
#' @source [https://api.census.gov/data]
"EDUCATIONAL_ATTAINMENT_LEVELS"

#' Census variables for different levels of educational achievement
#'
#' The census breaks down educational attainment to different levels of detail
#' in different tables. For example, there are 8 levels in
#' [`B15001`][https://api.census.gov/data/2021/acs/acs5/groups/B15001.html], but
#' only 5 in the
#' [`C15002*`][https://api.census.gov/data/2021/acs/acs5/groups/C15002H.html]
#' tables or
#' [`B17003`][https://api.census.gov/data/2021/acs/acs5/groups/B17003.html].
#' Each row in this table connects a detailed level with a broader one.
#'
#' @format A list of three data frames
#'
#' **sex_age**
#'   : A data frame with eight variables
#'   * group     : chr
#'   * index     : int
#'   * variable  : chr
#'   * Sex       : chr
#'   * Lower Age : int
#'   * Upper Age : int
#'   * Age       : chr
#'   * Education : Factor
#'
#' **race_ethnicity**
#'   : A data frame with ten variables
#'   * group                 : chr
#'   * index                 : int
#'   * Sex                   : chr
#'   * Lower Age             : int
#'   * Upper Age             : int
#'   * Age                   : chr
#'   * Education             : Factor
#'   * Suffix                : chr
#'   * Census Race/Ethnicity : chr
#'   * variable              : chr
#'
#' **poverty**
#'   : A data frame with six variables
#'   * group     : chr
#'   * index     : int
#'   * variable  : chr
#'   * Sex       : chr
#'   * Education : Factor
#'   * Poverty   : chr
#'   * Lower Age : int
#'   * Upper Age : int
#'   * Age       : chr
#'
#' @source [https://api.census.gov/data]
"EDUCATIONAL_ATTAINMENT_METADATA"

#' Factor values associated with specific rows within employment-related ACS tables
#'
#' @format ## EMPLOYMENT_STATUS_METADATA
#' A data frame with 439 rows and 12 columns:
#' \describe{
#'   \item{group}{<chr>}
#'   \item{index}{<int>}
#'   \item{variable}{<chr>}
#'   \item{Sex}{<chr>}
#'   \item{Lower Age}{<int>}
#'   \item{Upper Age}{<int>}
#'   \item{Labor Force}{<chr>}
#'   \item{Enlistment}{<chr>}
#'   \item{Employment}{<chr>}
#'   \item{Suffix}{<chr>}
#'   \item{Census Race/Ethnicity}{<chr>}
#'   \item{Poverty}{<chr>}
#' }
#' @source [api.census.gov/data/acs/acs5/groups.html]
"EMPLOYMENT_STATUS_METADATA"
