# Reusability

## Introduction

A reusable approach incorporates setup and post-processing, which take
place before and after calling for data from the API. Let’s say that you
are interested in the fraction of women who have given birth in the
U.S., broken down by age.

## The non-reusable part

Use
[`search_in_columns()`](https://higherx4racine.github.io/hercacstables/reference/search_in_columns.md)
to find tables that are relevant to our question.

``` r
WB_TABLES <- hercacstables::search_in_columns(
    hercacstables::METADATA_FOR_ACS_GROUPS,
    Group = "\\d$", # the group must end in a digit, so only "all races" tables
    Universe = "wom[ae]n", # matches woman and women
    Description = c("birth", "year") # the census doesn't use "age" much
)
```

| Group  | Universe                                                   | Description                                                                                                                                | ACS1 | ACS5 |
|:-------|:-----------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------|:-----|:-----|
| B13002 | Women 15 to 50 years                                       | Women 15 to 50 Years Who Had a Birth in the Past 12 Months by Marital Status and Age                                                       | TRUE | TRUE |
| B13004 | Women 15 to 50 years in households                         | Women 15 to 50 Years Who Had a Birth in the Past 12 Months by Presence of Spouse or Unmarried Partner                                      | TRUE | TRUE |
| B13008 | Women 15 to 50 years                                       | Women 15 to 50 Years Who Had a Birth in the Past 12 Months by Marital Status and Nativity                                                  | TRUE | TRUE |
| B13010 | Women 15 to 50 years for whom poverty status is determined | Women 15 to 50 Years Who Had a Birth in the Past 12 Months by Marital Status and Poverty Status in the Past 12 Months                      | TRUE | TRUE |
| B13012 | Women 16 to 50 years                                       | Women 16 to 50 Years Who Had a Birth in the Past 12 Months by Marital Status and Labor Force Status                                        | TRUE | TRUE |
| B13014 | Women 15 to 50 years                                       | Women 15 to 50 Years Who Had a Birth in the Past 12 Months by Marital Status and Educational Attainment                                    | TRUE | TRUE |
| B13015 | Women 15 to 50 years                                       | Women 15 to 50 Years Who Had a Birth in the Past 12 Months by Marital Status and Receipt of Public Assistance Income in the Past 12 Months | TRUE | TRUE |
| B13016 | Women 15 to 50 years                                       | Women 15 to 50 Years Who Had a Birth in the Past 12 Months by Age                                                                          | TRUE | TRUE |

It looks like table
[B13016](https://api.census.gov/data/2023/acs/acs5/groups/B13016.html)
is exactly what we are looking for.

## Setup

### Define a glossary of variable meanings

First, create a glossary table that maps from the Census variables you
need to the real-world meanings that you actually care about.

The following example glosses 12 variables from “B13016.” Each specific
variable encodes four columns’ worth of data.

``` r
GLOSSARY_OF_WOMEN_AND_BIRTHS <- "B13016" |>
    hercacstables::unpack_group_details() |>
    dplyr::filter(
        .data$Dataset == "ACS1", # there are details for 1- and 5-year datasets
        dplyr::if_all(c("A", "B"), \(.)nchar(.) > 0) #
    ) |>
    dplyr::mutate(
        `Gave Birth` = stringr::str_detect(.data$A, "had"),
        `Lower Age` = stringr::str_extract(.data$B, "^\\d{2}"),
        `Upper Age` = stringr::str_extract(.data$B, "(?<!^)\\d{2}"),
        dplyr::across(tidyselect::ends_with("Age"),
                      as.integer)
    ) |>
    dplyr::select(
        !tidyselect::any_of(c("A", "B"))
    )
```

| Dataset | Group  | Index | Variable    | Gave Birth | Lower Age | Upper Age |
|:--------|:-------|------:|:------------|:-----------|----------:|----------:|
| ACS1    | B13016 |     3 | B13016_003E | TRUE       |        15 |        19 |
| ACS1    | B13016 |     4 | B13016_004E | TRUE       |        20 |        24 |
| ACS1    | B13016 |     5 | B13016_005E | TRUE       |        25 |        29 |
| ACS1    | B13016 |     6 | B13016_006E | TRUE       |        30 |        34 |
| ACS1    | B13016 |     7 | B13016_007E | TRUE       |        35 |        39 |
| ACS1    | B13016 |     8 | B13016_008E | TRUE       |        40 |        44 |
| ACS1    | B13016 |     9 | B13016_009E | TRUE       |        45 |        50 |
| ACS1    | B13016 |    11 | B13016_011E | FALSE      |        15 |        19 |
| ACS1    | B13016 |    12 | B13016_012E | FALSE      |        20 |        24 |
| ACS1    | B13016 |    13 | B13016_013E | FALSE      |        25 |        29 |
| ACS1    | B13016 |    14 | B13016_014E | FALSE      |        30 |        34 |
| ACS1    | B13016 |    15 | B13016_015E | FALSE      |        35 |        39 |
| ACS1    | B13016 |    16 | B13016_016E | FALSE      |        40 |        44 |
| ACS1    | B13016 |    17 | B13016_017E | FALSE      |        45 |        50 |

## Calling the API

### Define a fetching function

Having defined a reusable glossary, we can now define a reusable
fetching function.

``` r
fetch_women_and_births <- function(...) {
    hercacstables::fetch_data(
        variables = GLOSSARY_OF_WOMEN_AND_BIRTHS$Variable,
        survey_type = "acs",
        table_or_survey_code = "acs1",
        ...
    )
}
```

### Send the request to the API

Run the
[`fetch_data()`](https://higherx4racine.github.io/hercacstables/reference/fetch_data.md)
command by itself so that you can cache it. In this example, we will ask
for the most recent data for the whole country.

``` r
RAW_WOMEN_AND_BIRTHS <- fetch_women_and_births(
    year = hercacstables::most_recent_vintage("acs", "acs1"),
    for_geo = "us",
    for_items = "*"
)
```

|  us | Group  | Index | Measure |      Value | Year |
|----:|:-------|------:|--------:|-----------:|-----:|
|   1 | B13016 |     3 |       E |     79,108 | 2024 |
|   1 | B13016 |     4 |       E |    505,779 | 2024 |
|   1 | B13016 |     5 |       E |    964,839 | 2024 |
|   1 | B13016 |     6 |       E |  1,191,877 | 2024 |
|   1 | B13016 |     7 |       E |    789,918 | 2024 |
|   1 | B13016 |     8 |       E |    297,919 | 2024 |
|   1 | B13016 |     9 |       E |    141,994 | 2024 |
|   1 | B13016 |    11 |       E | 10,866,828 | 2024 |
|   1 | B13016 |    12 |       E | 10,340,472 | 2024 |
|   1 | B13016 |    13 |       E | 10,048,891 | 2024 |
|   1 | B13016 |    14 |       E | 10,632,617 | 2024 |
|   1 | B13016 |    15 |       E | 10,729,593 | 2024 |
|   1 | B13016 |    16 |       E | 10,976,001 | 2024 |
|   1 | B13016 |    17 |       E | 12,056,689 | 2024 |

## Postprocessing

### Wrangle the result into a helpful format

The raw data do not answer our question all by themselves. We are
interested in rates, not counts. Using the
[`dplyr::summarize()`](https://dplyr.tidyverse.org/reference/summarise.html)
function will let us get rid of the superfluous information about
marital status.

``` r
wrangle_women_and_births <- function(.raw_api_output, ...) {
    .raw_api_output |>
        dplyr::inner_join(
            GLOSSARY_OF_WOMEN_AND_BIRTHS,
            by = c("Group", "Index")
        ) |>
        dplyr::summarize(
            `Recent Mothers` = sum(.data$Value * .data$`Gave Birth`),
            `All Women` = sum(.data$Value),
            Rate = .data$`Recent Mothers` / .data$`All Women`,
            .by = tidyselect::all_of(c(..., "Lower Age", "Upper Age"))
        )
}

WOMEN_AND_BIRTHS <- wrangle_women_and_births(RAW_WOMEN_AND_BIRTHS)
```

| Lower Age | Upper Age | Recent Mothers |  All Women | Rate |
|----------:|----------:|---------------:|-----------:|-----:|
|        15 |        19 |         79,108 | 10,945,936 |   1% |
|        20 |        24 |        505,779 | 10,846,251 |   5% |
|        25 |        29 |        964,839 | 11,013,730 |   9% |
|        30 |        34 |      1,191,877 | 11,824,494 |  10% |
|        35 |        39 |        789,918 | 11,519,511 |   7% |
|        40 |        44 |        297,919 | 11,273,920 |   3% |
|        45 |        50 |        141,994 | 12,198,683 |   1% |

## Reusability

The benefit of this approach is that we can reuse the fetching and
wrangling functions.

### Across Places

In this example, we pull data for three different counties in Wisconsin.

``` r
SE_WI_WOMEN_AND_BIRTHS <- fetch_women_and_births(
    state = 55,
    for_geo = "county",
    for_items = c("059", "079", "101"), # Kenosha, Racine, and Milwaukee
    year = 2023
) |>
    wrangle_women_and_births(
        "county"
    ) |>
    dplyr::mutate(
        county = dplyr::case_match(.data$county,
                                  "059" ~ "Kenosha",
                                  "079" ~ "Milwaukee",
                                  "101" ~ "Racine")
    )
```

For a simpler table, we’ll exclude the counts of mothers and women, then
pivot the rate data by county.

| Lower Age | Upper Age | Kenosha | Milwaukee | Racine |
|----------:|----------:|--------:|----------:|-------:|
|        15 |        19 |      0% |        1% |     0% |
|        20 |        24 |      1% |        4% |     2% |
|        25 |        29 |     16% |        6% |    18% |
|        30 |        34 |      5% |        9% |    17% |
|        35 |        39 |      2% |        8% |    10% |
|        40 |        44 |      3% |        1% |     1% |
|        45 |        50 |      0% |        1% |     0% |

### Through time

In this example, we pull data about Texas from three years. We have to
make three separate calls, one for each year. It’s an idiosyncrasy of
this particular API.

``` r
TEXAS_WOMEN_AND_BIRTHS <- 2021:2023 |>
    purrr::map(
        \(.y) fetch_women_and_births(
            for_geo = "state",
            for_items = 48L,
            year = .y
        )
    ) |>
    purrr::list_rbind() |>
    wrangle_women_and_births(
        "Year"
    )
```

For a simpler table, we’ll exclude the counts of mothers and women, then
pivot the rate data by year.

| Lower Age | Upper Age | 2021 | 2022 | 2023 |
|----------:|----------:|-----:|-----:|-----:|
|        15 |        19 |   2% |   1% |   1% |
|        20 |        24 |   8% |   7% |   7% |
|        25 |        29 |  11% |  11% |  10% |
|        30 |        34 |  11% |  11% |  10% |
|        35 |        39 |   7% |   6% |   7% |
|        40 |        44 |   2% |   3% |   2% |
|        45 |        50 |   1% |   1% |   1% |
