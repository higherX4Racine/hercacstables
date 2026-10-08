# Number of children by poverty status related type of parents/guardians.

These data come from table `B17006`.

## Usage

``` r
GLOSSARY_OF_POVERTY_FAMILY_AND_CHILDREN
```

## Format

### GLOSSARY_OF_POVERTY_FAMILY_AND_CHILDREN

A data frame with 29 rows and 9 columns

- Group:

  `<chr>` Always "B17006"

- Index:

  `<int>` The row number.

- Variable:

  `<chr>` computed from Group and Index.

- `Federal Poverty`:

  `<lgl>` TRUE if the family's income is below the Federal poverty
  level.

- Married:

  `<lgl>` TRUE if the Census thinks the family's householders are wedded
  to one another

- `Male Parent`:

  `<lgl>` TRUE if there is a male parent/guardian present in the
  household

- `Female Parent`:

  `<lgl>` TRUE if there is a female parent/guarian present in the
  household

- `Lower Age`:

  `<int>` The youngest age in the range counted by this row

- `Upper Age`:

  `<int>` The oldest age in the range counted by this row

## Source

https://api.census.gov/data/2024/acs/acs5/groups/B17006.html
