# ACS data on age and full- or part-time employment

ACS data on age and full- or part-time employment

## Usage

``` r
GLOSSARY_OF_WORK_STATUS
```

## Format

### GLOSSARY_OF_WORK_STATUS

an object of class `tbl_df/tbl/data.frame` with 36 rows and 7 columns

- Index:

  `<int>` the row in the census table

- Variable:

  `<chr>` the full variable name

- Lower Age:

  `<int>` the youngest age that this row counts

- Upper Age:

  `<int>` the oldest age that this row counts

- Employed:

  `<lgl>` `TRUE` if employed, `NA` if either status

- Full Time:

  ``` <lgl>``TRUE ``` if full-time, `NA` if either status

- Employment:

  `<chr>` a three-level factor with levels "Unemployed", "Part-Time",
  and "Full-Time"

## Source

https://api.census.gov/2024/acs/acs5/groups/B23027.html
