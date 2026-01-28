# Fetch glossary about a specific ACS data set from the Census API.

This function downloads a large JSON object and parses it into a tibble.

## Usage

``` r
fetch_metadata_table(.info_type, .year, .year_span)
```

## Arguments

- .info_type:

  One of "geography", "groups", or "variables".

- .year:

  An integer year between 2004 and the current year, inclusive.

- .year_span:

  Either 1, 3, or 5, depending upon the desired time resolution.

## Value

A tibble.
