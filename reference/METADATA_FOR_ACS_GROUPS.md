# Details about the groups in the most recent American Community Series

In the context of ACS data, a "group" is what you would get from running
a query about a specific topic. For example, group B01001B reports
population numbers by sex and age, and group B25063 reports the number
of housing units in different rent brackets.

## Usage

``` r
METADATA_FOR_ACS_GROUPS
```

## Format

A list with three items

- Group:

  The code for the group, such as "B01001B" or "B25063"

- Universe:

  The population the data describe, such as "People who are Black or
  African American alone" or "Renter-occupied housing units"

- Description:

  Details about what the table actually reports, such as "Sex by Age
  (Black or African American Alone)" and "Gross Rent."

- ACS1:

  Whether this group is available in the most recent 1-year dataset.

- ACS5:

  Whether this group is available in the most recent 5-year dataset.

## Source

https://www.census.gov/programs-surveys/acs/technical-documentation/table-shells.html
