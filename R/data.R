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
"RACE_ETHNICITY_SUBTABLES"

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
#' @source https://www.census.gov/programs-surveys/acs/technical-documentation/table-shells.html
"METADATA_FOR_ACS_GROUPS"

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
#' @source https://www.census.gov/programs-surveys/acs/technical-documentation/table-shells.html
"METADATA_FOR_ACS_VARIABLES"

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
#' @source https://www.census.gov/programs-surveys/acs/geography-acs/concepts-definitions.html
"METADATA_FOR_ACS_GEOGRAPHIES"

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
"GLOSSARY_OF_EDUCATIONAL_ATTAINMENT"

#' Factor values associated with specific rows within employment-related ACS tables
#'
#' @format ## GLOSSARY_OF_EMPLOYMENT_STATUS
#' A data frame with 439 rows and 12 columns:
#' \describe{
#'   \item{group}{`<chr>`}
#'   \item{index}{`<int>`}
#'   \item{variable}{`<chr>`}
#'   \item{Sex}{`<chr>`}
#'   \item{Lower Age}{`<int>`}
#'   \item{Upper Age}{`<int>`}
#'   \item{Labor Force}{`<chr>`}
#'   \item{Enlistment}{`<chr>`}
#'   \item{Employment}{`<chr>`}
#'   \item{Suffix}{`<chr>`}
#'   \item{Census Race/Ethnicity}{`<chr>`}
#'   \item{Poverty}{`<chr>`}
#' }
#' @source api.census.gov/data/acs/acs5/groups.html
"GLOSSARY_OF_EMPLOYMENT_STATUS"

#' Categorize ACS variables about income : poverty level ratios by family sustainability
#'
#' These data come from table B17026, "RATIO OF INCOME TO POVERTY LEVEL OF
#' FAMILIES IN THE PAST 12 MONTHS."
#' A family-sustaining wage is widely considered to be three times the federal
#' poverty level.
#'
#' @format ## GLOSSARY_OF_STANDARD_OF_LIVING
#' A data frame with 13 rows and 6 columns
#' \describe{
#'   \item{Group}{`<chr>` The table, always "B17026"}
#'   \item{Variable}{`<chr>` The full variable name, e.g. "B17026_001E"}
#'   \item{Index}{`<int>` The row of this variable in the table}
#'   \item{Least Poverty Ratio}{`<dbl>` The lowest ratio of income to poverty level in this tier}
#'   \item{Greatest Poverty Ratio}{`<dbl>` The highest ratio of income to poverty level in this tier}
#'   \item{Standard of Living}{`<chr>` One of "Everyone," "Unsustainable," or "Self-sustaining"}
#' }
#' @source https://api.census.gov/data/2022/acs/acs1/groups/B17026.html
"GLOSSARY_OF_STANDARD_OF_LIVING"

#' Categorize ACS variables counting families by number of children
#'
#' These data come from table B11003, "FAMILY TYPE BY PRESENCE AND AGE OF OWN CHILDREN UNDER 18 YEARS"
#'
#' @format ## GLOSSARY_OF_FAMILIES_WITH_CHILDREN
#' A data frame with 12 rows and 6 columns
#' \describe{
#'   \item{Group}{`<chr>` The table, always "B11003"}
#'   \item{Variable}{`<chr>` The full variable name, e.g. "B11003_001E"}
#'   \item{Index}{`<int>` The row of this variable in the table}
#'   \item{Adults}{`<chr>` The adult(s) heading the household}
#'   \item{Children under 6}{`<lgl>` Are there any children under 6 in this family?}
#'   \item{Childr 6-17}{`<lgl>` Are there any children 6-17 in this family?}
#' }
#' @source https://api.census.gov/data/2022/acs/acs1/groups/B11003.html
"GLOSSARY_OF_FAMILIES_WITH_CHILDREN"

