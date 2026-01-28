# A code for the broad subject that a Census table covers.

The second 2 characters identify the subject of the table. These only
apply to B, C, K20, S, R, and GCT Tables. Profiles DP, NP, CP, and S0201
cover multiple topics, so they do not have any characters to indicate a
subject.

## Usage

``` r
TYPES_OF_SUBJECT
```

## Format

### TYPES_OF_SUBJECT

A data frame with 31 rows and 2 columns.

- Subject Number:

  `<chr>` The zero-padded numeric code for this subject

- Subject Name:

  `<chr>` A very short description of the subject.

## Source

https://www.census.gov/programs-surveys/acs/data/data-tables/table-ids-explained.html
