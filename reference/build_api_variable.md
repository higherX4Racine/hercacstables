# Vectorized Creation of Census ACS Variables

All detail group variables have the format "B000OO\*\_000E", where the
"B" and "E" are literal and the "\*" is a race code.

## Usage

``` r
build_api_variable(
  group_code,
  item_number,
  race_code = "",
  separator = "_",
  suffix = "E"
)
```

## Arguments

- group_code:

  the group code, like "B18101"

- item_number:

  some integer between 0 and 999

- race_code:

  optional, either an empty string or one of \[A..I\]

- separator:

  optional, usually "\_" for ACS variables.

- suffix:

  optional, usually "E" for ACS variables, but sometimes "N" for
  decennial data.

## Value

a vector of strings, each of which is a variable name

## Examples

``` r
groups <- c("B19013", "B18101", "B18101")
races <- c("", "", "I")
numbers <- 1
build_api_variable(groups, numbers, races)
#> [1] "B19013_001E"  "B18101_001E"  "B18101I_001E"
```
