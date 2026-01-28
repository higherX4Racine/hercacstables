# Categorize ACS variables about children per family

These data come from table B17026, "OWN CHILDREN UNDER 18 YEARS BY
FAMILY TYPE AND AGE"

## Usage

``` r
GLOSSARY_OF_CHILDREN_PER_FAMILY
```

## Format

### GLOSSARY_OF_CHILDREN_PER_FAMILY

A data frame with 15 rows and 6 columns

- Group:

  `<chr>` The table, always "B09002"

- Variable:

  `<chr>` The full variable name, e.g. "B09002_001E"

- Index:

  `<int>` The row of this variable in the table

- Adults:

  `<chr>` The adult(s) heading the household

- Lower Age:

  `<int>` The age of the youngest children counted by this variable

- Upper Age:

  `<int>` The age of the oldest children counted by this variable

## Source

https://api.census.gov/data/2022/acs/acs1/groups/B09002.html
