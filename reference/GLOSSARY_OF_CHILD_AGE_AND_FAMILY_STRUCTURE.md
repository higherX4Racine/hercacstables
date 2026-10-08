# Census variables for how many children of different ages live in families

This table only lists "own children," so presumably that excludes foster
care and multi-generational homes with older householders.

## Usage

``` r
GLOSSARY_OF_CHILD_AGE_AND_FAMILY_STRUCTURE
```

## Format

An object of class `tbl_df/tbl/data.frame` with 20 rows and 7 columns

- Group:

  `<chr>` Always "B09002"

- Index:

  `<int>`The row number in the table

- Variable:

  `<chr>` The full census variable

- Married:

  `<lgl>` Whether the family is single-parent or married

- `Sex of Householder`:

  `<chr>` Female, Male, or NA

- `Lower Age`:

  `<int>` inclusive from 0 to 17

- `Upper Age`:

  `<int>` exclusive from 0 to 17
