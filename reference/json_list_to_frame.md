# Convert a list of json objects from the census into a data frame

Convert a list of json objects from the census into a data frame

## Usage

``` r
json_list_to_frame(.json_list)
```

## Arguments

- .json_list:

  the list of objects

## Value

a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with column names taken from the list
