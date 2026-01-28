# Guide a new user at setting up a Census API key

This only works in interactive mode. It checks if a key already exists
in the environment. The key corresponds to
`Sys.getenv("CENSUS_API_KEY")` in order to be compatible with the
[tidycensus](https://walker-data.com/tidycensus/reference/census_api_key.html)
package. If the key doesn't exist then it prompts you to either go to
the Census website (it will open a browser window for you) or to enter
in your API key (by typing or pasting). It then sets the value in your
current environment and saves it to the .Renviron file in the user's
HOME directory.

## Usage

``` r
api_key_setup()
```

## Value

a numeric status: 0 for success, 1 for quitting, 2 if the key exists.

## See also

`tidycensus::census_api_key()`

## Examples

``` r
api_key_setup()
#> [1] 0
```
