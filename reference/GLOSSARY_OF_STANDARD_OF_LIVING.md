# Categorize ACS variables about income : poverty level ratios by family sustainability

These data come from table B17026, "RATIO OF INCOME TO POVERTY LEVEL OF
FAMILIES IN THE PAST 12 MONTHS." A family-sustaining wage is widely
considered to be three times the federal poverty level.

## Usage

``` r
GLOSSARY_OF_STANDARD_OF_LIVING
```

## Format

### GLOSSARY_OF_STANDARD_OF_LIVING

A data frame with 13 rows and 6 columns

- Group:

  `<chr>` The table, always "B17026"

- Variable:

  `<chr>` The full variable name, e.g. "B17026_001E"

- Index:

  `<int>` The row of this variable in the table

- Least Poverty Ratio:

  `<dbl>` The lowest ratio of income to poverty level in this tier

- Greatest Poverty Ratio:

  `<dbl>` The highest ratio of income to poverty level in this tier

- Standard of Living:

  `<chr>` One of "Everyone," "Unsustainable," or "Self-sustaining"

## Source

https://api.census.gov/data/2022/acs/acs1/groups/B17026.html
