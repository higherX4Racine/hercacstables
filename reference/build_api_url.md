# Create an API call to send to api.census.gov

Create an API call to send to api.census.gov

## Usage

``` r
build_api_url(
  variables,
  for_geo,
  for_items,
  survey_type,
  table_or_survey_code,
  year,
  ...,
  use_key = TRUE
)
```

## Arguments

- variables:

  \<chr\[\]\> a vector of variable names, like `"B01001_001E"`

- for_geo:

  \<chr\> the geographical level the data will describe, e.g. `"tract"`

- for_items:

  \<chr\[\]\> one or more instances of `for_geo` desired, e.g. `"*"` or
  `"000200"`, passed on to
  [`build_for_geographies()`](https://higherx4racine.github.io/hercacstables/reference/build_for_geographies.md)

- survey_type:

  e.g. "acs" or "dec"

- table_or_survey_code:

  e.g. "acs5" or "pl"

- year:

  an integer year, e.g. `2021L`

- ...:

  \<[`dynamic dots`](https://rlang.r-lib.org/reference/dyn-dots.html)\>
  other items to pass to the query

- use_key:

  \<lgl?\> optional, should the query include a Census API key from the
  system environment. Defaults to `TRUE`

## Value

one URL, as a string

## Examples

``` r
hercacstables:::build_api_url(paste0("B25003_00", 1:3, "E"),
                              "tract",
                              "*",
                              "acs",
                              "acs5",
                              2020L,
                              state = 55L,
                              county = 101L,
                              use_key = FALSE)
#> [1] "https://api.census.gov/data/2020/acs/acs5?get=B25003_001E%2CB25003_002E%2CB25003_003E&for=tract%3A%2A&in=state%3A55%20county%3A101"

hercacstables:::build_api_url(paste0("P1_00", c(1, 3, 4), "N"),
                              "tract",
                              "*",
                              "dec",
                              "pl",
                              2020L,
                              state = 55L,
                              county = 101L,
                              use_key = FALSE)
#> [1] "https://api.census.gov/data/2020/dec/pl?get=P1_001N%2CP1_003N%2CP1_004N&for=tract%3A%2A&in=state%3A55%20county%3A101"
```
