# Pull apart the lists of details for one group of ACS data

Pull apart the lists of details for one group of ACS data

## Usage

``` r
unpack_group_details(.group)
```

## Arguments

- .group:

  the code of the group, like "B25043" or "C15010B"

## Value

a tibble with at least 4 columns, like
[METADATA_FOR_ACS_VARIABLES](https://higherx4racine.github.io/hercacstables/reference/METADATA_FOR_ACS_VARIABLES.md),
but `Details` is split into multiple columns with uppercase letter
names.

## See also

[METADATA_FOR_ACS_VARIABLES](https://higherx4racine.github.io/hercacstables/reference/METADATA_FOR_ACS_VARIABLES.md)

## Examples

``` r
unpack_group_details("B01002B")
#> # A tibble: 6 × 6
#>   Dataset Group   Index Variable     A          B       
#>   <chr>   <chr>   <int> <chr>        <chr>      <chr>   
#> 1 ACS1    B01002B     1 B01002B_001E Median age ""      
#> 2 ACS1    B01002B     2 B01002B_002E Median age "Male"  
#> 3 ACS1    B01002B     3 B01002B_003E Median age "Female"
#> 4 ACS5    B01002B     1 B01002B_001E Median age ""      
#> 5 ACS5    B01002B     2 B01002B_002E Median age "Male"  
#> 6 ACS5    B01002B     3 B01002B_003E Median age "Female"
```
