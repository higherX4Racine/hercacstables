# Query the Census API for the most recent release year of a dataset.

Query the Census API for the most recent release year of a dataset.

## Usage

``` r
most_recent_vintage(survey_type, table_or_survey_code)
```

## Arguments

- survey_type:

  e.g. "acs" or "dec"

- table_or_survey_code:

  e.g. "acs5" or "pl"

## Value

an integer, probably at least 2024
