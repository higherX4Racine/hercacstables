# Details about variables in the most recent American Community Series

In the context of ACS data, a "variable" is a single row of data from
running a query about a specific topic. For example, group B010001
reports population numbers by sex and age, and group B25063 reports the
number of housing units in different rent brackets. Technically, there
are 4 variables for each row: the estimate, its margin of error, and
annotations for each of those. In practice, we usually just want the
estimate..

## Usage

``` r
METADATA_FOR_ACS_VARIABLES
```

## Format

A list with three items

- Dataset:

  Whether this variable pertains to the 1-year or 5-year dataset.

- Group:

  The code for the group, such as "B01001B" or "B25063"

- Index:

  The row number in the group for this variable, like 2 or 5.

- Variable:

  The full code for this variable, like "B01001B_002E" or "B25063_005E"

- Details:

  A vector of one or more strings describing what the variable actually
  represents.

## Source

https://www.census.gov/programs-surveys/acs/technical-documentation/table-shells.html
