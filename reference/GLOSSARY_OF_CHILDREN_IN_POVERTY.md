# Categorize ACS variables about children living in poverty and parents' birth origins

These data come from table B05010, "RATIO OF INCOME TO POVERTY LEVEL IN
THE PAST 12 MONTHS BY NATIVITY OF CHILDREN UNDER 18 YEARS IN FAMILIES
AND SUBFAMILIES BY LIVING ARRANGEMENTS AND NATIVITY OF PARENTS."

## Usage

``` r
GLOSSARY_OF_CHILDREN_IN_POVERTY
```

## Format

### GLOSSARY_OF_CHILDREN_IN_POVERTY

A data frame with 15 rows and 8 columns

- Group:

  `<chr>` The table, always "B05010"

- Variable:

  `<chr>` The full variable name, e.g. "B05010_001E"

- Index:

  `<int>` The row of this variable in the table

- Least Poverty Ratio:

  `<dbl>` The lowest ratio of income to poverty level in this tier

- Greatest Poverty Ratio:

  `<dbl>` The highest ratio of income to poverty level in this tier

- Standard of Living:

  `<chr>` One of "Unsustainable," or "Mixed"

- Native-born Parents:

  `<int>` How many of the parents in the household were born in the USA.

- Foreign-born Parents:

  `<int>` How many of the parents in the household were not born in the
  USA.

## Source

https://api.census.gov/data/2022/acs/acs1/groups/B05010.html
