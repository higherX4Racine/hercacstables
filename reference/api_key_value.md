# Get the current value of the local Census API key

This corresponds to `Sys.getenv("CENSUS_API_KEY")` in order to be
compatible with the
[tidycensus](https://walker-data.com/tidycensus/reference/census_api_key.html)
package.

## Usage

``` r
api_key_value()
```

## Value

a hexadecimal API token, or an empty string

## See also

`tidycensus::census_api_key()`

## Examples

``` r
api_key_value()
#> [1] ""
```
