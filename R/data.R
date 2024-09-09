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
#'  https://www.census.gov/data/developers/guidance/api-user-guide.html
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
#'   https://www.census.gov/data/developers/guidance/api-user-guide.html
"c23002a_groups"

#' Race and ethnicity codes and labels used by the U.S. Census Bureau
#'
#' @format A tibble with ten rows and five columns:
#'   \describe{
#'     \item{Census Race}{A short description of a race or ethnicity}
#'     \item{Suffix}{A capital letter designating a race or ethnicity}
#'     \item{Inclusive Table}{The name of a table that includes people of single and multi-racial identities that claim this identity}
#'     \item{non-Hispanic}{The row in table `B03002` with counts of people with this racial identity and no Hispanic ethnic identity}
#'     \item{Hispanic}{The row in table `B03002` with counts of people with this racial identity and a Hispanic ethnic identity}
#'   }
"RACE_ETHNICITY_SUBTABLE_METADATA"

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
#' @source https://api.census.gov/data
"CENSUS_API_URL"

#' Census labels for different levels of educational achievement
#'
#' The census breaks down educational attainment to different levels of detail
#' in different tables. For example, there are 8 levels in
#' [`B15001`](https://api.census.gov/data/2021/acs/acs5/groups/B15001.html), but
#' only 5 in the
#' [`C15002*`](https://api.census.gov/data/2021/acs/acs5/groups/C15002H.html)
#' tables. Each row in this table connects a detailed level with a broader one.
#'
#' @format A tibble with two columns
#' \describe{
#'   \item{Detailed}{a factor with 8 levels}
#'   \item{Broad}{a factor with 5 levels}
#' }
#'
#' @source https://api.census.gov/data
"EDUCATIONAL_ATTAINMENT_LEVELS"

#' Census variables for different levels of educational achievement
#'
#' The census breaks down educational attainment to different levels of detail
#' in different tables. For example, there are 8 levels in
#' [`B15001`](https://api.census.gov/data/2021/acs/acs5/groups/B15001.html), but
#' only 5 in the
#' [`C15002*`](https://api.census.gov/data/2021/acs/acs5/groups/C15002H.html)
#' tables or
#' [`B17003`](https://api.census.gov/data/2021/acs/acs5/groups/B17003.html).
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
#' @source https://api.census.gov/data
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
#' @source api.census.gov/data/acs/acs5/groups.html
"EMPLOYMENT_STATUS_METADATA"

#' Variables describing unemployment at two levels of age granularity
#'
#' @format ## UNEMPLOYMENT_VARIABLES
#' A data frame with 140 rows and 7 columns
#' \describe{
#'   \item{Sex}{<chr> Female or Male}
#'   \item{Lower Age}{<int> 16 to 75}
#'   \item{`Upper Age}{<int> 19 to Inf}
#'   \item{Labor Status}{<chr> "In armed services", "Employed", "Unemployed", or "Not in labor force"}
#'   \item{Group}{<chr> "B23001" (more granular) or "C23001" (less granular)}
#'   \item{Index}{<int> The actual number of the variable in the ACS table.}
#'   \item{Variable}{<chr> The full ACS variable name for the estimate, e.g. "B23001_001E"}
#' }
"UNEMPLOYMENT_VARIABLES"

#' Categorize ACS variables about income : poverty level ratios by family sustainability
#'
#' These data come from table B17026, "RATIO OF INCOME TO POVERTY LEVEL OF
#' FAMILIES IN THE PAST 12 MONTHS."
#' A family-sustaining wage is widely considered to be three times the federal
#' poverty level.
#'
#' @format ## STANDARD_OF_LIVING_METADATA
#' A data frame with 13 rows and 6 columns
#' \describe{
#'   \item{Group}{<chr> The table, always "B17026"}
#'   \item{Variable}{<chr> The full variable name, e.g. "B17026_001E"}
#'   \item{Index}{<int> The row of this variable in the table}
#'   \item{Least Poverty Ratio}{<dbl> The lowest ratio of income to poverty level in this tier}
#'   \item{Greatest Poverty Ratio}{<dbl> The highest ratio of income to poverty level in this tier}
#'   \item{Standard of Living}{<chr> One of "Everyone," "Unsustainable," or "Self-sustaining"}
#' }
#' @source https://api.census.gov/data/2022/acs/acs1/groups/B17026.html
"STANDARD_OF_LIVING_METADATA"

