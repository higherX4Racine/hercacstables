# Categorize ACS variables counting families by number of children

These data come from table B11003, "FAMILY TYPE BY PRESENCE AND AGE OF
OWN CHILDREN UNDER 18 YEARS"

## Usage

``` r
GLOSSARY_OF_FAMILIES_WITH_CHILDREN
```

## Format

### GLOSSARY_OF_FAMILIES_WITH_CHILDREN

A data frame with 12 rows and 6 columns

- Group:

  `<chr>` The table, always "B11003"

- Variable:

  `<chr>` The full variable name, e.g. "B11003_001E"

- Index:

  `<int>` The row of this variable in the table

- Adults:

  `<chr>` The adult(s) heading the household

- Children under 6:

  `<lgl>` Are there any children under 6 in this family?

- Childr 6-17:

  `<lgl>` Are there any children 6-17 in this family?

## Source

https://api.census.gov/data/2022/acs/acs1/groups/B11003.html
