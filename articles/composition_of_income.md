# composition_of_income

``` r

library(hercacstables)
```

The American Community Survey has twenty different tables that report on
aggregate household income.

| Group | Universe | Description | ACS1 | ACS5 |
|:---|:---|:---|:---|:---|
| B19025 | Households | Aggregate Household Income in the Past 12 Months | TRUE | TRUE |
| B19025A | Households with a householder who is White alone | Aggregate Household Income in the Past 12 Months (White Alone Householder) | TRUE | TRUE |
| B19025B | Households with a householder who is Black or African American alone | Aggregate Household Income in the Past 12 Months (Black or African American Alone Householder) | TRUE | TRUE |
| B19025C | Households with a householder who is American Indian and Alaska Native alone | Aggregate Household Income in the Past 12 Months (American Indian and Alaska Native Alone Householder) | TRUE | TRUE |
| B19025D | Households with a householder who is Asian alone | Aggregate Household Income in the Past 12 Months (Asian Alone Householder) | TRUE | TRUE |
| B19025E | Households with a householder who is Native Hawaiian and Other Pacific Islander alone | Aggregate Household Income in the Past 12 Months (Native Hawaiian and Other Pacific Islander Alone Householder) | TRUE | TRUE |
| B19025F | Households with a householder who is Some Other Race alone | Aggregate Household Income in the Past 12 Months (Some Other Race Alone Householder) | TRUE | TRUE |
| B19025G | Households with a householder who is Two or More Races | Aggregate Household Income in the Past 12 Months (Two or More Races Householder) | TRUE | TRUE |
| B19025H | Households with a householder who is White alone, not Hispanic or Latino | Aggregate Household Income in the Past 12 Months (White Alone, Not Hispanic or Latino Householder) | TRUE | TRUE |
| B19025I | Households with a householder who is Hispanic or Latino | Aggregate Household Income in the Past 12 Months (Hispanic or Latino Householder) | TRUE | TRUE |
| B19050 | Households | Aggregate Household Income in the Past 12 Months by Age of Householder | TRUE | TRUE |
| B19061 | Households | Aggregate Earnings in the Past 12 Months for Households | TRUE | TRUE |
| B19062 | Households | Aggregate Wage or Salary Income in the Past 12 Months for Households | TRUE | TRUE |
| B19063 | Households | Aggregate Self-Employment Income in the Past 12 Months for Households | TRUE | TRUE |
| B19064 | Households | Aggregate Interest, Dividends, or Net Rental Income in the Past 12 Months for Households | TRUE | TRUE |
| B19065 | Households | Aggregate Social Security Income in the Past 12 Months for Households | TRUE | TRUE |
| B19066 | Households | Aggregate Supplemental Security Income (SSI) in the Past 12 Months for Households | TRUE | TRUE |
| B19067 | Households | Aggregate Public Assistance Income in the Past 12 Months for Households | TRUE | TRUE |
| B19069 | Households | Aggregate Retirement Income in the Past 12 Months for Households | TRUE | TRUE |
| B19070 | Households | Aggregate Other Types of Income in the Past 12 Months for Households | TRUE | TRUE |

Only one of these tables, B19050, has more than one row. It reports
aggregate incomes by age of householder, with four age ranges that break
at 25, 45, and 64. Its first rows is income over all ages, which is
redundant with the single row in table B19025. Taken together, this
gives us the 24 different variables that are described in
\[hercacstables::GLOSSARY_OF_AGGREGATE_HOUSEHOLD_INCOME\].

| Group | Index | Race/Ethnicity | Source | Public | Lower Age | Upper Age | Subtotal | Atomic |
|:---|---:|:---|:---|:---|---:|---:|:---|:---|
| B19025 | 1 | All | All | NA | 0 | 999 | All | FALSE |
| B19025A | 1 | White alone | All | NA | 0 | 999 | Race/Ethnicity | TRUE |
| B19025B | 1 | Black or African American alone | All | NA | 0 | 999 | Race/Ethnicity | TRUE |
| B19025C | 1 | American Indian and Alaska Native alone | All | NA | 0 | 999 | Race/Ethnicity | TRUE |
| B19025D | 1 | Asian alone | All | NA | 0 | 999 | Race/Ethnicity | TRUE |
| B19025E | 1 | Native Hawaiian and Other Pacific Islander alone | All | NA | 0 | 999 | Race/Ethnicity | TRUE |
| B19025F | 1 | Some Other Race alone | All | NA | 0 | 999 | Race/Ethnicity | TRUE |
| B19025G | 1 | Two or More Races | All | NA | 0 | 999 | Race/Ethnicity | TRUE |
| B19025H | 1 | White alone, not Hispanic or Latino | All | NA | 0 | 999 | Race/Ethnicity | FALSE |
| B19025I | 1 | Hispanic or Latino | All | NA | 0 | 999 | Race/Ethnicity | FALSE |
| B19050 | 2 | All | All | NA | 0 | 24 | Age | TRUE |
| B19050 | 3 | All | All | NA | 25 | 44 | Age | TRUE |
| B19050 | 4 | All | All | NA | 45 | 64 | Age | TRUE |
| B19050 | 5 | All | All | NA | 65 | 999 | Age | TRUE |
| B19061 | 1 | All | Earnings | FALSE | 0 | 999 | Source | FALSE |
| B19062 | 1 | All | Wage or Salary | FALSE | 0 | 999 | Source | TRUE |
| B19063 | 1 | All | Self-Employment | FALSE | 0 | 999 | Source | TRUE |
| B19064 | 1 | All | Interest, Dividends, or Net Rental | FALSE | 0 | 999 | Source | TRUE |
| B19065 | 1 | All | Social Security | TRUE | 0 | 999 | Source | TRUE |
| B19066 | 1 | All | Supplemental Security (SSI) | TRUE | 0 | 999 | Source | TRUE |
| B19067 | 1 | All | Public Assistance | TRUE | 0 | 999 | Source | TRUE |
| B19069 | 1 | All | Retirement | FALSE | 0 | 999 | Source | TRUE |
| B19070 | 1 | All | Other Types | NA | 0 | 999 | Source | TRUE |