#' Categorize ACS variables counting families by number of children
#'
#' These data come from table B11003, "FAMILY TYPE BY PRESENCE AND AGE OF OWN CHILDREN UNDER 18 YEARS"
#'
#' @format ## FAMILIES_WITH_CHILDREN_METADATA
#' A data frame with 12 rows and 6 columns
#' \describe{
#'   \item{Group}{<chr> The table, always "B11003"}
#'   \item{Variable}{<chr> The full variable name, e.g. "B11003_001E"}
#'   \item{Index}{<int> The row of this variable in the table}
#'   \item{Adults}{<chr> The adult(s) heading the household}
#'   \item{Children under 6}{<lgl> Are there any children under 6 in this family?}
#'   \item{Childr 6-17}{<lgl> Are there any children 6-17 in this family?}
#' }
#' @source https://api.census.gov/data/2022/acs/acs1/groups/B11003.html
"FAMILIES_WITH_CHILDREN_METADATA"

#' Categorize ACS variables about children per family
#'
#' These data come from table B17026, "OWN CHILDREN UNDER 18 YEARS BY FAMILY
#' TYPE AND AGE"
#'
#' @format ## CHILDREN_PER_FAMILY_METADATA
#' A data frame with 15 rows and 6 columns
#' \describe{
#'   \item{Group}{<chr> The table, always "B09002"}
#'   \item{Variable}{<chr> The full variable name, e.g. "B09002_001E"}
#'   \item{Index}{<int> The row of this variable in the table}
#'   \item{Adults}{<chr> The adult(s) heading the household}
#'   \item{Lower Age}{<int> The age of the youngest children counted by this variable}
#'   \item{Upper Age}{<int> The age of the oldest children counted by this variable}
#' }
#' @source https://api.census.gov/data/2022/acs/acs1/groups/B09002.html
"CHILDREN_PER_FAMILY_METADATA"

#' Categorize ACS variables about children living in poverty and parents' birth origins
#'
#' These data come from table B05010, "RATIO OF INCOME TO POVERTY LEVEL IN THE
#' PAST 12 MONTHS BY NATIVITY OF CHILDREN UNDER 18 YEARS IN FAMILIES AND
#' SUBFAMILIES BY LIVING ARRANGEMENTS AND NATIVITY OF PARENTS."
#'
#' @format ## CHILDREN_IN_POVERTY_METADATA
#' A data frame with 15 rows and 8 columns
#' \describe{
#'   \item{Group}{<chr> The table, always "B05010"}
#'   \item{Variable}{<chr> The full variable name, e.g. "B05010_001E"}
#'   \item{Index}{<int> The row of this variable in the table}
#'   \item{Least Poverty Ratio}{<dbl> The lowest ratio of income to poverty level in this tier}
#'   \item{Greatest Poverty Ratio}{<dbl> The highest ratio of income to poverty level in this tier}
#'   \item{Standard of Living}{<chr> One of "Unsustainable," or "Mixed"}
#'   \item{Native-born Parents}{<int> How many of the parents in the household were born in the USA.}
#'   \item{Foreign-born Parents}{<int> How many of the parents in the household were not born in the USA.}
#' }
#' @source https://api.census.gov/data/2022/acs/acs1/groups/B05010.html
"CHILDREN_IN_POVERTY_METADATA"

#' US population size for 10 different race/ethnicity categories in 2022
#'
#' This is an example set that emulates the results of running
#' [`fetch_data()`] for two different sets of ACS tables.
#' The data for the "broad" level of detail are from tables B01001 its prefix-
#' designated sub-tables, such as B01001H for
#'   * labeled as "broad" in the Detail Level field.
#'   * which has population by age, with different tables for each identity
#' * B03002 - which has population by race x ethnicity
#'
#' The data from the B01001 tables are all from the first row, which is the
#' total population of that particular racial/ethnic identity.
#' The data from table B03002 are
#'
#' @format ## US_RACE_ETHNICITY_POPS_2022
#' A data frame with 10 rows and 5 columns
#' \describe{
#'   \item{us}{<int> The geography used in the API call. Always 1}
#'   \item{Group}{<chr> The source table for the row, "B01001" with a suffix.}
#'   \item{Index}{<int> The row of this variable in the table. Always 1}
#'   \item{Value}{<int> The number of people in the race/ethnicity category.}
#'   \item{Year}{<int> The year used in the API call. Always 2022}
#' }
#' @source https://api.census.gov/data/2022/acs/acs5/groups.html
"US_RACE_ETHNICITY_POPS_2022"

