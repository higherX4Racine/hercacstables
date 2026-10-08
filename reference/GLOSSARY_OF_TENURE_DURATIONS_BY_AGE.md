# Tenure by age of householder and the length of their current residence

A note of warning! The data for this table come from the biennial
[American Housing Survey](https://www.census.gov/programs-surveys/ahs),
so you should only use data from even-numbered years.

## Usage

``` r
GLOSSARY_OF_TENURE_DURATIONS_BY_AGE
```

## Format

### GLOSSARY_OF_TENURE_BY_AGE

A data frame with 36 rows and 8 columns

- Group:

  `<chr>` Always "B25128"

- Index:

  `<int>` The row number from the table

- Variable:

  `<chr>` The full code needed to query the API for this value

- Tenure:

  `<chr>` Renter or Owner occupied

- Lower Age:

  `<int>` The age of the youngest householders in this count

- Upper Age:

  `<int>` The age of the oldest householders in this count

- Shortest Duration:

  `<int>` The fewest years of residency in this count

- Longest Duration:

  `<int>` The most years of residency in this count

## Source

https://api.census.gov/data/2024/acs/acs5/groups/B25128.html
