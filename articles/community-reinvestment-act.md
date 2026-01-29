# Income Brackets for the Community Reinvestment Act

``` r
library(hercacstables)
```

## Context

The [Community Reinvestment Act](https://www.ffiec.gov/data/cra), or
CRA, is Federal legislation with mandates for how lenders must engage
with folks living in areas with relatively low incomes. The Minneapolis
Federal Reserve has really nice
[explanation](https://www.minneapolisfed.org/about-us/community-development-and-engagement/community-reinvestment-act)
of it. They even have a [helpful
article](https://www.minneapolisfed.org/article/2018/defining-low--and-moderate-income-and-assessment-areas)
about the definitions of “low and moderate income” with respect to a
lender’s “assessment area.” These are key terms for place-based
partnerships that want to demonstrate their pertinence to a CRA lender.

The CRA defines four brackets of income level relative to an assessment
area’s median income. You can use `hercacstables` to pull an area’s
median income, define the bracket ranges, and then to count the number
of families in your area that fall into each bracket.

## Areas

We need to identify two different geographical footprints for this
analysis. The first is the “assessment area,” which is a broad
geographical scope that defines a baseline economic status for the CR.
The second is the specific area that your organization will impact. This
will be a subset of the assessment area, probably where poverty has been
concentrated by the systems that you are trying to change.

### Assesssment Area

Identifying the assessment area that is relevant to your organization is
not complicated: it is probably the Census-defined Metropolitan
Statistical Area where your organization is located. If your
organization serves part of an enormous metro area, you may need to
identify a specific Metropolitan Division. If your organization serves a
region with low population density, you may need to use your entire
state. If you don’t already know your area, you can start looking for it
on this
[FAQ](https://www.census.gov/data/what-is-data-census-gov/guidance-for-data-users/frequently-asked-questions/how-do-i-search-by-address-using-data-census-gov.html).

For this article, we are going to use two Metropolitan Statistical Areas
in southeastern Wisconsin: Kenosha County and Racine County.

``` r
ASSESSMENT_AREAS <- tibble::tribble(
    ~ Area,    ~ county,
    "Kenosha", "059",
    "Racine",  "101"
)
```

### Impact Area

Your organization’s impact area will be more customized to your case.
According to the article above, you should define it in terms of one or
more entire Census Tracts.

For this article, we are going to use two cities in southeastern
Wisconsin: Kenosha and Racine.

``` r
IMPACT_AREAS <- tibble::tribble(
    ~ Area,    ~ city,  ~ district,
    "Kenosha", "39225", "07320",
    "Racine",  "66000", "12360"
)
```

## Incomes

The CRA wants us to look at income in three ways: the median in our
assessment area, the brackets defined by that median income, and the
number of folks in our assessment area in each bracket.

### Median income of assessment areas

We’ll use table
[`B19326`](https:://api.census.gov/data/acs/2024/B19326.html), which
reports median income by place of birth. A full explanation of how I
chose this table appears in an appendix at the [end of this
article](#Finding-a-Median-Income-Table). We don’t actually need any of
the details of place of birth, just the area’s overall median income.
That will be reported by the table’s first row, `B19326_001E`.

``` r
MEDIAN_INCOMES <- "B19326_001E" |>
    fetch_data(
        year = 2024L,
        for_geo = "county",
        for_items = ASSESSMENT_AREAS$county,
        survey_type = "acs",
        table_or_survey_code = "acs1",
        state = "55"
    ) |>
    dplyr::right_join(
        ASSESSMENT_AREAS,
        by = "county"
    ) |>
    dplyr::select(
        "Area",
        `Median Income` = "Value"
    )
```

| Area    | Median Income |
|:--------|--------------:|
| Kenosha |      \$45,091 |
| Racine  |      \$43,133 |

Personal median incomes in 2024

### Defining income brackets

We can define a glossary of income brackets for each assessment area by
joining and multiplying.

``` r
INCOME_BRACKETS <- tibble::tribble(
    ~ Bracket, ~ `Lower Bound`, ~ `Upper Bound`,
    "Low",                 0.0,             0.5,
    "Moderate",            0.5,             0.8,
    "Middle",              0.8,             1.2,
    "Upper",               1.2,             Inf
) |>
    dplyr::mutate(
        Bracket = forcats::fct_inorder(.data$Bracket)
    ) |>
    dplyr::cross_join(
        MEDIAN_INCOMES
    ) |>
    dplyr::mutate(
        dplyr::across(
            tidyselect::ends_with("Bound"),
            \(.) . * .data$`Median Income`
        )
    ) |>
    dplyr::select(
        "Area",
        "Bracket",
        "Lower Bound",
        "Upper Bound"
    )
```

| Bracket  |             Kenosha |              Racine |
|:---------|--------------------:|--------------------:|
| Low      |      \$0 - \$22,546 |      \$0 - \$21,566 |
| Moderate | \$22,546 - \$36,073 | \$21,566 - \$34,506 |
| Middle   | \$36,073 - \$54,109 | \$34,506 - \$51,760 |
| Upper    |      \$54,109 - Inf |      \$51,760 - Inf |

Personal income brackets in 2024

### Counting bracket populations

The third step is to count how many people fall into each income
bracket. To do this, we will use census table
[`B20005`](https://api.census.gov/data/2024/acs/acs1/B19325.html)
`hercacstables` provides `GLOSSARY_OF_SEX_BY_EARNINGS`, which describes
how each row of this table corresponds to a specific combination of sex,
employment status, and income bracket. We must assign each bracket in
`B20005` to one or more of our local income brackets, with the amount
weighted by how much they overlap.

To do that, we’ll create a helper function that computes how much, if at
all, two ranges overlap. We’ll use
[`purrr::map2_dbl`](https://purrr.tidyverse.org/reference/map2.html) to
make it work on vector inputs.

``` r
overlap_helper <- function(.lower_1, .upper_1, .lower_2, .upper_2) {
    .tops <- purrr::map2_dbl(.upper_1, .upper_2, min)
    .bottoms <- purrr::map2_dbl(.lower_1, .lower_2, max)
    purrr::map_dbl(.tops - .bottoms, \(.) max(., 0.0))
}
```

Now we join everything, compute the overlaps, filter out the rows
without any overlap, and compute the weights as the proportion of
overlap.

``` r
GLOSSARY_OF_INCOME_BRACKETS <- GLOSSARY_OF_SEX_BY_INCOME |>
    dplyr::slice(
         -1L, # grand total
         -2L, # subtotal of all males
         -3L, # subtotal of full-time-employed males
         -5L, # subtotal of full-time-employed males with earnings
        -26L, # subtotal of not-full-time-employed males
        -28L, # subtotal of not-full-time-employed males with earnings
        -49L, # subtotal of all females
        -50L, # subtotal of full-time-employed females
        -52L, # subtotal of full-time-employed females with earnings
        -73L, # subtotal of not-full-time-employed females
        -75L  # subtotal of not-full-time-employed females
    ) |>
    dplyr::cross_join(
        INCOME_BRACKETS,
        suffix = c(" Census", " CRA")
    ) |>
    dplyr::mutate(
        Overlap = overlap_helper(.data$`Lower Bound Census`,
                                 .data$`Upper Bound Census`,
                                 .data$`Lower Bound CRA`,
                                 .data$`Upper Bound CRA`)
    ) |>
    dplyr::filter(
        .data$Overlap > 0.0
    ) |>
    dplyr::mutate(
        Proportion = dplyr::coalesce(
            .data$Overlap / 
                (.data$`Upper Bound Census` - .data$`Lower Bound Census`),
            1.0
        )
    ) |>
    dplyr::arrange(
        .data$Index,
        .data$Bracket,
        .data$Area
    )
```

| Area    |    Low | Moderate |  Middle |   Upper |
|:--------|-------:|---------:|--------:|--------:|
| Kenosha | 6 - 85 |  15 - 88 | 18 - 91 | 21 - 95 |
| Racine  | 6 - 84 |  14 - 87 | 17 - 91 | 21 - 95 |

### Fetch the counts

The next step is to pull the counts of people in income brackets from
the Census.

``` r
RAW_COUNTS_BY_INCOME_BRACKET <- fetch_data(
    variables = "group(B19325)",
    year = 2024L,
    for_geo = "place",
    for_items = IMPACT_AREAS$city,
#    for_geo = "school district (unified)",
#    for_items = IMPACT_AREAS$district,
    survey_type = "acs",
    table_or_survey_code = "acs1",
    state = "55"
)
```

``` r
COUNTS_BY_INCOME_BRACKET <- RAW_COUNTS_BY_INCOME_BRACKET |>
    dplyr::filter(
        .data$Measure == "E"
    ) |>
    dplyr::semi_join(
        GLOSSARY_OF_INCOME_BRACKETS,
        by = "Index"
    ) |>
    dplyr::inner_join(
        IMPACT_AREAS,
#        by = c(`school district (unified)` = "district")
        by = c(place = "city")
    ) |>
    dplyr::left_join(
        GLOSSARY_OF_INCOME_BRACKETS,
        by = c("Area", "Index"),
        relationship = "many-to-many"
    )
```

``` r
POPULATIONS_PER_BRACKET <- COUNTS_BY_INCOME_BRACKET |>
    dplyr::summarize(
        People = sum(.data$Proportion * .data$Value, na.rm = TRUE),
        .by = c("Area", "Bracket")
    ) |>
    dplyr::arrange(
        .data$Area,
        .data$Bracket
    )
```

| Area    | Bracket  | People | Percent |
|:--------|:---------|-------:|--------:|
| Kenosha | Low      | 19,824 |     27% |
| Kenosha | Moderate | 10,228 |     14% |
| Kenosha | Middle   | 14,326 |     20% |
| Kenosha | Upper    | 28,574 |     39% |
| Racine  | Low      | 16,110 |     29% |
| Racine  | Moderate |  8,582 |     16% |
| Racine  | Middle   | 14,260 |     26% |
| Racine  | Upper    | 15,885 |     29% |

The distributions of personal incomes differ between Kenosha and Racine.
The most populous income bracket in Kenosha, Upper, makes up 39% of
people. Kenosha\`s next largest bracket, Lower income, also has a lot of
people: 27%. Its Moderate (14%) and Middle (20%) brackets are both less
populous. In contrast, Racine’s Lower and Upper brackets are tied for
most populous, at 29% each. Racine’s Middle (26%) bracket is also pretty
populous, leaving the Moderate income bracket as the smallest, with only
16% of the population. Both income distributions are bimodal and
asymmetric, with more folks at the extreme ends of the income range.

## Appendix

If, like me, have NOT memorized every subtable of the ACS, you will need
to look up which tables report the data that you need. The
`search_in_columns` function and `METADATA_FOR_ACS_GROUPS` gloassary of
`hercacstables` exist for exactly this situation.

### Finding a Median Income Table

We definitely want to find tables with the word “median” in them. The
Census uses both “income” and “earnings” to talk about how much people
make. We’ll search with both of those terms.

``` r
METADATA_FOR_ACS_GROUPS |>
    search_in_columns(
        Description = c("median", "income|earn"), # case-insensitive search for "median" AND ("income" OR "earn")
        Universe = "population",                  # this will give us individual incomes
        Group = "\\d$"                            # this will exclude tables that report within a single race
    ) |>
    knitr::kable()
```

| Group  | Universe                                                                                       | Description                                                                                                                                                    | ACS1 | ACS5 |
|:-------|:-----------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----|:-----|
| B06011 | Population 15 years and over in the United States with income                                  | Median Income in the Past 12 Months by Place of Birth in the United States                                                                                     | TRUE | TRUE |
| B07011 | Population 15 years and over in the United States with income                                  | Median Income in the Past 12 Months by Geographical Mobility in the Past Year for Current Residence in the United States                                       | TRUE | TRUE |
| B07411 | Population 15 years and over in the United States with income                                  | Median Income in the Past 12 Months by Geographical Mobility in the Past Year for Residence 1 Year Ago in the United States                                    | TRUE | TRUE |
| B15013 | Population 25 to 64 years with earnings and a Bachelor’s degree or higher attainment           | Median Earnings in the Past 12 Months by Sex by Field of Bachelor’s Degree for First Major                                                                     | TRUE | TRUE |
| B15014 | Population 25 to 64 years with earnings and a Bachelor’s degree or higher attainment           | Median Earnings in the Past 12 Months by Age by Field of Bachelor’s Degree for First Major                                                                     | TRUE | TRUE |
| B18140 | Civilian noninstitutionalized population 16 years and over with earnings in the past 12 months | Median Earnings in the Past 12 Months by Disability Status by Sex for the Civilian Noninstitutionalized Population 16 Years and Over With Earnings             | TRUE | TRUE |
| B19326 | Population 15 years and over with income in the past 12 months                                 | Median Income in the Past 12 Months by Sex by Work Experience in the Past 12 Months for the Population 15 Years and Over With Income                           | TRUE | TRUE |
| B20002 | Population 16 years and over with earnings                                                     | Median Earnings in the Past 12 Months by Sex for the Population 16 Years and Over With Earnings in the Past 12 Months                                          | TRUE | TRUE |
| B20004 | Population 25 years and over with earnings                                                     | Median Earnings in the Past 12 Months by Sex by Educational Attainment for the Population 25 Years and Over                                                    | TRUE | TRUE |
| B20017 | Population 16 years and over with earnings                                                     | Median Earnings in the Past 12 Months by Sex by Work Experience in the Past 12 Months for the Population 16 Years and Over With Earnings in the Past 12 Months | TRUE | TRUE |
| B20018 | Population 16 years and over who worked full-time, year-round with earnings                    | Median Earnings in the Past 12 Months for the Population 16 Years and Over Who Worked Full-Time, Year-Round With Earnings in the Past 12 Months                | TRUE | TRUE |
| B21004 | Civilian population 18 years and over with income in the past 12 months                        | Median Income in the Past 12 Months by Veteran Status by Sex for the Civilian Population 18 Years and Over With Income                                         | TRUE | TRUE |
| B24011 | Civilian employed population 16 years and over with earnings                                   | Occupation by Median Earnings in the Past 12 Months for the Civilian Employed Population 16 Years and Over                                                     | TRUE | TRUE |
| B24012 | Civilian employed population 16 years and over with earnings                                   | Sex by Occupation and Median Earnings in the Past 12 Months for the Civilian Employed Population 16 Years and Over                                             | TRUE | TRUE |
| B24021 | Full-time, year-round civilian employed population 16 years and over with earnings             | Occupation by Median Earnings in the Past 12 Months for the Full-Time, Year-Round Civilian Employed Population 16 Years and Over                               | TRUE | TRUE |
| B24022 | Full-time, year-round civilian employed population 16 years and over with earnings             | Sex by Occupation and Median Earnings in the Past 12 Months for the Full-Time, Year-Round Civilian Employed Population 16 Years and Over                       | TRUE | TRUE |
| B24031 | Civilian employed population 16 years and over with earnings                                   | Industry by Median Earnings in the Past 12 Months for the Civilian Employed Population 16 Years and Over                                                       | TRUE | TRUE |
| B24032 | Civilian employed population 16 years and over with earnings                                   | Sex by Industry and Median Earnings in the Past 12 Months for the Civilian Employed Population 16 Years and Over                                               | TRUE | TRUE |
| B24041 | Full-time, year-round civilian employed population 16 years and over with earnings             | Industry by Median Earnings in the Past 12 Months for the Full-Time, Year-Round Civilian Employed Population 16 Years and Over                                 | TRUE | TRUE |
| B24042 | Full-time, year-round civilian employed population 16 years and over with earnings             | Sex by Industry and Median Earnings in the Past 12 Months for the Full-Time, Year-Round Civilian Employed Population 16 Years and Over                         | TRUE | TRUE |
| B24081 | Civilian employed population 16 years and over with earnings                                   | Class of Worker by Median Earnings in the Past 12 Months for the Civilian Employed Population 16 Years and Over                                                | TRUE | TRUE |
| B24082 | Civilian employed population 16 years and over with earnings                                   | Sex by Class of Worker and Median Earnings in the Past 12 Months for the Civilian Employed Population 16 Years and Over                                        | TRUE | TRUE |
| B24091 | Full-time, year-round civilian employed population 16 years and over with earnings             | Class of Worker by Median Earnings in the Past 12 Months for the Full-Time, Year-Round Civilian Employed Population 16 Years and Over                          | TRUE | TRUE |
| B24092 | Full-time, year-round civilian employed population 16 years and over with earnings             | Sex by Class of Worker and Median Earnings in the Past 12 Months for the Full-Time, Year-Round Civilian Employed Population 16 Years and Over                  | TRUE | TRUE |
| B24121 | Full-time, year-round civilian employed population 16 years and over with earnings             | Detailed Occupation by Median Earnings in the Past 12 Months for the Full-Time, Year-Round Civilian Employed Population 16 Years and Over                      | TRUE | TRUE |
| B24122 | Full-time, year-round civilian employed male population 16 years and over with earnings        | Detailed Occupation by Median Earnings in the Past 12 Months for the Full-Time, Year-Round Civilian Employed Male Population 16 Years and Over                 | TRUE | TRUE |
| B24123 | Full-time, year-round civilian employed female population 16 years and over with earnings      | Detailed Occupation by Median Earnings in the Past 12 Months for the Full-Time, Year-Round Civilian Employed Female Population 16 Years and Over               | TRUE | TRUE |
| B26119 | Population 16 years and over with earnings                                                     | Median Earnings in the Past 12 Months by Group Quarters Type (3 Types) by Sex                                                                                  | TRUE | TRUE |
| B26219 | Population 16 years and over with earnings                                                     | Median Earnings in the Past 12 Months by Group Quarters Type (5 Types) by Sex                                                                                  | TRUE | TRUE |

Wow … that’s a lot of tables. Poring through them, table
[`B19326`](https://api.census.gov/data/2024/acs/acs1/B19326.html) seems
promisingly broad. In fact, if we cheat by looking
[ahead](#Finding-counts-by-income) at tables that count people by
income, we find that there is a corresponding table `B19325` that should
make it easy to count people once we’ve determined brackets.

Let’s use `B19326` to calculate the [median income of an assessment
area](#Median-income-of-assessment-areas).

### Finding counts by income

Once again, we’ll look for tables with either “income” or “earn” in
their descriptions. This time, however, we want to specifically exclude
tables that summarize dollars. We’ll exclude tables with words like
“median,” “average,” or “aggregate” in their descriptions.

``` r
METADATA_FOR_ACS_GROUPS |>
    search_in_columns(
        Description = "income|earn",                          # seems obvious, right?
        `-Description` = c("aggregate", "median", "average"), # no summaries, we want counts of people
        Universe = "population",                              # this should give personal incomes
        Group = "\\d$"                                        # this will exclude tables that report within a single race
    ) |>
    knitr::kable()
```

| Group  | Universe                                                                       | Description                                                                                                                                                                         | ACS1 | ACS5  |
|:-------|:-------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----|:------|
| B06010 | Population 15 years and over in the United States                              | Place of Birth by Individual Income in the Past 12 Months in the United States                                                                                                      | TRUE | TRUE  |
| B07010 | Population 15 years and over in the United States                              | Geographical Mobility in the Past Year by Individual Income in the Past 12 Months for Current Residence in the United States                                                        | TRUE | TRUE  |
| B07410 | Population 15 years and over in the United States                              | Geographical Mobility in the Past Year by Individual Income in the Past 12 Months for Residence 1 Year Ago in the United States                                                     | TRUE | TRUE  |
| B09010 | Population under 18 years in households                                        | Receipt of Supplemental Security Income (SSI), Cash Public Assistance Income, or Food Stamps/SNAP in the Past 12 Months by Household Type for Children Under 18 Years in Households | TRUE | TRUE  |
| B17002 | Population for whom poverty status is determined                               | Ratio of Income to Poverty Level in the Past 12 Months                                                                                                                              | TRUE | FALSE |
| B17024 | Population for whom poverty status is determined                               | Age by Ratio of Income to Poverty Level in the Past 12 Months                                                                                                                       | TRUE | TRUE  |
| B18131 | Civilian noninstitutionalized population for whom poverty status is determined | Age by Ratio of Income to Poverty Level in the Past 12 Months by Disability Status and Type                                                                                         | TRUE | FALSE |
| B19301 | Total population                                                               | Per Capita Income in the Past 12 Months                                                                                                                                             | TRUE | TRUE  |
| B19325 | Population 15 years and over                                                   | Sex by Work Experience in the Past 12 Months by Income in the Past 12 Months for the Population 15 Years and Over                                                                   | TRUE | TRUE  |
| B20001 | Population 16 years and over with earnings                                     | Sex by Earnings in the Past 12 Months for the Population 16 Years and Over With Earnings in the Past 12 Months                                                                      | TRUE | TRUE  |
| B20005 | Population 16 years and over                                                   | Sex by Work Experience in the Past 12 Months by Earnings in the Past 12 Months for the Population 16 Years and Over                                                                 | TRUE | TRUE  |
| B26117 | Population 16 years and over with earnings                                     | Group Quarters Type (3 Types) by Sex With Earnings in the Past 12 Months                                                                                                            | TRUE | TRUE  |
| B26217 | Population 16 years and over with earnings                                     | Group Quarters Type (5 Types) by Sex With Earnings in the Past 12 Months                                                                                                            | TRUE | TRUE  |
| B27015 | Civilian population living in households                                       | Health Insurance Coverage Status and Type by Household Income in the Past 12 Months                                                                                                 | TRUE | TRUE  |
| B27016 | Civilian noninstitutionalized population for whom poverty status is determined | Health Insurance Coverage Status and Type by Ratio of Income to Poverty Level in the Past 12 Months by Age                                                                          | TRUE | FALSE |
| B27017 | Civilian noninstitutionalized population for whom poverty status is determined | Private Health Insurance by Ratio of Income to Poverty Level in the Past 12 Months by Age                                                                                           | TRUE | FALSE |
| B27018 | Civilian noninstitutionalized population for whom poverty status is determined | Public Health Insurance by Ratio of Income to Poverty Level in the Past 12 Months by Age                                                                                            | TRUE | FALSE |
| B99191 | Population 15 years and over                                                   | Allocation of Individuals’ Income in the Past 12 Months for the Population 15 Years and Over - Percent of Income Allocated                                                          | TRUE | TRUE  |
| B99201 | Population 16 years and over                                                   | Allocation of Earnings in the Past 12 Months for the Population 16 Years and Over - Percent of Earnings Allocated                                                                   | TRUE | TRUE  |
| C17002 | Population for whom poverty status is determined                               | Ratio of Income to Poverty Level in the Past 12 Months                                                                                                                              | TRUE | TRUE  |
| C17024 | Population for whom poverty status is determined                               | Age by Ratio of Income to Poverty Level in the Past 12 Months                                                                                                                       | TRUE | FALSE |
| C18131 | Civilian noninstitutionalized population for whom poverty status is determined | Ratio of Income to Poverty Level in the Past 12 Months by Disability Status                                                                                                         | TRUE | TRUE  |
| C27016 | Civilian noninstitutionalized population for whom poverty status is determined | Health Insurance Coverage Status by Ratio of Income to Poverty Level in the Past 12 Months by Age                                                                                   | TRUE | TRUE  |
| C27017 | Civilian noninstitutionalized population for whom poverty status is determined | Private Health Insurance by Ratio of Income to Poverty Level in the Past 12 Months by Age                                                                                           | TRUE | TRUE  |
| C27018 | Civilian noninstitutionalized population for whom poverty status is determined | Public Health Insurance by Ratio of Income to Poverty Level in the Past 12 Months by Age                                                                                            | TRUE | TRUE  |

We get a large number of tables, just like when we searched for [tables
of median incomes](#Finding-a-Median-Income-Table). Once again, if we
“cheat” by looking for tables that seem to go with each other, three
tables jump out:
[`B19325`](https://api.census.gov/data/2024/acs/acs1/B19325.html),
[`B20001`](https://api.census.gov/data/2024/acs/acs1/B20001.html), and
[`B20005`](https://api.census.gov/data/2024/acs/acs1/B20005.html). The
difference between the three is that `B19325` counts people with any
income, `B20005` counts everyone over 16, and `B20001` only counts
people with earnings.

Let’s stick with income, rather than earnings. We’ll use `B19325` to
[count](#Counting-bracket-populations) how many people fall into each
income bracket.

### Detailed bracket information

Here is the full table of each bracket from the Census and the
proportion of its members that go into each bracket from the CRA.

``` r
COUNTS_BY_INCOME_BRACKET |>
    dplyr::select(
        "Area",
        "Sex",
        "Full-time",
        "Index",
        "Lower Bound Census",
        "Upper Bound Census",
        "Bracket",
        "Lower Bound CRA",
        "Upper Bound CRA",
        "Overlap",
        "Proportion"
    ) |>
    knitr::kable()
```

| Area    | Sex    | Full-time | Index | Lower Bound Census | Upper Bound Census | Bracket  | Lower Bound CRA | Upper Bound CRA | Overlap | Proportion |
|:--------|:-------|:----------|------:|-------------------:|-------------------:|:---------|----------------:|----------------:|--------:|-----------:|
| Kenosha | Male   | TRUE      |     6 |                  1 |               2499 | Low      |             0.0 |         22545.5 |  2498.0 |  1.0000000 |
| Kenosha | Male   | TRUE      |     7 |               2500 |               4999 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Male   | TRUE      |     8 |               5000 |               7499 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Male   | TRUE      |     9 |               7500 |               9999 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Male   | TRUE      |    10 |              10000 |              12499 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Male   | TRUE      |    11 |              12500 |              14999 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Male   | TRUE      |    12 |              15000 |              17499 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Male   | TRUE      |    13 |              17500 |              19999 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Male   | TRUE      |    14 |              20000 |              22499 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Male   | TRUE      |    15 |              22500 |              24999 | Low      |             0.0 |         22545.5 |    45.5 |  0.0182073 |
| Kenosha | Male   | TRUE      |    15 |              22500 |              24999 | Moderate |         22545.5 |         36072.8 |  2453.5 |  0.9817927 |
| Kenosha | Male   | TRUE      |    16 |              25000 |              29999 | Moderate |         22545.5 |         36072.8 |  4999.0 |  1.0000000 |
| Kenosha | Male   | TRUE      |    17 |              30000 |              34999 | Moderate |         22545.5 |         36072.8 |  4999.0 |  1.0000000 |
| Kenosha | Male   | TRUE      |    18 |              35000 |              39999 | Moderate |         22545.5 |         36072.8 |  1072.8 |  0.2146029 |
| Kenosha | Male   | TRUE      |    18 |              35000 |              39999 | Middle   |         36072.8 |         54109.2 |  3926.2 |  0.7853971 |
| Kenosha | Male   | TRUE      |    19 |              40000 |              44999 | Middle   |         36072.8 |         54109.2 |  4999.0 |  1.0000000 |
| Kenosha | Male   | TRUE      |    20 |              45000 |              49999 | Middle   |         36072.8 |         54109.2 |  4999.0 |  1.0000000 |
| Kenosha | Male   | TRUE      |    21 |              50000 |              54999 | Middle   |         36072.8 |         54109.2 |  4109.2 |  0.8220044 |
| Kenosha | Male   | TRUE      |    21 |              50000 |              54999 | Upper    |         54109.2 |             Inf |   889.8 |  0.1779956 |
| Kenosha | Male   | TRUE      |    22 |              55000 |              64999 | Upper    |         54109.2 |             Inf |  9999.0 |  1.0000000 |
| Kenosha | Male   | TRUE      |    23 |              65000 |              74999 | Upper    |         54109.2 |             Inf |  9999.0 |  1.0000000 |
| Kenosha | Male   | TRUE      |    24 |              75000 |              99999 | Upper    |         54109.2 |             Inf | 24999.0 |  1.0000000 |
| Kenosha | Male   | TRUE      |    25 |             100000 |                Inf | Upper    |         54109.2 |             Inf |     Inf |  1.0000000 |
| Kenosha | Male   | FALSE     |    29 |                  1 |               2499 | Low      |             0.0 |         22545.5 |  2498.0 |  1.0000000 |
| Kenosha | Male   | FALSE     |    30 |               2500 |               4999 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Male   | FALSE     |    31 |               5000 |               7499 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Male   | FALSE     |    32 |               7500 |               9999 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Male   | FALSE     |    33 |              10000 |              12499 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Male   | FALSE     |    34 |              12500 |              14999 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Male   | FALSE     |    35 |              15000 |              17499 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Male   | FALSE     |    36 |              17500 |              19999 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Male   | FALSE     |    37 |              20000 |              22499 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Male   | FALSE     |    38 |              22500 |              24999 | Low      |             0.0 |         22545.5 |    45.5 |  0.0182073 |
| Kenosha | Male   | FALSE     |    38 |              22500 |              24999 | Moderate |         22545.5 |         36072.8 |  2453.5 |  0.9817927 |
| Kenosha | Male   | FALSE     |    39 |              25000 |              29999 | Moderate |         22545.5 |         36072.8 |  4999.0 |  1.0000000 |
| Kenosha | Male   | FALSE     |    40 |              30000 |              34999 | Moderate |         22545.5 |         36072.8 |  4999.0 |  1.0000000 |
| Kenosha | Male   | FALSE     |    41 |              35000 |              39999 | Moderate |         22545.5 |         36072.8 |  1072.8 |  0.2146029 |
| Kenosha | Male   | FALSE     |    41 |              35000 |              39999 | Middle   |         36072.8 |         54109.2 |  3926.2 |  0.7853971 |
| Kenosha | Male   | FALSE     |    42 |              40000 |              44999 | Middle   |         36072.8 |         54109.2 |  4999.0 |  1.0000000 |
| Kenosha | Male   | FALSE     |    43 |              45000 |              49999 | Middle   |         36072.8 |         54109.2 |  4999.0 |  1.0000000 |
| Kenosha | Male   | FALSE     |    44 |              50000 |              54999 | Middle   |         36072.8 |         54109.2 |  4109.2 |  0.8220044 |
| Kenosha | Male   | FALSE     |    44 |              50000 |              54999 | Upper    |         54109.2 |             Inf |   889.8 |  0.1779956 |
| Kenosha | Male   | FALSE     |    45 |              55000 |              64999 | Upper    |         54109.2 |             Inf |  9999.0 |  1.0000000 |
| Kenosha | Male   | FALSE     |    46 |              65000 |              74999 | Upper    |         54109.2 |             Inf |  9999.0 |  1.0000000 |
| Kenosha | Male   | FALSE     |    47 |              75000 |              99999 | Upper    |         54109.2 |             Inf | 24999.0 |  1.0000000 |
| Kenosha | Male   | FALSE     |    48 |             100000 |                Inf | Upper    |         54109.2 |             Inf |     Inf |  1.0000000 |
| Kenosha | Female | TRUE      |    53 |                  1 |               2499 | Low      |             0.0 |         22545.5 |  2498.0 |  1.0000000 |
| Kenosha | Female | TRUE      |    54 |               2500 |               4999 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Female | TRUE      |    55 |               5000 |               7499 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Female | TRUE      |    56 |               7500 |               9999 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Female | TRUE      |    57 |              10000 |              12499 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Female | TRUE      |    58 |              12500 |              14999 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Female | TRUE      |    59 |              15000 |              17499 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Female | TRUE      |    60 |              17500 |              19999 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Female | TRUE      |    61 |              20000 |              22499 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Female | TRUE      |    62 |              22500 |              24999 | Low      |             0.0 |         22545.5 |    45.5 |  0.0182073 |
| Kenosha | Female | TRUE      |    62 |              22500 |              24999 | Moderate |         22545.5 |         36072.8 |  2453.5 |  0.9817927 |
| Kenosha | Female | TRUE      |    63 |              25000 |              29999 | Moderate |         22545.5 |         36072.8 |  4999.0 |  1.0000000 |
| Kenosha | Female | TRUE      |    64 |              30000 |              34999 | Moderate |         22545.5 |         36072.8 |  4999.0 |  1.0000000 |
| Kenosha | Female | TRUE      |    65 |              35000 |              39999 | Moderate |         22545.5 |         36072.8 |  1072.8 |  0.2146029 |
| Kenosha | Female | TRUE      |    65 |              35000 |              39999 | Middle   |         36072.8 |         54109.2 |  3926.2 |  0.7853971 |
| Kenosha | Female | TRUE      |    66 |              40000 |              44999 | Middle   |         36072.8 |         54109.2 |  4999.0 |  1.0000000 |
| Kenosha | Female | TRUE      |    67 |              45000 |              49999 | Middle   |         36072.8 |         54109.2 |  4999.0 |  1.0000000 |
| Kenosha | Female | TRUE      |    68 |              50000 |              54999 | Middle   |         36072.8 |         54109.2 |  4109.2 |  0.8220044 |
| Kenosha | Female | TRUE      |    68 |              50000 |              54999 | Upper    |         54109.2 |             Inf |   889.8 |  0.1779956 |
| Kenosha | Female | TRUE      |    69 |              55000 |              64999 | Upper    |         54109.2 |             Inf |  9999.0 |  1.0000000 |
| Kenosha | Female | TRUE      |    70 |              65000 |              74999 | Upper    |         54109.2 |             Inf |  9999.0 |  1.0000000 |
| Kenosha | Female | TRUE      |    71 |              75000 |              99999 | Upper    |         54109.2 |             Inf | 24999.0 |  1.0000000 |
| Kenosha | Female | TRUE      |    72 |             100000 |                Inf | Upper    |         54109.2 |             Inf |     Inf |  1.0000000 |
| Kenosha | Female | FALSE     |    76 |                  1 |               2499 | Low      |             0.0 |         22545.5 |  2498.0 |  1.0000000 |
| Kenosha | Female | FALSE     |    77 |               2500 |               4999 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Female | FALSE     |    78 |               5000 |               7499 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Female | FALSE     |    79 |               7500 |               9999 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Female | FALSE     |    80 |              10000 |              12499 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Female | FALSE     |    81 |              12500 |              14999 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Female | FALSE     |    82 |              15000 |              17499 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Female | FALSE     |    83 |              17500 |              19999 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Female | FALSE     |    84 |              20000 |              22499 | Low      |             0.0 |         22545.5 |  2499.0 |  1.0000000 |
| Kenosha | Female | FALSE     |    85 |              22500 |              24999 | Low      |             0.0 |         22545.5 |    45.5 |  0.0182073 |
| Kenosha | Female | FALSE     |    85 |              22500 |              24999 | Moderate |         22545.5 |         36072.8 |  2453.5 |  0.9817927 |
| Kenosha | Female | FALSE     |    86 |              25000 |              29999 | Moderate |         22545.5 |         36072.8 |  4999.0 |  1.0000000 |
| Kenosha | Female | FALSE     |    87 |              30000 |              34999 | Moderate |         22545.5 |         36072.8 |  4999.0 |  1.0000000 |
| Kenosha | Female | FALSE     |    88 |              35000 |              39999 | Moderate |         22545.5 |         36072.8 |  1072.8 |  0.2146029 |
| Kenosha | Female | FALSE     |    88 |              35000 |              39999 | Middle   |         36072.8 |         54109.2 |  3926.2 |  0.7853971 |
| Kenosha | Female | FALSE     |    89 |              40000 |              44999 | Middle   |         36072.8 |         54109.2 |  4999.0 |  1.0000000 |
| Kenosha | Female | FALSE     |    90 |              45000 |              49999 | Middle   |         36072.8 |         54109.2 |  4999.0 |  1.0000000 |
| Kenosha | Female | FALSE     |    91 |              50000 |              54999 | Middle   |         36072.8 |         54109.2 |  4109.2 |  0.8220044 |
| Kenosha | Female | FALSE     |    91 |              50000 |              54999 | Upper    |         54109.2 |             Inf |   889.8 |  0.1779956 |
| Kenosha | Female | FALSE     |    92 |              55000 |              64999 | Upper    |         54109.2 |             Inf |  9999.0 |  1.0000000 |
| Kenosha | Female | FALSE     |    93 |              65000 |              74999 | Upper    |         54109.2 |             Inf |  9999.0 |  1.0000000 |
| Kenosha | Female | FALSE     |    94 |              75000 |              99999 | Upper    |         54109.2 |             Inf | 24999.0 |  1.0000000 |
| Kenosha | Female | FALSE     |    95 |             100000 |                Inf | Upper    |         54109.2 |             Inf |     Inf |  1.0000000 |
| Racine  | Male   | TRUE      |     6 |                  1 |               2499 | Low      |             0.0 |         21566.5 |  2498.0 |  1.0000000 |
| Racine  | Male   | TRUE      |     7 |               2500 |               4999 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Male   | TRUE      |     8 |               5000 |               7499 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Male   | TRUE      |     9 |               7500 |               9999 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Male   | TRUE      |    10 |              10000 |              12499 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Male   | TRUE      |    11 |              12500 |              14999 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Male   | TRUE      |    12 |              15000 |              17499 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Male   | TRUE      |    13 |              17500 |              19999 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Male   | TRUE      |    14 |              20000 |              22499 | Low      |             0.0 |         21566.5 |  1566.5 |  0.6268507 |
| Racine  | Male   | TRUE      |    14 |              20000 |              22499 | Moderate |         21566.5 |         34506.4 |   932.5 |  0.3731493 |
| Racine  | Male   | TRUE      |    15 |              22500 |              24999 | Moderate |         21566.5 |         34506.4 |  2499.0 |  1.0000000 |
| Racine  | Male   | TRUE      |    16 |              25000 |              29999 | Moderate |         21566.5 |         34506.4 |  4999.0 |  1.0000000 |
| Racine  | Male   | TRUE      |    17 |              30000 |              34999 | Moderate |         21566.5 |         34506.4 |  4506.4 |  0.9014603 |
| Racine  | Male   | TRUE      |    17 |              30000 |              34999 | Middle   |         34506.4 |         51759.6 |   492.6 |  0.0985397 |
| Racine  | Male   | TRUE      |    18 |              35000 |              39999 | Middle   |         34506.4 |         51759.6 |  4999.0 |  1.0000000 |
| Racine  | Male   | TRUE      |    19 |              40000 |              44999 | Middle   |         34506.4 |         51759.6 |  4999.0 |  1.0000000 |
| Racine  | Male   | TRUE      |    20 |              45000 |              49999 | Middle   |         34506.4 |         51759.6 |  4999.0 |  1.0000000 |
| Racine  | Male   | TRUE      |    21 |              50000 |              54999 | Middle   |         34506.4 |         51759.6 |  1759.6 |  0.3519904 |
| Racine  | Male   | TRUE      |    21 |              50000 |              54999 | Upper    |         51759.6 |             Inf |  3239.4 |  0.6480096 |
| Racine  | Male   | TRUE      |    22 |              55000 |              64999 | Upper    |         51759.6 |             Inf |  9999.0 |  1.0000000 |
| Racine  | Male   | TRUE      |    23 |              65000 |              74999 | Upper    |         51759.6 |             Inf |  9999.0 |  1.0000000 |
| Racine  | Male   | TRUE      |    24 |              75000 |              99999 | Upper    |         51759.6 |             Inf | 24999.0 |  1.0000000 |
| Racine  | Male   | TRUE      |    25 |             100000 |                Inf | Upper    |         51759.6 |             Inf |     Inf |  1.0000000 |
| Racine  | Male   | FALSE     |    29 |                  1 |               2499 | Low      |             0.0 |         21566.5 |  2498.0 |  1.0000000 |
| Racine  | Male   | FALSE     |    30 |               2500 |               4999 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Male   | FALSE     |    31 |               5000 |               7499 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Male   | FALSE     |    32 |               7500 |               9999 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Male   | FALSE     |    33 |              10000 |              12499 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Male   | FALSE     |    34 |              12500 |              14999 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Male   | FALSE     |    35 |              15000 |              17499 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Male   | FALSE     |    36 |              17500 |              19999 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Male   | FALSE     |    37 |              20000 |              22499 | Low      |             0.0 |         21566.5 |  1566.5 |  0.6268507 |
| Racine  | Male   | FALSE     |    37 |              20000 |              22499 | Moderate |         21566.5 |         34506.4 |   932.5 |  0.3731493 |
| Racine  | Male   | FALSE     |    38 |              22500 |              24999 | Moderate |         21566.5 |         34506.4 |  2499.0 |  1.0000000 |
| Racine  | Male   | FALSE     |    39 |              25000 |              29999 | Moderate |         21566.5 |         34506.4 |  4999.0 |  1.0000000 |
| Racine  | Male   | FALSE     |    40 |              30000 |              34999 | Moderate |         21566.5 |         34506.4 |  4506.4 |  0.9014603 |
| Racine  | Male   | FALSE     |    40 |              30000 |              34999 | Middle   |         34506.4 |         51759.6 |   492.6 |  0.0985397 |
| Racine  | Male   | FALSE     |    41 |              35000 |              39999 | Middle   |         34506.4 |         51759.6 |  4999.0 |  1.0000000 |
| Racine  | Male   | FALSE     |    42 |              40000 |              44999 | Middle   |         34506.4 |         51759.6 |  4999.0 |  1.0000000 |
| Racine  | Male   | FALSE     |    43 |              45000 |              49999 | Middle   |         34506.4 |         51759.6 |  4999.0 |  1.0000000 |
| Racine  | Male   | FALSE     |    44 |              50000 |              54999 | Middle   |         34506.4 |         51759.6 |  1759.6 |  0.3519904 |
| Racine  | Male   | FALSE     |    44 |              50000 |              54999 | Upper    |         51759.6 |             Inf |  3239.4 |  0.6480096 |
| Racine  | Male   | FALSE     |    45 |              55000 |              64999 | Upper    |         51759.6 |             Inf |  9999.0 |  1.0000000 |
| Racine  | Male   | FALSE     |    46 |              65000 |              74999 | Upper    |         51759.6 |             Inf |  9999.0 |  1.0000000 |
| Racine  | Male   | FALSE     |    47 |              75000 |              99999 | Upper    |         51759.6 |             Inf | 24999.0 |  1.0000000 |
| Racine  | Male   | FALSE     |    48 |             100000 |                Inf | Upper    |         51759.6 |             Inf |     Inf |  1.0000000 |
| Racine  | Female | TRUE      |    53 |                  1 |               2499 | Low      |             0.0 |         21566.5 |  2498.0 |  1.0000000 |
| Racine  | Female | TRUE      |    54 |               2500 |               4999 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Female | TRUE      |    55 |               5000 |               7499 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Female | TRUE      |    56 |               7500 |               9999 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Female | TRUE      |    57 |              10000 |              12499 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Female | TRUE      |    58 |              12500 |              14999 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Female | TRUE      |    59 |              15000 |              17499 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Female | TRUE      |    60 |              17500 |              19999 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Female | TRUE      |    61 |              20000 |              22499 | Low      |             0.0 |         21566.5 |  1566.5 |  0.6268507 |
| Racine  | Female | TRUE      |    61 |              20000 |              22499 | Moderate |         21566.5 |         34506.4 |   932.5 |  0.3731493 |
| Racine  | Female | TRUE      |    62 |              22500 |              24999 | Moderate |         21566.5 |         34506.4 |  2499.0 |  1.0000000 |
| Racine  | Female | TRUE      |    63 |              25000 |              29999 | Moderate |         21566.5 |         34506.4 |  4999.0 |  1.0000000 |
| Racine  | Female | TRUE      |    64 |              30000 |              34999 | Moderate |         21566.5 |         34506.4 |  4506.4 |  0.9014603 |
| Racine  | Female | TRUE      |    64 |              30000 |              34999 | Middle   |         34506.4 |         51759.6 |   492.6 |  0.0985397 |
| Racine  | Female | TRUE      |    65 |              35000 |              39999 | Middle   |         34506.4 |         51759.6 |  4999.0 |  1.0000000 |
| Racine  | Female | TRUE      |    66 |              40000 |              44999 | Middle   |         34506.4 |         51759.6 |  4999.0 |  1.0000000 |
| Racine  | Female | TRUE      |    67 |              45000 |              49999 | Middle   |         34506.4 |         51759.6 |  4999.0 |  1.0000000 |
| Racine  | Female | TRUE      |    68 |              50000 |              54999 | Middle   |         34506.4 |         51759.6 |  1759.6 |  0.3519904 |
| Racine  | Female | TRUE      |    68 |              50000 |              54999 | Upper    |         51759.6 |             Inf |  3239.4 |  0.6480096 |
| Racine  | Female | TRUE      |    69 |              55000 |              64999 | Upper    |         51759.6 |             Inf |  9999.0 |  1.0000000 |
| Racine  | Female | TRUE      |    70 |              65000 |              74999 | Upper    |         51759.6 |             Inf |  9999.0 |  1.0000000 |
| Racine  | Female | TRUE      |    71 |              75000 |              99999 | Upper    |         51759.6 |             Inf | 24999.0 |  1.0000000 |
| Racine  | Female | TRUE      |    72 |             100000 |                Inf | Upper    |         51759.6 |             Inf |     Inf |  1.0000000 |
| Racine  | Female | FALSE     |    76 |                  1 |               2499 | Low      |             0.0 |         21566.5 |  2498.0 |  1.0000000 |
| Racine  | Female | FALSE     |    77 |               2500 |               4999 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Female | FALSE     |    78 |               5000 |               7499 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Female | FALSE     |    79 |               7500 |               9999 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Female | FALSE     |    80 |              10000 |              12499 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Female | FALSE     |    81 |              12500 |              14999 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Female | FALSE     |    82 |              15000 |              17499 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Female | FALSE     |    83 |              17500 |              19999 | Low      |             0.0 |         21566.5 |  2499.0 |  1.0000000 |
| Racine  | Female | FALSE     |    84 |              20000 |              22499 | Low      |             0.0 |         21566.5 |  1566.5 |  0.6268507 |
| Racine  | Female | FALSE     |    84 |              20000 |              22499 | Moderate |         21566.5 |         34506.4 |   932.5 |  0.3731493 |
| Racine  | Female | FALSE     |    85 |              22500 |              24999 | Moderate |         21566.5 |         34506.4 |  2499.0 |  1.0000000 |
| Racine  | Female | FALSE     |    86 |              25000 |              29999 | Moderate |         21566.5 |         34506.4 |  4999.0 |  1.0000000 |
| Racine  | Female | FALSE     |    87 |              30000 |              34999 | Moderate |         21566.5 |         34506.4 |  4506.4 |  0.9014603 |
| Racine  | Female | FALSE     |    87 |              30000 |              34999 | Middle   |         34506.4 |         51759.6 |   492.6 |  0.0985397 |
| Racine  | Female | FALSE     |    88 |              35000 |              39999 | Middle   |         34506.4 |         51759.6 |  4999.0 |  1.0000000 |
| Racine  | Female | FALSE     |    89 |              40000 |              44999 | Middle   |         34506.4 |         51759.6 |  4999.0 |  1.0000000 |
| Racine  | Female | FALSE     |    90 |              45000 |              49999 | Middle   |         34506.4 |         51759.6 |  4999.0 |  1.0000000 |
| Racine  | Female | FALSE     |    91 |              50000 |              54999 | Middle   |         34506.4 |         51759.6 |  1759.6 |  0.3519904 |
| Racine  | Female | FALSE     |    91 |              50000 |              54999 | Upper    |         51759.6 |             Inf |  3239.4 |  0.6480096 |
| Racine  | Female | FALSE     |    92 |              55000 |              64999 | Upper    |         51759.6 |             Inf |  9999.0 |  1.0000000 |
| Racine  | Female | FALSE     |    93 |              65000 |              74999 | Upper    |         51759.6 |             Inf |  9999.0 |  1.0000000 |
| Racine  | Female | FALSE     |    94 |              75000 |              99999 | Upper    |         51759.6 |             Inf | 24999.0 |  1.0000000 |
| Racine  | Female | FALSE     |    95 |             100000 |                Inf | Upper    |         51759.6 |             Inf |     Inf |  1.0000000 |
