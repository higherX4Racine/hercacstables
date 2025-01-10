
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hercacstables

<!-- badges: start -->
<!-- badges: end -->

## Example

The main way that one uses `hercacstables` to interact with the Census
API is the `hercacstables::fetch_data()` function.

``` r
POPS_AND_HOUSEHOLDS <- hercacstables::fetch_data(
    # the database that we are fetching data from
    survey_type = "acs",           # the American Community Survey
    table_or_survey_code = "acs1", # the 1-year dataset of the ACS
    year = hercacstables::most_recent_vintage("acs", "acs1"),
                                   # the API works one year at a time
    
    # the geographic level of detail that we are fetching data for
    for_geo = "state",             # fetch values for entire states
    for_items = c(
        "11",                      # the District of Columbia
        "72"                       # Puerto Rico
    ),
    
    # the specific data that we are fetching
    variables = c(
        "NAME",                    # the geographic area's name
        "B01001_001E",             # the total number of people
        "B11002_002E",             # people in family households
        "B11002_012E"              # people in nonfamily households
    )
)
```

| NAME                 | state | Group  | Index |   Value | Year |
|:---------------------|:------|:-------|------:|--------:|-----:|
| District of Columbia | 11    | B01001 |     1 |  678972 | 2023 |
| District of Columbia | 11    | B11002 |     2 |  406283 | 2023 |
| District of Columbia | 11    | B11002 |    12 |  235088 | 2023 |
| Puerto Rico          | 72    | B01001 |     1 | 3205691 | 2023 |
| Puerto Rico          | 72    | B11002 |     2 | 2613461 | 2023 |
| Puerto Rico          | 72    | B11002 |    12 |  554557 | 2023 |

## Overview

Many questions that work with Census data follow a common pattern:

> How did \[measurement\] differ among \[demographic groups\] and across
> \[geographies\] during \[span of time\]?

To use this pattern, an investigator must determine some concrete
definitions for each of the bracketed concepts. The `hercacstables`
package provides tools for each of these four tasks. This site provides
detailed articles for each task because each one can be
[complex](https://www.census.gov/data/developers/guidance/api-user-guide.Core_Concepts.html).

- Use one or more Census measurements:
  `vignette("determine-measurement")`
- Describe who or what has been measured:
  `vignette("determine-demographies")`
- Specify where the measurements were made:
  `vignette("determine-geographies")`
- Choose the year(s) that are relevant:
  `vignette("determine-timeframes")`

## For the newest R users:

You may be new to R, but not data science, in which case I suggest
checking out [R for Data Science](https://r4ds.hadley.nz/intro.html). If
you’re not coming from a data science perspective, I have heard good
things about [this book](https://datascienceineducation.com/).

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("higherX4Racine/hercacstables")
```

## Motivation

The American Community Survey (ACS) from the US Census’s website
provides a vast amount of useful data.

However, it returns those data in a weirdly idiosyncratic way. Even
though the output seems tabular, the data are really organized in a
tree-like fashion. This package is intended to make it easy to access
and use the ACS data with R.

## Example
