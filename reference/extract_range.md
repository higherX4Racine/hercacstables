# Extract two numbers from a range in census variables

Extract two numbers from a range in census variables

## Usage

``` r
extract_range(.range_text, .label, .defaults = c(0L, 999L))
```

## Arguments

- .range_text:

  `<chr>` a column of text with at least one number

- .label:

  `<chr>` part of the name of each output column

- .defaults:

  `<int[2]?>` the replacements for non-matches. Defaults to 0 and 999

## Value

a tibble with two integer columns, `Upper {.label}` and `Lower {.label}`
