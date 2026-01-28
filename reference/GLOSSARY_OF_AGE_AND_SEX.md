# The fundamental demographics of age and sex from tables `B01001[ A-H]`

The age splits are more detailed in the whole-population table than they
are in the tables that pertain to specific racial identities.

## Usage

``` r
GLOSSARY_OF_AGE_AND_SEX
```

## Format

### GLOSSARY_OF_AGE_AND_SEX

A data frame with 80 rows and 5 columns.

- Suffix:

  `<lgl>` TRUE for race-specific tables and FALSE for the all-races
  table.

- Index:

  `<int>` The row in the source table that this GLOSSARY row describes.

- Sex:

  `<chr>` One of "All," "Male," or "Female"

- Lower Age:

  `<int>` the least age in the range, inclusive

- Upper Age:

  `<int>` the greatest age in the range, inclusive

## Source

https://api.census.gov/data/2022/acs/acs1/groups/B01001.html
