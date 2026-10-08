# Create the part of a Census API query that describes containing geographies

Create the part of a Census API query that describes containing
geographies

## Usage

``` r
build_in_geographies(...)
```

## Arguments

- ...:

  \<[`dynamic-dots`](https://rlang.r-lib.org/reference/dyn-dots.html)\>
  key-value pairs like "state='03'"

## Value

A vector of "geo:code" pairs

## Examples

``` r
hercacstables:::build_in_geographies(state=55, county = 101, barf=NULL)
#> [1] "state:55"   "county:101"
```