#' Categorize ACS variables about children per family
#'
#' These data come from table B17026, "OWN CHILDREN UNDER 18 YEARS BY FAMILY
#' TYPE AND AGE"
#'
#' @format ## GLOSSARY_OF_CHILDREN_PER_FAMILY
#' A data frame with 15 rows and 6 columns
#' \describe{
#'   \item{Group}{`<chr>` The table, always "B09002"}
#'   \item{Variable}{`<chr>` The full variable name, e.g. "B09002_001E"}
#'   \item{Index}{`<int>` The row of this variable in the table}
#'   \item{Adults}{`<chr>` The adult(s) heading the household}
#'   \item{Lower Age}{`<int>` The age of the youngest children counted by this variable}
#'   \item{Upper Age}{`<int>` The age of the oldest children counted by this variable}
#' }
#' @source https://api.census.gov/data/2022/acs/acs1/groups/B09002.html
"GLOSSARY_OF_CHILDREN_PER_FAMILY"

#' Categorize ACS variables about children living in poverty and parents' birth origins
#'
#' These data come from table B05010, "RATIO OF INCOME TO POVERTY LEVEL IN THE
#' PAST 12 MONTHS BY NATIVITY OF CHILDREN UNDER 18 YEARS IN FAMILIES AND
#' SUBFAMILIES BY LIVING ARRANGEMENTS AND NATIVITY OF PARENTS."
#'
#' @format ## GLOSSARY_OF_CHILDREN_IN_POVERTY
#' A data frame with 15 rows and 8 columns
#' \describe{
#'   \item{Group}{`<chr>` The table, always "B05010"}
#'   \item{Variable}{`<chr>` The full variable name, e.g. "B05010_001E"}
#'   \item{Index}{`<int>` The row of this variable in the table}
#'   \item{Least Poverty Ratio}{`<dbl>` The lowest ratio of income to poverty level in this tier}
#'   \item{Greatest Poverty Ratio}{`<dbl>` The highest ratio of income to poverty level in this tier}
#'   \item{Standard of Living}{`<chr>` One of "Unsustainable," or "Mixed"}
#'   \item{Native-born Parents}{`<int>` How many of the parents in the household were born in the USA.}
#'   \item{Foreign-born Parents}{`<int>` How many of the parents in the household were not born in the USA.}
#' }
#' @source https://api.census.gov/data/2022/acs/acs1/groups/B05010.html
"GLOSSARY_OF_CHILDREN_IN_POVERTY"

#' The fundamental demographics of age and sex from tables `B01001[ A-H]`
#'
#' The age splits are more detailed in the whole-population table than they are
#' in the tables that pertain to specific racial identities.
#'
#' @format ## GLOSSARY_OF_AGE_AND_SEX
#' A data frame with 80 rows and 5 columns.
#' \describe{
#'   \item{Suffix}{`<lgl>` TRUE for race-specific tables and FALSE for the all-races table.}
#'   \item{Index}{`<int>` The row in the source table that this GLOSSARY row describes.}
#'   \item{Sex}{`<chr>` One of "All," "Male," or "Female"}
#'   \item{Lower Age}{`<int>` the least age in the range, inclusive}
#'   \item{Upper Age}{`<int>` the greatest age in the range, inclusive}
#' }
#' @source https://api.census.gov/data/2022/acs/acs1/groups/B01001.html
"GLOSSARY_OF_AGE_AND_SEX"

#' Counts of people in income brackets, by sex and employment status.
#'
#' The rows in this glossary apply to both table `B19325` AND `B20005`. The
#' difference is that `B19325` deals with all income and `B20005` just earnings.
#'
#' @format ## GLOSSARY_OF_SEX_BY_INCEM
#' A data frame with 43 rows and 5 columns.
#' \describe{
#'   \item{Index}{`<int>` The row in the source table that this GLOSSARY row describes.}
#'   \item{Sex}{`<chr>` One of NA, "Male," or "Female"}
#'   \item{Full-time}{`<lgl>` `TRUE` if employed full-time for the past year.}
#'   \item{Lower Bound}{`<dbl>` the lowest income in the range, inclusive}
#'   \item{Upper Bound}{`<dbl>` the greatest income in the range, inclusive}
#' }
#' @source https://api.census.gov/data/2024/acs/acs1/groups/B19325.html
#' @source https://api.census.gov/data/2024/acs/acs1/groups/B20005.html
"GLOSSARY_OF_SEX_BY_INCOME"

