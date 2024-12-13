
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hercacstables

<!-- badges: start -->
<!-- badges: end -->

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

The American Community Survey (ACS) from the US Census’s website returns
data in a weirdly idiosyncratic way. There are many subtotals in each
table. Grouping variables are organized in a tree-like, rather than
tabular fashion. This package is intended to make it easy to access and
use the ACS data with R.

Many questions that work with Census data follow a common pattern:

> How did \[measurement\] differ among \[demographic groups\] and across
> \[geographic levels\] in \[geographic area\] during \[span of time\]?

A **Measurement** is any of the huge number of things that the Census
keeps track of. Measurements are arranged in tables (called “groups”)
and rows. If you were drawing maps, this would be what determines the
color of each area. Examples include population size (table B01001 and
others), median household income (table B19013 and others), types of
computers in a household (table B28001), number of vehicles used while
commuting (table B08015).

A **Demographic Group** is a subset of the population that shares
specific traits. Demographic groups can be represented either by groups
(common when reporting by race or ethnicity) or rows (most other cases,
like age, sex, or veteran status). If you were drawing maps, you would
probably have a different version of each map for each demographic
grouping. Examples include the number of Hispanic girls under 5 years
old (table B01001I, row 18), the median income of Asian American
households (table B19013D, row 1), the number of households with no
computer (table B28001, row 11), the number of vehicles used by women
while commuting (table B08015, row 3).

