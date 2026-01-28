# Census labels for different levels of educational achievement

The census breaks down educational attainment to different levels of
detail in different tables. For example, there are 8 levels in
[`B15001`](https://api.census.gov/data/2021/acs/acs5/groups/B15001.html),
but only 5 in the
[`C15002*`](https://api.census.gov/data/2021/acs/acs5/groups/C15002H.html)
tables. Each row in this table connects a detailed level with a broader
one.

## Usage

``` r
EDUCATIONAL_ATTAINMENT_LEVELS
```

## Format

A tibble with two columns

- Detailed:

  a factor with 8 levels

- Broad:

  a factor with 5 levels

## Source

https://api.census.gov/data
