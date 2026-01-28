# Geographic levels of organization for data from the US Census Bureau's API

Geographic levels of organization for data from the US Census Bureau's
API

## Usage

``` r
GEOGRAPHY_HIERARCHY_METADATA
```

## Format

A tibble with four columns

- Label:

  A short, title-case description of a geographic level

- Code:

  The three-digit code for a level

- Geography:

  The lowercase term used to query the API for a level

- Parent Geos:

  A character vector of other Geographies that must be specified to
  query for this level, like `c("Female", "Under 5 years")` or
  `c("With cash rent", "$350 to $399")`.