A **Geographic Level** is a [Census-defined
hierarchy](https://www.census.gov/programs-surveys/geography/guidance.html)
from the whole country to small blocks. The level that you are
interested in is determined by the scale of your question. If you were
drawing maps, these would be the areas that appeared as different
colors. Examples include congressional districts, incorporated cities,
school districts, and Census tracts.

A **Geographic Area** is a set of specific instances of one or more
geographic levels. This is the full geographic scope of your question.
If you were drawing maps, this would determine their scale. Examples
include whole states, metropolitan areas, Census-designated places, and
counties.

## The workflow

1.  Identify the groups and rows that contain the data you need
    - Find potential groups by searching the `Universe` and
      `Description` fields of `hercacstables::ACS_GROUP_METADATA`.
    - Identify specific variables with
      `hercacstables::ACS_VARIABLE_METADATA`: filter by the `Group`
      field and examine the `Details` field.
    - Create a lookup table that maps from the Census variable name to
      your variables.
      - You may need several if you are pulling data from several
        groups.
2.  Define the geographies that you will use
    - Use `hercacstables::ACS_GEOGRAPHY_METADATA` for this, too!
    - You need to know at least two levels of geography:
      - The one that you want to pull data for, your level of interest
        - This is often small, like tract or county subdivision.
      - Any and all levels that contain your level of interest
        - These will be larger, like state or county.
    - Create a lookup table that maps from geographic ids to meaningful
      names.
3.  Write fetching functions that call `hercacstables::fetch_data`
    - they will often always use the same variables (from step 1)
    - they may need to be parameterized by geography if you’re pulling
      from multiple levels
    - they should always be parameterized by year so that you can reuse
      them
4.  Write wrangling functions that for turning fetched tables into
    useful ones.
    - These will probably involve using `dplyr::inner_join` between the
      fetched data and your lookup tables.
    - You can also perform calculations like aggregating or finding
      remainders.
5.  Run the workflow in two stages.
    - Use `purrr::map` and `purrr::list_rbind` to download all of the
      data into one data frame.
      - Cache that result because API calls are slow
    - Run the wrangling functions.
      - Save these results with, e.g. `base::saveRDS`.

## Example

Let’s say you want to ask this question:

> How did \[the number of households\] differ between \[Hispanic and
> non-Hispanic people\] and across \[Manchester, Nashua, and suburban
> areas\] in \[Hillsborough County, NH\] during \[the last 10 years\]?

### find the **measurement** and **demographic groups**

First, find the variables that describe the numbers of households. One
way to do this is to search `hercacstables::ACS_GROUP_METADATA` for
groups whose `Universe` is “Households” and whose `Description` contains
“Hispanic” or “Ethnicity.” A group’s `Universe` describes what it is
measuring, often telling you the units of whatever its values are. A
group’s `Description` is a phrase that summarizes what it reports.

``` r
hercacstables::ACS_GROUP_METADATA |>
    dplyr::filter(stringr::str_detect(.data$Universe, "Household"),
                  stringr::str_detect(.data$Description, "Hispanic|Ethnic")) |>
    knitr::kable()
```

| Group | Universe | Description | ACS1 | ACS5 |
|:---|:---|:---|:---|:---|
| B11001H | Households with a householder who is White alone, not Hispanic or Latino | Household Type (Including Living Alone) (White Alone, Not Hispanic or Latino) | TRUE | TRUE |
| B11001I | Households with a householder who is Hispanic or Latino | Household Type (Including Living Alone) (Hispanic or Latino) | TRUE | TRUE |
| B19001H | Households with a householder who is White alone, not Hispanic or Latino | Household Income in the Past 12 Months (White Alone, Not Hispanic or Latino Householder) | TRUE | TRUE |
| B19001I | Households with a householder who is Hispanic or Latino | Household Income in the Past 12 Months (Hispanic or Latino Householder) | TRUE | TRUE |
| B19013H | Households with a householder who is White alone, not Hispanic or Latino | Median Household Income in the Past 12 Months (White Alone, Not Hispanic or Latino Householder) | TRUE | TRUE |
| B19013I | Households with a householder who is Hispanic or Latino | Median Household Income in the Past 12 Months (Hispanic or Latino Householder) | TRUE | TRUE |
| B19025H | Households with a householder who is White alone, not Hispanic or Latino | Aggregate Household Income in the Past 12 Months (White Alone, Not Hispanic or Latino Householder) | TRUE | TRUE |
| B19025I | Households with a householder who is Hispanic or Latino | Aggregate Household Income in the Past 12 Months (Hispanic or Latino Householder) | TRUE | TRUE |
| B19037H | Households with a householder who is White alone, not Hispanic or Latino | Age of Householder by Household Income in the Past 12 Months (White Alone, Not Hispanic or Latino Householder) | TRUE | TRUE |
| B19037I | Households with a householder who is Hispanic or Latino | Age of Householder by Household Income in the Past 12 Months (Hispanic or Latino Householder) | TRUE | TRUE |
| B22005H | Households with a householder who is White alone, not Hispanic or Latino | Receipt of Food Stamps/SNAP in the Past 12 Months by Race of Householder (White Alone, Not Hispanic or Latino) | TRUE | TRUE |
| B22005I | Households with a householder who is Hispanic or Latino | Receipt of Food Stamps/SNAP in the Past 12 Months by Race of Householder (Hispanic or Latino) | TRUE | TRUE |

It looks like our best bet is group “B11001I.” It is likely that group
“B11001” contains counts of households of any race. The first row of
most groups is the total value across any demographic subset that it
keeps track of. Since our question does not ask about different
household types, we probably just need row one from groups “B11001” and
“B11001I.” This gives us a good opportunity to document the ethnicities
counted in each.

``` r
HOUSEHOLD_GROUPS <- c("B11001", "B11001I")
household_variables <- hercacstables::ACS_VARIABLE_METADATA |>
    dplyr::filter(
        .data$Dataset == "ACS1",
        .data$Group %in% HOUSEHOLD_GROUPS,
                  .data$Index == 1) |>
    dplyr::mutate(
        Ethnicity = dplyr::case_match(.data$Group,
                                      "B11001" ~ "All",
                                      "B11001I" ~ "Hispanic or Latino")
    ) |>
    dplyr::select("Group", "Index", "Variable", "Ethnicity")

knitr::kable(household_variables,
             align = c("lrll"))
```

| Group   | Index | Variable     | Ethnicity          |
|:--------|------:|:-------------|:-------------------|
| B11001I |     1 | B11001I_001E | Hispanic or Latino |
| B11001  |     1 | B11001_001E  | All                |

### find the **geographic levels** and **geographic area**

The next step is to [find the
codes](https://www.census.gov/library/reference/code-lists/ansi.html)
that are related to the geographic areas and levels. We need to know the
FIPS code for the state, county, and two cities. We also need to know
that the geographic level that we’re working with is “county
subdivision.” As the last part of this step, we define a lookup table to
translate from the FIPS codes for the different geographies to a
human-readable name.

``` r
NEW_HAMPSHIRE <- "33"
COUNTY_LEVEL <- "county"
HILLSBOROUGH_CO <- "011"
CITY_LEVEL <- "county subdivision"
MANCHESTER_NH <- "45140"
NASHUA_NH <- "50260"

geography_definitions <- tibble::tribble(
    ~ FIPS,          ~ Location,
    HILLSBOROUGH_CO, "County-wide",
    MANCHESTER_NH,   "Manchester",
    NASHUA_NH,       "Nashua"
)

geography_definitions |>
    knitr::kable()
```

| FIPS  | Location    |
|:------|:------------|
| 011   | County-wide |
| 45140 | Manchester  |
| 50260 | Nashua      |

### find the **time interval**

The last ten years available from the Census are, as of 2024-12-12, 2013
through 2023. We can use 1-year estimates for our question because we
are dealing with geographic levels that have more than 50,000 people in
them. That gives us more year-to-year precision, although it does mean
that we have to exclude 2020. There are no 1-year ACS estimates for 2020
because of the COVID-19 pandemic.

``` r
YEARS_INCLUDED <- c(TEN_YEARS_AGO:2019, 2021:LATEST_YEAR)
```

### define functions that use the API

We will need to make multiple calls to the API, so it makes sense to
create some reusable functions. We need two calls per year. The first
one will pull the county-wide household counts. The second one will pull
the household counts for each city. Each function should have “year” as
its argument so that we can reuse it.

``` r
generalized_fetch_data <- function(.year, .level, .areas, ...) {
    hercacstables::fetch_data(
        variables = household_variables$Variable,
        year = .year,
        survey_type = "acs",
        table_or_survey_code = "acs1",
        for_geo = .level,
        for_items = .areas,
        state = NEW_HAMPSHIRE,
        ...
    )
}

fetch_county_households <- function(.year){
    generalized_fetch_data(.year,
                           "county",
                           HILLSBOROUGH_CO)
}

fetch_city_households <- function(.year){
    generalized_fetch_data(.year,
                           CITY_LEVEL,
                           c(MANCHESTER_NH,
                             NASHUA_NH),
                           county = HILLSBOROUGH_CO)
}

fetch_example_data <- function(.year) {
    dplyr::bind_rows(
        fetch_county_households(.year),
        fetch_city_households(.year)
    )
}
```

### fetch the data

This is where `hercacstables` starts to come into its own. We define the
fetching process as few times as possible, just tweaking it for related
cases. This leads to a lot of code reuse and efficiency, especially for
reports that you just need to update once a year.

``` r
raw_households <- YEARS_INCLUDED |>
    purrr::map(fetch_example_data) |>
    purrr::list_rbind()
```

``` r
raw_households |>
    dplyr::filter(.data$Year == LATEST_YEAR) |>
    dplyr::mutate(
        dplyr::across(c("Value"),
                      scales::label_comma(accuracy = 1))
    ) |>
    knitr::kable(
        align = "lllrrrl"
    )
```

| state | county | Group   | Index |   Value | Year | county subdivision |
|:------|:-------|:--------|------:|--------:|-----:|:-------------------|
| 33    | 011    | B11001I |     1 |  11,255 | 2023 | NA                 |
| 33    | 011    | B11001  |     1 | 170,761 | 2023 | NA                 |
| 33    | 011    | B11001I |     1 |   4,511 | 2023 | 45140              |
| 33    | 011    | B11001  |     1 |  50,053 | 2023 | 45140              |
| 33    | 011    | B11001I |     1 |   4,770 | 2023 | 50260              |
| 33    | 011    | B11001  |     1 |  36,451 | 2023 | 50260              |

### wrangle the data

The raw data are not very usable. Several of the columns still have
codes, rather than human-readable values. The value column also does not
explicitly state values for the suburban or for non-Hispanic folks. The
“wrangling” process is where we addressing these drawbacks.

#### map codes to words

We should get rid of the columns that are Census database codes and
create columns about location and demographics that have human-readable
values.

``` r
households <- raw_households |>
    dplyr::inner_join(
        household_variables,
        by = c("Group", "Index")
    ) |>
    dplyr::mutate(
        FIPS = dplyr::coalesce(.data$`county subdivision`,
                               .data$county)
    ) |>
    dplyr::inner_join(
        geography_definitions,
        by = "FIPS"
    ) |>
    dplyr::select(
        "Location",
        "Year",
        "Ethnicity",
        Households = "Value"
    )

households |>
    dplyr::filter(.data$Year == LATEST_YEAR) |>
    dplyr::mutate(
        dplyr::across(c("Households"),
                      scales::label_comma(accuracy = 1))
    ) |>
    knitr::kable(
        align = "rllr"
    )
```

|    Location | Year | Ethnicity          | Households |
|------------:|:-----|:-------------------|-----------:|
| County-wide | 2023 | Hispanic or Latino |     11,255 |
| County-wide | 2023 | All                |    170,761 |
|  Manchester | 2023 | Hispanic or Latino |      4,511 |
|  Manchester | 2023 | All                |     50,053 |
|      Nashua | 2023 | Hispanic or Latino |      4,770 |
|      Nashua | 2023 | All                |     36,451 |

#### compute implicit values

Now that the columns are human-readable, we can compute the values that
we are actually interested in. That computation involves subtracting
either the cities’ households from the county’s, or the number of
Hispanic households from the total number of households. This task turns
up very frequently when dealing with Census data, so the package
includes a helper function to do it for you:
`hercacstables::subtract_parts_from_whole`. That function does not
remove the rows that contain the all-groups category. In our case, we
must remove them so all of the calculations come out correctly.

``` r
households <- households |>
    hercacstables::subtract_parts_from_whole(
        grouping_column = "Location",
        value_column = "Households",
        whole_name = "County-wide",
        part_names = c("Manchester", "Nashua"),
        remainder_name = "Suburbs"
    ) |>
    dplyr::select(
        !"County-wide"
    ) |>
    hercacstables::subtract_parts_from_whole(
        grouping_column = "Ethnicity",
        value_column = "Households",
        whole_name = "All",
        part_names = "Hispanic or Latino",
        remainder_name = "Not Hispanic or Latino"
    ) |>
    dplyr::select(
        !"All"
    )

households |>
    dplyr::filter(.data$Year == LATEST_YEAR) |>
    dplyr::mutate(
        dplyr::across(c("Households"),
                      scales::label_comma(accuracy = 1))
    ) |>
    knitr::kable(
        align = "lrlr"
    )
```

| Year |   Location | Ethnicity              | Households |
|:-----|-----------:|:-----------------------|-----------:|
| 2023 | Manchester | Hispanic or Latino     |      4,511 |
| 2023 | Manchester | Not Hispanic or Latino |     45,542 |
| 2023 |     Nashua | Hispanic or Latino     |      4,770 |
| 2023 |     Nashua | Not Hispanic or Latino |     31,681 |
| 2023 |    Suburbs | Hispanic or Latino     |      1,974 |
| 2023 |    Suburbs | Not Hispanic or Latino |     82,283 |

### Answer the question

Now we can finally look at trends in number of households in
Hillsborough County, NH, comparing between Hispanic and non-Hispanic
households among Manchester, Nashua, and the suburbs.

#### visualize

The first step is to make some graphs. These data are 4-dimensional
because they involve time, location, ethnicity, and number of
households. That means we’ll need more than one graph. It looked from
the tables above that the number of Hispanic households is much lower
than non-Hispanic households in all three locations. Let’s make a
two-panel graph, where each panel shows one ethnicity. That way they can
have separate y axes. Both graphs will have time on the x-axis, number
of households on the y, and designate location with the color of points
and lines.

``` r
households |>
    ggplot2::ggplot(
        ggplot2::aes(
            x = .data$Year,
            y = .data$Households,
            color = .data$Location,
            group = .data$Location
        )
    ) +
    ggplot2::geom_line(
        linewidth = 2
    ) +
    ggplot2::geom_point(
        size = 5
    ) +
    ggplot2::scale_x_continuous(
        name = NULL,
        breaks = scales::breaks_width(5),
        minor_breaks = scales::breaks_width(1)
    ) +
    ggplot2::scale_y_continuous(
        name = "Number of households",
        limits = c(0, NA),
        labels = scales::label_comma(accuracy = 1)
    ) +
    ggplot2::scale_color_viridis_d(
        name = NULL,
        guide = ggplot2::guide_legend(position = "top")
    ) +
    ggplot2::facet_grid(
        rows = ggplot2::vars(.data$Ethnicity),
        scales = "free_y"
    )
```

<img src="man/figures/README-plot-the-results-1.png" width="100%" />

It looks like the number of households is growing, with non-Hispanic
households increasing in the suburbs and Hispanic households increasing
in the cities.

#### analyze

Let’s test this with an ANCOVA. We’ll subtract 2013 from the year so
that the intercept estimate gives us the value in 2013, not AD 0.

``` r
household_model <- households |>
    dplyr::mutate(
        Year = .data$Year - TEN_YEARS_AGO,
        Location = factor(.data$Location,
                          levels = c("Suburbs",
                                     "Manchester",
                                     "Nashua")),
        Ethnicity = factor(.data$Ethnicity,
                           levels = c("Not Hispanic or Latino",
                                      "Hispanic or Latino"))
    ) |>
    lm(
        Households ~ Year * Ethnicity * Location,
        data = _
    )
```

I always like to look at the ANOVA table first to get a 10,000 meter
view before I try to interpret specific parameters.

``` r
household_model |>
    anova() |>
    broom::tidy() |>
    dplyr::mutate(
        dplyr::across(c("sumsq",
                        "meansq"),
                      scales::label_comma(accuracy = 1)),
        dplyr::across("statistic",
                      \(.) signif(., 4)),
        dplyr::across("p.value",
                      \(.) round(., 4))
    ) |>
    knitr::kable(
        align = "lrrrrr"
    )
```

| term                    |  df |          sumsq |         meansq | statistic | p.value |
|:------------------------|----:|---------------:|---------------:|----------:|--------:|
| Year                    |   1 |     60,931,207 |     60,931,207 |    94.270 |  0.0000 |
| Ethnicity               |   1 | 35,763,474,535 | 35,763,474,535 | 55330.000 |  0.0000 |
| Location                |   2 |  4,974,084,103 |  2,487,042,052 |  3848.000 |  0.0000 |
| Year:Ethnicity          |   1 |     16,522,903 |     16,522,903 |    25.560 |  0.0000 |
| Year:Location           |   2 |      8,405,692 |      4,202,846 |     6.503 |  0.0031 |
| Ethnicity:Location      |   2 |  6,022,394,783 |  3,011,197,392 |  4659.000 |  0.0000 |
| Year:Ethnicity:Location |   2 |     15,834,332 |      7,917,166 |    12.250 |  0.0000 |
| Residuals               |  50 |     32,316,192 |        646,324 |        NA |      NA |

It looks like EVERYTHING is significant, so let’s look at all of the
parameters that were in the near-significant range.

``` r
household_model |>
    broom::tidy() |>
    dplyr::filter(
        .data$`p.value` < 0.1
    ) |>
    dplyr::mutate(
        dplyr::across(c("estimate",
                        "std.error",
                        "statistic"),
                      \(.) signif(., 4)),
        dplyr::across("p.value",
                      \(.) round(., 4))
    ) |>
    knitr::kable(
        align = "lrrrr"
    )
```

| term | estimate | std.error | statistic | p.value |
|:---|---:|---:|---:|---:|
| (Intercept) | 74270.0 | 417.80 | 177.800 | 0e+00 |
| Year | 699.2 | 72.08 | 9.701 | 0e+00 |
| EthnicityHispanic or Latino | -73240.0 | 590.90 | -123.900 | 0e+00 |
| LocationManchester | -32620.0 | 565.70 | -57.670 | 0e+00 |
| LocationNashua | -41730.0 | 590.90 | -70.620 | 0e+00 |
| Year:EthnicityHispanic or Latino | -612.2 | 101.90 | -6.006 | 0e+00 |
| Year:LocationManchester | -436.5 | 99.71 | -4.378 | 1e-04 |
| Year:LocationNashua | -594.0 | 101.90 | -5.827 | 0e+00 |
| EthnicityHispanic or Latino:LocationManchester | 34460.0 | 800.00 | 43.080 | 0e+00 |
| EthnicityHispanic or Latino:LocationNashua | 43180.0 | 835.60 | 51.680 | 0e+00 |
| Year:EthnicityHispanic or Latino:LocationManchester | 507.8 | 141.00 | 3.601 | 7e-04 |
| Year:EthnicityHispanic or Latino:LocationNashua | 686.1 | 144.20 | 4.759 | 0e+00 |

#### summarize

The number of households in Hillsborough county overall grew from
2013-2023. The number of Hispanic households was much higher in the two
cities than in the suburban parts of the county. This difference became
more pronounced over the decade, for two reasons. The number of Hispanic
households grew more quickly in Nashua and Manchester than in the
suburban areas. The number of non-Hispanic households grew more quickly
in the suburbs than in the cities. Isn’t it nice when the visual
patterns are corroborated by significant statistics?
