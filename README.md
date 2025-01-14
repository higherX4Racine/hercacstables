
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
# install.packages("devtools")
devtools::install_github("higherX4Racine/hercacstables")
```

## Examples

The main way that one uses `hercacstables` to interact with the Census
API is the `hercacstables::fetch_data()` function.

### Population and number of households

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

### Decennial populations by race and ethnicity

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

## Going farther

Many questions that work with Census data follow a common pattern:

> How did \[measurement\] differ among \[demographic groups\] and across
> \[geographies\] during \[span of time\]?

To use this pattern, an investigator must determine some concrete
definitions for each of the bracketed concepts. The `hercacstables`
package provides tools for each of these four tasks. This site provides
detailed articles for each task because each one can be
[complex](https://www.census.gov/data/developers/guidance/api-user-guide.Core_Concepts.html).

- [Use one or more Census
  measurements](articles/determine_measurement.html)
- [Describe who or what has been
  measured](articles/determine_demographies.html)
- [Specify where the measurements were
  made](articles/determine_geographies.html)
- [Choose the year(s) that are
  relevant](articles/determine_timeframes.html)
