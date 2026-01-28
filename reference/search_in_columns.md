# Search for terms in a glossary in case-insensitive ways

Each of the dynamic arguments to this function must be a named array of
strings. The function will look for each string in the column of
`.dataframe` that corresponds to the argument's name. For example,
providing the argument `Universe = c("Wom[ae]n", "years?")` will search
the "Universe" column for any elements that include both "women" or
"woman" and "year" or "years". The search is NOT case-sensitive. You can
also exclude patterns by prefacing the column name with "-". For
example, the argument `"-Universe" = "household"` will exclude rows
where the "Universe" column contains the string "household".

## Usage

``` r
search_in_columns(.dataframe, ...)
```

## Arguments

- .dataframe:

  the table to search in

- ...:

  \<[rlang::dyn-dots](https://rlang.r-lib.org/reference/dyn-dots.html)\>
  Named arrays of search terms.

## Value

\<dfr\> a filtered version of `.dataframe`

## Examples

``` r
hercacstables::search_in_columns(
  hercacstables::METADATA_FOR_ACS_GEOGRAPHIES,
  `Wildcard Option` = "."
)
#> # A tibble: 14 × 5
#>    `Geographic Level`        Containing Geographi…¹ `Wildcard Option` ACS1      
#>    <chr>                     <chr>                  <chr>             <date>    
#>  1 county                    {state}                {state}           2023-01-01
#>  2 county subdivision        {state, county}        {county}          2023-01-01
#>  3 place                     {state}                {state}           2023-01-01
#>  4 alaska native regional c… {state}                {state}           2023-01-01
#>  5 congressional district    {state}                {state}           2023-01-01
#>  6 public use microdata area {state}                {state}           2023-01-01
#>  7 school district (element… {state}                {state}           2023-01-01
#>  8 school district (seconda… {state}                {state}           2023-01-01
#>  9 school district (unified) {state}                {state}           2023-01-01
#> 10 county                    {state}; {metropolita… {state}           NA        
#> 11 tract                     {state, county}        {county}          NA        
#> 12 block group               {state, county, tract} {tract}           NA        
#> 13 consolidated city         {state}                {state}           NA        
#> 14 tribal subdivision/remai… {american indian area… {american indian… NA        
#> # ℹ abbreviated name: ¹​`Containing Geographies`
#> # ℹ 1 more variable: ACS5 <date>
hercacstables::search_in_columns(
  hercacstables::METADATA_FOR_ACS_GEOGRAPHIES,
  `-Wildcard Option` = "."
)
#> # A tibble: 32 × 5
#>    `Geographic Level`        Containing Geographi…¹ `Wildcard Option` ACS1      
#>    <chr>                     <chr>                  <chr>             <date>    
#>  1 us                        ""                     ""                2023-01-01
#>  2 region                    ""                     ""                2023-01-01
#>  3 division                  ""                     ""                2023-01-01
#>  4 state                     ""                     ""                2023-01-01
#>  5 american indian area/ala… ""                     ""                2023-01-01
#>  6 metropolitan statistical… ""                     ""                2023-01-01
#>  7 principal city (or part)  "{metropolitan statis… ""                2023-01-01
#>  8 metropolitan division     "{metropolitan statis… ""                2023-01-01
#>  9 combined statistical area ""                     ""                2023-01-01
#> 10 urban area                ""                     ""                2023-01-01
#> # ℹ 22 more rows
#> # ℹ abbreviated name: ¹​`Containing Geographies`
#> # ℹ 1 more variable: ACS5 <date>
```
