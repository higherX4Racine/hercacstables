# Crossed counts of educational attainment and employment status

This table, `B23006`, uses the five-level attainment classification in
the "Broad" column of
[`EDUCATIONAL_ATTAINMENT_LEVELS`](https://higherx4racine.github.io/hercacstables/reference/EDUCATIONAL_ATTAINMENT_LEVELS.md).
Its employment status information does not distinguish between full- and
part-time employment.

## Usage

``` r
GLOSSARY_OF_EDUCATION_AND_EMPLOYMENT
```

## Format

### GLOSSARY_OF_EDUCATION_AND_EMPLOYMENT

A data frame with 29 rows and 7 columns

- Group:

  `<chr>` Always "B23006"

- Index:

  `<int>`The row number in the table

- Variable:

  `<chr>` The variable name for the population estimate

- Education:

  `<chr>`one of five broad levels of educational attainment

- `Labor Force`:

  `<lgl>` `NA` means "All"

- Civilian:

  `<lgl>` `NA` means "All"

- Employed:

  `<lgl>` `NA` means "All"

## Source

https://api.census.gov/data/2024/acs/acs5/groups/B23006.html
