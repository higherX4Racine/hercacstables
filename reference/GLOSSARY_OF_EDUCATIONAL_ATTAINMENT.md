# Census variables for different levels of educational achievement

The census breaks down educational attainment to different levels of
detail in different tables. For example, there are 8 levels in
[`B15001`](https://api.census.gov/data/2021/acs/acs5/groups/B15001.html),
but only 5 in the
[`C15002*`](https://api.census.gov/data/2021/acs/acs5/groups/C15002H.html)
tables or
[`B17003`](https://api.census.gov/data/2021/acs/acs5/groups/B17003.html).
Each row in this table connects a detailed level with a broader one.

## Usage

``` r
GLOSSARY_OF_EDUCATIONAL_ATTAINMENT
```

## Format

A list of three data frames

**sex_age** : A data frame with eight variables

- group : chr

- index : int

- variable : chr

- Sex : chr

- Lower Age : int

- Upper Age : int

- Age : chr

- Education : Factor

**race_ethnicity** : A data frame with ten variables

- group : chr

- index : int

- Sex : chr

- Lower Age : int

- Upper Age : int

- Age : chr

- Education : Factor

- Suffix : chr

- Census Race/Ethnicity : chr

- variable : chr

**poverty** : A data frame with six variables

- group : chr

- index : int

- variable : chr

- Sex : chr

- Education : Factor

- Poverty : chr

- Lower Age : int

- Upper Age : int

- Age : chr

## Source

https://api.census.gov/data
