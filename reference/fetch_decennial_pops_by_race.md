# Get decennial census estimates of per-block populations by race/ethnicity

This function retrieves data from tables that split people into race and
Hispanic/Latin\\ ethnicity.

## Usage

``` r
fetch_decennial_pops_by_race(...)
```

## Arguments

- ...:

  Arguments passed on to
  [`build_api_url`](https://higherx4racine.github.io/hercacstables/reference/build_api_url.md)

  `for_items`

  :   \<chr\[\]\> one or more instances of `for_geo` desired, e.g. `"*"`
      or `"000200"`, passed on to
      [`build_for_geographies()`](https://higherx4racine.github.io/hercacstables/reference/build_for_geographies.md)

  `use_key`

  :   \<lgl?\> optional, should the query include a Census API key from
      the system environment. Defaults to `TRUE`

  `for_geo`

  :   \<chr\> the geographical level the data will describe, e.g.
      `"tract"`

## Value

a [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with at
least four columns:

- Vintage:

  The decennial year, currently 2000, 2010, or 2020

- Race/Ethnicity:

  OMB text descriptions of Race/Ethnicities

- ...:

  additional columns that identify a geographic unit

- Population:

  The number of people in that block in that year of that race/ethnicity
