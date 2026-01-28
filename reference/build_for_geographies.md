# Use the `for` geography to specify the level that you are querying data for.

Use the `for` geography to specify the level that you are querying data
for.

## Usage

``` r
build_for_geographies(for_geo, ...)
```

## Arguments

- for_geo:

  \<chr\> the geographical level the data will describe, e.g. `"tract"`

- ...:

  \<[`dynamic-dots`](https://rlang.r-lib.org/reference/dyn-dots.html)\>
  The specific items to search for, which will be all items if you leave
  them empty.

## Value

a list with one element named `for` which is a "key:value" string

## Examples

``` r
hercacstables:::build_for_geographies("block")
#> $`for`
#> [1] "block:*"
#> 
hercacstables:::build_for_geographies("tract", "000400", "000500")
#> $`for`
#> [1] "tract:000400,000500"
#> 
```
