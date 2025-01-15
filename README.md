
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hercacstables

This package provides an R interface to the United States Census
Bureau’s data API. The primary focus, as per its name, is pulling
information from the [detailed tables of the American Community
Survey](https://www.census.gov/programs-surveys/acs/data/data-tables.html).

<!-- badges: start -->
<!-- badges: end -->

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("higherX4Racine/hercacstables")
```

## Fetching data from the API

The main way that one uses `hercacstables` to interact with the Census
API is the `fetch_data()` function.

## A vanilla call to `fetch_data()`

Here is a modestly complicated use of the function without any setup or
post-processing.

``` r
POPS_AND_HOUSEHOLDS <- hercacstables::fetch_data(
    # the API works one year at a time
    year = hercacstables::most_recent_vintage("acs", "acs1"),
    
    # the API can only query one data source at a time
    survey_type = "acs",           # the American Community Survey
    table_or_survey_code = "acs1", # the 1-year dataset of the ACS
    
    # the API fetches values for one or more instances of a specific geography
    for_geo = "state",             # fetch values for entire states
    for_items = c(
        "11",                      # the District of Columbia
        "72"                       # Puerto Rico
    ),
    
    # the codes for the specific data that we are fetching
    variables = c(
        "NAME",                    # the geographic area's name
        "B01001_001E",             # the total number of people
        "B11002_002E",             # people in family households
        "B11002_012E"              # people in nonfamily households
    )
)
```

| NAME                 | state | Group  | Index |     Value | Year |
|:---------------------|------:|:-------|------:|----------:|-----:|
| District of Columbia |    11 | B01001 |     1 |   678,972 | 2023 |
| District of Columbia |    11 | B11002 |     2 |   406,283 | 2023 |
| District of Columbia |    11 | B11002 |    12 |   235,088 | 2023 |
| Puerto Rico          |    72 | B01001 |     1 | 3,205,691 | 2023 |
| Puerto Rico          |    72 | B11002 |     2 | 2,613,461 | 2023 |
| Puerto Rico          |    72 | B11002 |    12 |   554,557 | 2023 |

## Identifying which items to fetch

People working with the Census often know the topic that they are
interested in, but not the specific variables that provide information
about that topic. The `hercacstables` package has utilities that help
you search for Census variables if you don’t already know which ones you
want to use.

### Search for groups with keywords

A good first step is to search for tables that could be relevant with
the `search_in_glossary()` function and the built-in
[`METADATA_FOR_ACS_GROUPS`](reference/METADATA_FOR_ACS_GROUPS.html).

The following example searches using three columns. The column “Group”
needs to end in a digit. That will limit the results to tables that
report numbers for all races. The column “Universe” needs to include the
string “population”. That will limit the results to tables that report
counts of people. The column “Description” needs to both start with the
string “school” and include the string “enroll”. This will limit the
results to tables about enrollment in school.

``` r
EDUCATION_TABLES <- hercacstables::search_in_glossary(
    hercacstables::METADATA_FOR_ACS_GROUPS,
    Group = "\\d$",
    Universe = "population",
    Description = c("^school", "enroll")
)
```

| Group | Universe | Description | ACS1 | ACS5 |
|:---|:---|:---|:---|:---|
| B14001 | Population 3 years and over | School Enrollment by Level of School for the Population 3 Years and Over | TRUE | TRUE |
| B14007 | Population 3 years and over | School Enrollment by Detailed Level of School for the Population 3 Years and Over | TRUE | TRUE |
| C14002 | Population 3 years and over | School Enrollment by Level of School by Type of School for the Population 3 Years and Over | TRUE | FALSE |
| C14003 | Population 3 years and over | School Enrollment by Type of School by Age for the Population 3 Years and Over | TRUE | FALSE |

### Unpack variables for a group

Once you know the group that you are interested in, you will want to see
what information is captured in each of its rows. The
`unpack_group_details()` function searches the built-in
[`METADATA_FOR_ACS_VARIABLES`](reference/METADATA_FOR_ACS_VARIABLES) for
all of the variables of one group. It then expands the Census’s
description of each variable into columns. Users will need to identify
the concepts that are captured by each column.

The following example unpacks the variables in the
[B14001](https://api.census.gov/data/2023/acs/acs1/B14001.html) table.

``` r
UNPACKED_B14001 <- hercacstables::unpack_group_details("B14001")
```

| Group | Index | Variable | A | B |
|:---|---:|:---|:---|:---|
| B14001 | 1 | B14001_001E |  |  |
| B14001 | 2 | B14001_002E | Enrolled in school |  |
| B14001 | 3 | B14001_003E | Enrolled in school | Enrolled in nursery school, preschool |
| B14001 | 4 | B14001_004E | Enrolled in school | Enrolled in kindergarten |
| B14001 | 5 | B14001_005E | Enrolled in school | Enrolled in grade 1 to grade 4 |
| B14001 | 6 | B14001_006E | Enrolled in school | Enrolled in grade 5 to grade 8 |
| B14001 | 7 | B14001_007E | Enrolled in school | Enrolled in grade 9 to grade 12 |
| B14001 | 8 | B14001_008E | Enrolled in school | Enrolled in college, undergraduate years |
| B14001 | 9 | B14001_009E | Enrolled in school | Graduate or professional school |
| B14001 | 10 | B14001_010E | Not enrolled in school |  |

## Shortcuts

The package also includes functions for common special cases. They are
wrappers for `fetch_data()` with some arguments hard-coded.

### Decennial populations by race and ethnicity

One example is pulling trends of racial/ethnic populations from the
decennial census for some specific geographical units.

``` r
POPS_BY_RACE <-
    hercacstables::fetch_decennial_pops_by_race(
        for_geo = "state", # one cannot fetch the whole nation from 2000 or 2010
        for_items = "*"    # so we pull the data for every state
    ) |>
    dplyr::count( # then compute the nationwide populations for each vintage
        .data$`Race/Ethnicity`,
        .data$Vintage,
        wt = .data$Population,
        name = "Population"
    ) |>
    tidyr::pivot_wider( # and reshape the table for display
        names_from = "Vintage",
        values_from = "Population"
    )
```

| Race/Ethnicity | 2000 | 2010 | 2020 |
|:---|---:|---:|---:|
| All | 285,230,516 | 312,471,327 | 334,735,155 |
| American Indian and Alaska Native | 2,069,446 | 2,247,427 | 2,252,011 |
| Asian | 10,126,044 | 14,468,054 | 19,621,465 |
| Black or African American | 33,952,901 | 37,690,511 | 39,944,624 |
| Hispanic or Latino | 39,068,564 | 54,166,049 | 65,329,087 |
| Native Hawaiian and Other Pacific Islander | 353,874 | 481,653 | 622,109 |
| Some other race | 468,155 | 605,291 | 1,692,341 |
| Two or more races | 4,604,792 | 5,967,844 | 13,551,323 |
| White | 194,586,740 | 196,844,498 | 191,722,195 |
