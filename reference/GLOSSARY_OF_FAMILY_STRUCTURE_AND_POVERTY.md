# Poverty status related to number and type of parents/guardians and children

These data come from tables `B17010*`, which have the same structure for
all racial identities and data sources. The value is number of
**Families**.

## Usage

``` r
GLOSSARY_OF_FAMILY_STRUCTURE_AND_POVERTY
```

## Format

### GLOSSARY_OF_FAMILY_STRUCTURE_AND_POVERTY

A data frame with 41 rows and 7 columns

- Index:

  `<int>` the row number

- `Below Poverty Level`:

  `<lgl>` TRUE if the families' incomes are below the federal poverty
  level

- Married:

  `<lgl>` The Census keeps track about this I guess?

- Male:

  `<lgl>` A male parent is present

- Female:

  `<lgl>` A female parent is present

- `Under 5`:

  `<lgl>` At least one child under 5 is present

- `Over 4 Under 18`:

  `<lgl>` At least on child aged 5-17 is present

## Source

https://api.census.gov/data/2024/acs/acs5/groups/B17010.html
