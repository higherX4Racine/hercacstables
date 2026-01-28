# Make a call to the Census API and convert the JSON response to an R list.

Make a call to the Census API and convert the JSON response to an R
list.

## Usage

``` r
fetch_json_as_list(
  variables,
  year,
  for_geo,
  for_items,
  survey_type,
  table_or_survey_code,
  ...,
  use_key = TRUE
)
```

## Arguments

- variables:

  \<chr\[\]\> a vector of variable names, like `"B01001_001E"`

- year:

  an integer year, e.g. `2021L`

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

- ...:

  \<[`dynamic dots`](https://rlang.r-lib.org/reference/dyn-dots.html)\>
  other items to pass to the query

- use_key:

  \<lgl?\> optional, should the query include a Census API key from the
  system environment. Defaults to `TRUE`

## Value

a list of items read from json

## See also

[`build_api_url()`](https://higherx4racine.github.io/hercacstables/reference/build_api_url.md)

[`jsonlite::read_json()`](https://jeroen.r-universe.dev/jsonlite/reference/read_json.html)
