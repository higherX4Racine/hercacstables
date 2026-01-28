# Create the query part of a call to the Census's data API

Create the query part of a call to the Census's data API

## Usage

``` r
build_query_parameters(
  variables,
  for_geo,
  for_items = NULL,
  in_geos = NULL,
  use_key = FALSE
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

- in_geos:

  \<lst\> a list of key-value pairs to pass to
  [`build_in_geographies()`](https://higherx4racine.github.io/hercacstables/reference/build_in_geographies.md)

- use_key:

  \<lgl?\> optional, should the query include a Census API key from the
  system environment. Defaults to `TRUE`

## Value

a list of key-value pairs that can be converted into a URL query.
