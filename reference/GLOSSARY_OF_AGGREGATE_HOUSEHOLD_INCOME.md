# Aggregate income values for households, broken down by race, age, and source

These data come from 20 different tables. All of the tables, except for
B19050, which reports income by age of householder, have a single row,
the total income across all households in the geography. Tables
B19025.\* contain values by race, and tables B19060-70 contain values by
the nature of the income.

## Usage

``` r
GLOSSARY_OF_AGGREGATE_HOUSEHOLD_INCOME
```

## Format

### GLOSSARY_OF_AGGREGATE_HOUSEHOLD_INCOME

An object of class `spec_tbl_df/tbl_df/tbl/data.frame` with 24 rows and
6 columns

- Group:

  `<chr>` the identification code of the item's table

- Index:

  `<int>` the item's row in its table

- Race/Ethnicity:

  `<chr>` the racial/ethnic identity of people described by the item

- Source:

  `<chr>` the type of income, e.g. earnings, interest, or SNAP

- Public:

  `<lgl>` TRUE if the income is from a government assistance program.

- Lower Age:

  `<int>` the lowest age of householders described by the item

- Upper Age:

  `<int>`the highest age of householders described by the item

- Subtotal:

  `<chr>` whether the row involves all, race/ethnicity, age, or source
  subtotals

- Atomic:

  `<lgl>` TRUE if the item is an atomic observation, not a subtotal

## Source

https://api.census.gov/data/2024/acs/acs5/groups.html
