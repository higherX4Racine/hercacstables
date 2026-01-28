# Details about levels of geographic detail in the most recent American Community Series

In the context of ACS data, "geography" is a specific type of
geographical area, such as a region, state, county, reservation, tract,
or block. Some geographical levels, such as region or state, can be
given by themselves. Others, such as county or place, must be queried
within a specific containing geographic level (usually state). Very
small geographic areas, like blocks, may require several levels of
containing geographies, such as state, county, and tract. Some
containing geographies may be given as wildcards. For example, you could
ask for county-level data from every state all at once by specifying
"\*" instead of a FIPS code for the state.

## Usage

``` r
METADATA_FOR_ACS_GEOGRAPHIES
```

## Format

A tibble with five columns

- Geographic Level:

  The verbatim text that you must pass to the API when referring to this
  geographic level.

- Containing Geographies:

  One or more sets of containing geographies that **must** be specified
  when querying for this level of geography

- Wildcard Option:

  Which containing geography, if any, can be set to a wildcard when
  pulling data for this geographical level.

- ACS1:

  A reference date if this level is available in the 1-year dataset,
  otherwise `NA`.

- ACS5:

  A reference date if this level is available in the 5-year dataset,
  otherwise `NA`.

## Source

https://www.census.gov/programs-surveys/acs/geography-acs/concepts-definitions.html