#' A Census table's ID always starts with an alphanumeric code for its type.
#'
#' @format ## TYPES_OF_TABLE
#' A data frame with 11 rows and 3 columns.
#' \describe{
#' \item{Table ID Characters}{`<chr>` The alphanumeric code for this type of table}
#' \item{Type of Table}{`<chr>` A human-readable name for the type of table.}
#' \item{Contains}{`<chr>` A description of what information this type of table will contain.}
#' }
#' @source https://www.census.gov/programs-surveys/acs/data/data-tables/table-ids-explained.html
"TYPES_OF_TABLE"

#' A code for the broad subject that a Census table covers.
#'
#' The second 2 characters identify the subject of the table.
#' These only apply to B, C, K20, S, R, and GCT Tables.
#' Profiles DP, NP, CP, and S0201 cover multiple topics, so they do not have any
#' characters to indicate a subject.
#'
#' @format ## TYPES_OF_SUBJECT
#' A data frame with 31 rows and 2 columns.
#' \describe{
#' \item{Subject Number}{`<chr>` The zero-padded numeric code for this subject}
#' \item{Subject Name}{`<chr>` A very short description of the subject.}
#' }
#' @source https://www.census.gov/programs-surveys/acs/data/data-tables/table-ids-explained.html
"TYPES_OF_SUBJECT"

#' For selected tables, an alphabetic suffix follows to indicate that a table is repeated for the nine major race and Hispanic or Latino groups:
#'
#' @format ## TYPES_OF_RACE_OR_ETHNICITY
#' A data frame with 9 rows and 2 columns.
#' \describe{
#' \item{Code}{`<chr>` A one-letter suffix}
#' \item{Race or Ethnic Group}{`<chr>` A racial or ethnic identity such as "Black Alone" or "Hispanic or Latino".}
#' }
#' @source https://www.census.gov/programs-surveys/acs/data/data-tables/table-ids-explained.html
"TYPES_OF_RACE_OR_ETHNICITY"

#' ACS data contain variables ending in 1- or 2-letter codes.
#'
#' This table defines each variable type and its meaning.
#'
#' @format ## TYPES_OF_VARIABLE
#' A data frame with 7 rows and 4 columns.
#' \describe{
#' \item{Variable Type}{`<chr>` A 1- or 2-letter code}
#' \item{Title}{`<chr>` A human-readable name for the type of variable.}
#' \item{Related Products}{`<chr>` The types of Census data that contain this kind of variable.}
#' \item{Meaning}{`<chr>` A detailed explanation of what this kind of variable represents.}
#' }
#' @source https://www.census.gov/data/developers/data-sets/acs-1year/notes-on-acs-api-variable-types.html
"TYPES_OF_VARIABLE"

#' ACS data on sex, age, and labor force status
#'
#' @format ## GLOSSARY_OF_LABOR_FORCE_PARTICIPATION
#' A data frame with 172 rows and 10 columns
#' \describe{
#' \item{Dataset}{`<chr>` "ACS1" or "ACS5"}
#' \item{Group}{`<chr>` Always "B23001"}
#' \item{Index}{`<int>` the row number of the variable}
#' \item{Variable}{`<chr>` the full variable}
#' \item{Sex}{`<chr>` "Male" or "Female"}
#' \item{Lower Age}{`<int>` between 16 and 75, inclusive}
#' \item{Upper Age}{`<int>` between 19 and 999, inclusive}
#' \item{Labor Force}{`<lgl>`}
#' \item{Civilian}{`<lgl>`}
#' \item{Employed"}{`<lgl>`}
#' }
"GLOSSARY_OF_LABOR_FORCE_PARTICIPATION"
