
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hercacstables

<!-- badges: start -->
<!-- badges: end -->

If this is your first time using `hercacstables` then you probably want
to register with the Census. The Census limits the number of anonymous
API queries that it receives from any one IP address. Check out
`vignette("set-up-your-api-key", package = "hercacstables")`.

Otherwise, welcome back!

## For the newest R users:

You may be new to R, but not data science, in which case I suggest
checking out [R for Data Science](https://r4ds.hadley.nz/intro.html). If
you’re not coming from a data science perspective, I have heard good
things about [this book](https://datascienceineducation.com/).

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("higherX4Racine/hercacstables")
```

## Motivation

The American Community Survey (ACS) from the US Census’s website
provides a vast amount of useful data.

![](man/figures/README-group-descriptions-wordcloud.png)

However, it returns those data in a weirdly idiosyncratic way. Even
though the output seems tabular, the data are really organized in a
tree-like fashion. This package is intended to make it easy to access
and use the ACS data with R.

## Example

Let’s say that you are a data intern for a [wastewater
agency](https://cityofracine.org/WasteWater/Commission/) in the
southeastern part of Wisconsin. Your mentors have asked you to find
insights from the American Community Survey.

### Specifying your community

They tell you that the wastewater commission’s area of responsibility is
essentially identical to the local school district’s, [Racine
Unified](https://www.rusd.org).

You look for geographical levels related to schools in
`hercacstables::ACS_GEOGRAPHY_METADATA`.

``` r
SCHOOL_GEOGRAPHIES <- dplyr::filter(hercacstables::ACS_GEOGRAPHY_METADATA,
                                    grepl("school", .data$`Geographic Level`))
```

This table tells us two things. First, the geographic level that you
should examine is “school district (unified)”. Second, you also need to
specify the state when you’re fetching data about it. With
`hercacstables::fetch_data()`, and tools from the
[tidyverse](https://www.tidyverse.org "The tidyverse"), you can find the
FIPS codes for unified school districts in Wisconsin that have the word
“Racine” in them.

``` r
RACINE_DISTRICTS <- "NAME" |>
    hercacstables::fetch_data(
        variables = _,
        year = 2020,                           # the most recent decennial
        for_geo = "school district (unified)", # see above
        for_items = "*",                       # this wildcard gets every item
        survey_type = "dec",                   # not actually the ACS *flex*
        table_or_survey_code = "pl",           # this data set is similar to ACS
        state = 55L                            # the Badger State
    ) |>
    dplyr::filter(
        stringr::str_detect(.data$NAME, "Racine")
    )
```

| NAME                              | state | school district (unified) | Year |
|:----------------------------------|:------|:--------------------------|-----:|
| Racine School District, Wisconsin | 55    | 12360                     | 2020 |

### Finding relevant data

The first thing that you could do is to check for data related to
plumbing. If you were doing this without R, you might visit
[data.census.gov](https://data.census.gov) and search for “ACS
plumbing”.

#### Groups with relevant data

With `hercacstables`, you would search within its metadata about ACS
groups:

``` r
PLUMBING_GROUPS <- hercacstables::ACS_GROUP_METADATA |>
    dplyr::filter(
        grepl("plumbing",         # search for the term "plumbing"
              .data$Description,  # within the "Description" column
              ignore.case = TRUE) # ignore capitalization
    )
```

| Group | Universe | Description | ACS1 | ACS5 |
|:---|:---|:---|:---|:---|
| B25016 | Occupied housing units | Tenure by Plumbing Facilities by Occupants per Room | TRUE | TRUE |
| B25047 | Housing units | Plumbing Facilities for All Housing Units | TRUE | TRUE |
| B25048 | Occupied housing units | Plumbing Facilities for Occupied Housing Units | TRUE | TRUE |
| B25049 | Occupied housing units | Tenure by Plumbing Facilities | TRUE | TRUE |
| B25050 | Occupied housing units | Plumbing Facilities by Occupants per Room by Year Structure Built | TRUE | TRUE |
| B99259 | Housing units | Allocation of Plumbing Facilities | TRUE | TRUE |

It appears that the keyword “plumbing” appears in 6 different ACS
groups.

### Specific variables about plumbing

Let’s say that “Tenure[^1] by plumbing facilities” jumps out to you as
potentially interesting.

``` r
GROUP <- "B25049"
```

There `hercacstables` also provides metadata about variables. You can
search it to see details about each variable in group B25049.

``` r
PLUMBING_VARIABLES <- hercacstables::ACS_VARIABLE_METADATA |>
    dplyr::filter(
        .data$Dataset == "ACS5", # use the 1-year dataset only
        .data$Group == GROUP     # pull all of the variables for this group
    )
```

| Dataset | Group | Index | Variable | Details |
|:---|:---|---:|:---|:---|
| ACS5 | B25049 | 1 | B25049_001E |  |
| ACS5 | B25049 | 2 | B25049_002E | Owner occupied |
| ACS5 | B25049 | 3 | B25049_003E | Owner occupied , Complete plumbing facilities |
| ACS5 | B25049 | 4 | B25049_004E | Owner occupied , Lacking plumbing facilities |
| ACS5 | B25049 | 5 | B25049_005E | Renter occupied |
| ACS5 | B25049 | 6 | B25049_006E | Renter occupied , Complete plumbing facilities |
| ACS5 | B25049 | 7 | B25049_007E | Renter occupied , Lacking plumbing facilities |

### Unpacking variable details

You can see that group B25049 reports the number of households that
have, or do not have, plumbing facilities. It further breaks those
households down into renters and owner-occupants. The raw metadata from
the Census, and in `hercacstables::ACS_VARIABLE_METADATA`, packs all of
that information into the “Details” column.

It would be more useful if we actually had separate columns for the
types of tenure and plumbing facilities. You can use
`hercacstables::unpack_group_details()` to do this, in combination with
tools from the [tidyverse](https://www.tidyverse.org "The tidyverse").

You might also decide that you don’t the rows that report the total
number of households (row 1) and subtotals by tenure (2 and 5). You’ll
have that data anyway from 3, 4, 6, and 7.

``` r
PLUMBING_VARIABLES <- GROUP |>
    hercacstables::unpack_group_details() |>
    dplyr::filter(
        .data$Dataset == "ACS5"
    ) |>
    dplyr::rename(
        Tenure = "A",
        Plumbing = "B"
    ) |>
    dplyr::filter(
        dplyr::if_all(c("Tenure", "Plumbing"),
                      \(.) (nchar(.) > 0))
    )
```

| Dataset | Group  | Index | Variable    | Tenure          | Plumbing                     |
|:--------|:-------|------:|:------------|:----------------|:-----------------------------|
| ACS5    | B25049 |     3 | B25049_003E | Owner occupied  | Complete plumbing facilities |
| ACS5    | B25049 |     4 | B25049_004E | Owner occupied  | Lacking plumbing facilities  |
| ACS5    | B25049 |     6 | B25049_006E | Renter occupied | Complete plumbing facilities |
| ACS5    | B25049 |     7 | B25049_007E | Renter occupied | Lacking plumbing facilities  |

### Fetch data

You are finally ready to pull a some census data about plumbing! For
starters, you could compare the local area to the whole county, the
state, its census region, and the whole country. Once again, we’ll use
`hercacstables::fetch_data()` and the
[tidyverse](https://www.tidyverse.org "The tidyverse").

``` r
YEAR <- hercacstables::most_recent_vintage("acs", "acs5")

RAW_PLUMBING <- tibble::tribble(
    ~ geo,                       ~ items, ~ other,
    "us",                        "1",     list(),
    "region",                    "2",     list(),
    "state",                     "55",    list(),
    "county",                    "101",   list(state = 55),
    "school district (unified)", "12360", list(state = 55)
) |>
    purrr::pmap(
        \(geo, items, other) rlang::exec(
            hercacstables::fetch_data,
            variables = c("NAME", PLUMBING_VARIABLES$Variable),
            year = YEAR,
            for_geo = geo,
            for_items = items,
            survey_type = "acs",
            table_or_survey_code = "acs5",
            !!!other
        )
    )
```

| NAME          | us  | Group  | Index |    Value | Year |
|:--------------|:----|:-------|------:|---------:|-----:|
| United States | 1   | B25049 |     3 | 82628718 | 2023 |

| NAME           | region | Group  | Index |    Value | Year |
|:---------------|:-------|:-------|------:|---------:|-----:|
| Midwest Region | 2      | B25049 |     3 | 19041735 | 2023 |

| NAME      | state | Group  | Index |   Value | Year |
|:----------|:------|:-------|------:|--------:|-----:|
| Wisconsin | 55    | B25049 |     3 | 1655255 | 2023 |

| NAME                     | state | county | Group  | Index | Value | Year |
|:-------------------------|:------|:-------|:-------|------:|------:|-----:|
| Racine County, Wisconsin | 55    | 101    | B25049 |     3 | 56159 | 2023 |

| NAME | state | school district (unified) | Group | Index | Value | Year |
|:---|:---|:---|:---|---:|---:|---:|
| Racine School District, Wisconsin | 55 | 12360 | B25049 | 3 | 38779 | 2023 |

The data in `RAW_PLUMBING` do not have much meaning without the
information in `PLUMBING_VARIABLES`. Fortunately, we can use the
[tidyverse](https://www.tidyverse.org "The tidyverse") to join the two
tables together.

``` r
PLUMBING <- RAW_PLUMBING |>
    purrr::map(
        \(.) dplyr::select(.,
                           "Group",
                           "Index",
                           Geography = "NAME",
                           Households = "Value"
        )
    ) |>
    purrr::list_rbind() |>
    dplyr::right_join(
        PLUMBING_VARIABLES,
        by = c("Group", "Index")
    ) |>
    dplyr::select(
        "Geography",
        "Tenure",
        "Plumbing",
        "Households"
    )
```

``` r
knitr::kable(PLUMBING)
```

| Geography | Tenure | Plumbing | Households |
|:---|:---|:---|---:|
| United States | Owner occupied | Complete plumbing facilities | 82628718 |
| United States | Owner occupied | Lacking plumbing facilities | 263319 |
| United States | Renter occupied | Complete plumbing facilities | 44349427 |
| United States | Renter occupied | Lacking plumbing facilities | 241401 |
| Midwest Region | Owner occupied | Complete plumbing facilities | 19041735 |
| Midwest Region | Owner occupied | Lacking plumbing facilities | 55380 |
| Midwest Region | Renter occupied | Complete plumbing facilities | 8561887 |
| Midwest Region | Renter occupied | Lacking plumbing facilities | 43001 |
| Wisconsin | Owner occupied | Complete plumbing facilities | 1655255 |
| Wisconsin | Owner occupied | Lacking plumbing facilities | 5250 |
| Wisconsin | Renter occupied | Complete plumbing facilities | 781225 |
| Wisconsin | Renter occupied | Lacking plumbing facilities | 4298 |
| Racine County, Wisconsin | Owner occupied | Complete plumbing facilities | 56159 |
| Racine County, Wisconsin | Owner occupied | Lacking plumbing facilities | 124 |
| Racine County, Wisconsin | Renter occupied | Complete plumbing facilities | 22809 |
| Racine County, Wisconsin | Renter occupied | Lacking plumbing facilities | 17 |
| Racine School District, Wisconsin | Owner occupied | Complete plumbing facilities | 38779 |
| Racine School District, Wisconsin | Owner occupied | Lacking plumbing facilities | 47 |
| Racine School District, Wisconsin | Renter occupied | Complete plumbing facilities | 17242 |
| Racine School District, Wisconsin | Renter occupied | Lacking plumbing facilities | 12 |

Finally, you can do some
[tidyverse](https://www.tidyverse.org "The tidyverse")-only magic to
look at the different rates of plumbing for renters versus owners.

``` r
RATES_OF_PLUMBING <- PLUMBING |>
    dplyr::mutate(
        dplyr::across(c("Tenure", "Plumbing"),
                      \(.) stringr::str_extract(., "^\\S+"))
    ) |>
    tidyr::pivot_wider(
        names_from = "Tenure",
        values_from = "Households"
    ) |>
    dplyr::mutate(
        `All Households` = .data$Owner + .data$Renter
    ) |>
    tidyr::pivot_longer(
        cols = c("Renter", "Owner", "All Households"),
        names_to = "Tenure",
        values_to = "Households"
    ) |>
    tidyr::pivot_wider(
        names_from = "Plumbing",
        values_from = "Households"
    ) |>
    dplyr::mutate(
        Households = .data$Complete + .data$Lacking,
        Rate = .data$Complete / .data$Households
    ) |>
    dplyr::select(
        "Geography",
        "Tenure",
        "Rate"
    ) |>
    tidyr::pivot_wider(
        names_from = "Tenure",
        values_from = "Rate"
    )
```

| Geography                         | Renter |  Owner | All Households |
|:----------------------------------|-------:|-------:|---------------:|
| United States                     | 99.46% | 99.68% |         99.60% |
| Midwest Region                    | 99.50% | 99.71% |         99.64% |
| Wisconsin                         | 99.45% | 99.68% |         99.61% |
| Racine County, Wisconsin          | 99.93% | 99.78% |         99.82% |
| Racine School District, Wisconsin | 99.93% | 99.88% |         99.89% |

Three things might jump out at you. The first is that almost every
household in the US has complete plumbing facilities. The second thing
is that plumbing access seems a little different for renters and owners.
The third thing is that who has more access to plumbing is different in
Racine than at larger geographic levels. At the scale of the nation,
region, and state, renters are a little less likely to have complete
access to plumbing. In contrast, renters in Racine County and the Racine
Unified School District are actually a little more likely to have access
to plumbing.

## Footnotes

[^1]:  Whether the occupants rent or own, not if they can’t be fired.
