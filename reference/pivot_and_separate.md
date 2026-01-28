# Take a wide-formatted response from the Census API and convert it to long

Take a wide-formatted response from the Census API and convert it to
long

## Usage

``` r
pivot_and_separate(.frame, ...)
```

## Arguments

- .frame:

  a data frame from the census with columns named like `B01001_001E`

- ...:

  \<[`dynamic-dots`](https://rlang.r-lib.org/reference/dyn-dots.html)\>
  named regular expressions for extracting fields from the column names

## Value

a pivoted data frames where the columns that matched the regular
expression are converted to rows that are described by the extracted
fields.

## See also

[`tidyr::pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html)

[`tidyr::separate_wider_regex()`](https://tidyr.tidyverse.org/reference/separate_wider_delim.html)
