# Hoist details about a Census data group from a list of strings to separate columns

Hoist details about a Census data group from a list of strings to
separate columns

## Usage

``` r
hoist_table_glossary(.glossary, .group, .fields)
```

## Arguments

- .glossary:

  \<data-frame\> a table of glossary about Census API variables, e.g.
  [METADATA_FOR_ACS_VARIABLES](https://higherx4racine.github.io/hercacstables/reference/METADATA_FOR_ACS_VARIABLES.md)

- .group:

  \<chr\> the code for the group, e.g. "B01001"

- .fields:

  \<chr\[\]\> names for the new columns, e.g. c("Sex", "Age")

## Value

a new data frame with more columns

## Examples

``` r
hoist_table_glossary(METADATA_FOR_ACS_VARIABLES, "B06002", c("Median age", "Place of birth"))
#> # A tibble: 10 × 6
#>    Dataset Group  Index Variable    `Median age` `Place of birth`               
#>    <chr>   <chr>  <int> <chr>       <chr>        <chr>                          
#>  1 ACS1    B06002     1 B06002_001E Median age   ""                             
#>  2 ACS1    B06002     2 B06002_002E Median age   "Born in state of residence"   
#>  3 ACS1    B06002     3 B06002_003E Median age   "Born in other state of the Un…
#>  4 ACS1    B06002     4 B06002_004E Median age   "Native; born outside the Unit…
#>  5 ACS1    B06002     5 B06002_005E Median age   "Foreign born"                 
#>  6 ACS5    B06002     1 B06002_001E Median age   ""                             
#>  7 ACS5    B06002     2 B06002_002E Median age   "Born in state of residence"   
#>  8 ACS5    B06002     3 B06002_003E Median age   "Born in other state of the Un…
#>  9 ACS5    B06002     4 B06002_004E Median age   "Native; born outside the Unit…
#> 10 ACS5    B06002     5 B06002_005E Median age   "Foreign born"                 
```
