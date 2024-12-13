# Copyright (C) 2024 by Higher Expectations for Racine County

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

#' Details about the groups in the most recent American Community Series
#'
#' In the context of ACS data, a "group" is what you would get from running a
#' query about a specific topic. For example, group B01001B reports population
#' numbers by sex and age, and group B25063 reports the number of housing units
#' in different rent brackets.
#'
#' @format A list with three items
#'   \describe{
#'   \item{Group}{The code for the group, such as "B01001B" or "B25063"}
#'   \item{Universe}{The population the data describe, such as "People who are Black or African American alone" or "Renter-occupied housing units"}
#'   \item{Description}{Details about what the table actually reports, such as "Sex by Age (Black or African American Alone)" and "Gross Rent."}
#'   \item{ACS1}{Whether this group is available in the most recent 1-year dataset.}
#'   \item{ACS5}{Whether this group is available in the most recent 5-year dataset.}
#'   }
#' @concept metadata
"ACS_GROUP_METADATA"

#' Details about variables in the most recent American Community Series
#'
#' In the context of ACS data, a "variable" is a single row of data from
#' running a query about a specific topic. For example, group B010001 reports population
#' numbers by sex and age, and group B25063 reports the number of housing units
#' in different rent brackets. Technically, there are 4 variables for each row:
#' the estimate, its margin of error, and annotations for each of those. In
#' practice, we usually just want the estimate..
#'
#' @format A list with three items
#'   \describe{
#'   \item{Dataset}{Whether this variable pertains to the 1-year or 5-year dataset.}
#'   \item{Group}{The code for the group, such as "B01001B" or "B25063"}
#'   \item{Index}{The row number in the group for this variable, like 2 or 5.}
#'   \item{Variable}{The full code for this variable, like "B01001B_002E" or "B25063_005E"}
#'   \item{Details}{A vector of one or more strings describing what the variable actually represents.}
#'   }
#' @concept metadata
"ACS_VARIABLE_METADATA"

#' Details about levels of geographic detail in the most recent American Community Series
#'
#' In the context of ACS data, "geography" is a specific type of geographical
#' area, such as a region, state, county, reservation, tract, or block. Some
#' geographical levels, such as region or state, can be given by themselves.
#' Others, such as county or place, must be queried within a specific containing
#' geographic level (usually state). Very small geographic areas, like blocks,
#' may require several levels of containing geographies, such as state, county,
#' and tract. Some containing geographies may be given as wildcards. For
#' example, you could ask for county-level data from every state all at once by
#' specifying "*" instead of a FIPS code for the state.
#'
#' @format A tibble with five columns
#' \describe{
#'   \item{Geographic Level}{The verbatim text that you must pass to the API when referring to this geographic level.}
#'   \item{Containing Geographies}{One or more sets of containing geographies that **must** be specified when querying for this level of geography}
#'   \item{Wildcard Option}{Which containing geography, if any, can be set to a wildcard when pulling data for this geographical level.}
#'   \item{ACS1}{A reference date if this level is available in the 1-year dataset, otherwise `NA`.}
#'   \item{ACS5}{A reference date if this level is available in the 5-year dataset, otherwise `NA`.}
#' }
#' @concept metadata
"ACS_GEOGRAPHY_METADATA"

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
#'   \item{Parent Geos}{A character vector of other Geographies that must be specified to query for this level, like `c("Female", "Under 5 years")` or `c("With cash rent", "$350 to $399")`.}
#' }
"GEOGRAPHY_HIERARCHY_METADATA"

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

#' The fundamental demographics of age and sex from table `B01001`
#'
#' The age splits are more detailed in the whole-population table than they are
#' in the tables that pertain to specific racial identities. A future project
#' is to add a second part to the table that maps from those tables' rows to
#' age and sex.
#'
#' @format ## AGE_AND_SEX_METADATA
#' A data frame with 49 rows and 6 columns.
#' \describe{
#' \item{group}{<chr> Always "B01001"}
#' \item{index}{<int> The row in the source table that this metadata row describes.}
#' \item{variable}{<chr> The full variable name, e.g. "B01001_001E"}
#' \item{Sex}{<chr> One of "All," "Male," or "Female"}
#' \item{Lower Age}{<int> inclusive, in \[-999, 85\]}
#' \item{Upper Age}{<int> inclusive, in \[4, 999\]}
#' }
#' @source https://api.census.gov/data/2022/acs/acs1/groups/B01001.html
"AGE_AND_SEX_METADATA"
