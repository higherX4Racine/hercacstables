# Get the URL for JSON glossary about one table of ACS data

This will be a complete URL, including protocol and file extension, for
downloading glossary about geographies, groups of variables, or specific
variables.

## Usage

``` r
build_info_url(.info_type, .year, .year_span)
```

## Arguments

- .info_type:

  One of "geography", "groups", or "variables".

- .year:

  An integer year between 2004 and the current year, inclusive.

- .year_span:

  Either 1, 3, or 5, depending upon the desired time resolution.

## Value

A string that contains a URL.

## Examples

``` r
hercacstables:::build_info_url("groups", 2021L, 5L)
#> [1] "https://api.census.gov/data/2021/acs/acs5/groups.json"
```
