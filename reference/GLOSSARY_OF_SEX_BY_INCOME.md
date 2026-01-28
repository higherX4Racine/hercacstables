# Counts of people in income brackets, by sex and employment status.

The rows in this glossary apply to both table `B19325` AND `B20005`. The
difference is that `B19325` deals with all income and `B20005` just
earnings.

## Usage

``` r
GLOSSARY_OF_SEX_BY_INCOME
```

## Format

### GLOSSARY_OF_SEX_BY_INCEM

A data frame with 43 rows and 5 columns.

- Index:

  `<int>` The row in the source table that this GLOSSARY row describes.

- Sex:

  `<chr>` One of NA, "Male," or "Female"

- Full-time:

  `<lgl>` `TRUE` if employed full-time for the past year.

- Lower Bound:

  `<dbl>` the lowest income in the range, inclusive

- Upper Bound:

  `<dbl>` the greatest income in the range, inclusive

## Source

https://api.census.gov/data/2024/acs/acs1/groups/B19325.html

https://api.census.gov/data/2024/acs/acs1/groups/B20005.html
