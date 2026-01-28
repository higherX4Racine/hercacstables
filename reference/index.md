# Package index

## Key functions and data tables

you will call these to get American Community Survey data

### Getting data from the API

These functions deal with technical aspects of accessing the Census API

- [`fetch_data()`](https://higherx4racine.github.io/hercacstables/reference/fetch_data.md)
  : Download a set of data from the US Census API
- [`fetch_decennial_pops_by_race()`](https://higherx4racine.github.io/hercacstables/reference/fetch_decennial_pops_by_race.md)
  : Get decennial census estimates of per-block populations by
  race/ethnicity

### The contents of the API

These functions and tables will help you to look up information about
which Census tables store which information.

- [`search_in_columns()`](https://higherx4racine.github.io/hercacstables/reference/search_in_columns.md)
  : Search for terms in a glossary in case-insensitive ways
- [`unpack_group_details()`](https://higherx4racine.github.io/hercacstables/reference/unpack_group_details.md)
  : Pull apart the lists of details for one group of ACS data
- [`METADATA_FOR_ACS_GROUPS`](https://higherx4racine.github.io/hercacstables/reference/METADATA_FOR_ACS_GROUPS.md)
  : Details about the groups in the most recent American Community
  Series
- [`METADATA_FOR_ACS_VARIABLES`](https://higherx4racine.github.io/hercacstables/reference/METADATA_FOR_ACS_VARIABLES.md)
  : Details about variables in the most recent American Community Series
- [`METADATA_FOR_ACS_GEOGRAPHIES`](https://higherx4racine.github.io/hercacstables/reference/METADATA_FOR_ACS_GEOGRAPHIES.md)
  : Details about levels of geographic detail in the most recent
  American Community Series
- [`DECENNIAL_POPULATION_FIELDS`](https://higherx4racine.github.io/hercacstables/reference/DECENNIAL_POPULATION_FIELDS.md)
  : Variables from the Decennial censuses
- [`GEOGRAPHY_HIERARCHY_METADATA`](https://higherx4racine.github.io/hercacstables/reference/GEOGRAPHY_HIERARCHY_METADATA.md)
  : Geographic levels of organization for data from the US Census
  Bureau's API
- [`RACE_ETHNICITY_SUBTABLES`](https://higherx4racine.github.io/hercacstables/reference/RACE_ETHNICITY_SUBTABLES.md)
  : Race and ethnicity codes and labels used by the U.S. Census Bureau

## Useful descriptions of what is available

These tables connect real-world meanings to the table-name-row-number
codes that you need to pull data from the Census API.

- [`GLOSSARY_OF_AGE_AND_SEX`](https://higherx4racine.github.io/hercacstables/reference/GLOSSARY_OF_AGE_AND_SEX.md)
  :

  The fundamental demographics of age and sex from tables `B01001[ A-H]`

- [`GLOSSARY_OF_SEX_BY_INCOME`](https://higherx4racine.github.io/hercacstables/reference/GLOSSARY_OF_SEX_BY_INCOME.md)
  : Counts of people in income brackets, by sex and employment status.

### Families

- [`GLOSSARY_OF_CHILDREN_IN_POVERTY`](https://higherx4racine.github.io/hercacstables/reference/GLOSSARY_OF_CHILDREN_IN_POVERTY.md)
  : Categorize ACS variables about children living in poverty and
  parents' birth origins
- [`GLOSSARY_OF_CHILDREN_PER_FAMILY`](https://higherx4racine.github.io/hercacstables/reference/GLOSSARY_OF_CHILDREN_PER_FAMILY.md)
  : Categorize ACS variables about children per family
- [`GLOSSARY_OF_FAMILIES_WITH_CHILDREN`](https://higherx4racine.github.io/hercacstables/reference/GLOSSARY_OF_FAMILIES_WITH_CHILDREN.md)
  : Categorize ACS variables counting families by number of children

### Education

- [`EDUCATIONAL_ATTAINMENT_LEVELS`](https://higherx4racine.github.io/hercacstables/reference/EDUCATIONAL_ATTAINMENT_LEVELS.md)
  : Census labels for different levels of educational achievement
- [`GLOSSARY_OF_EDUCATIONAL_ATTAINMENT`](https://higherx4racine.github.io/hercacstables/reference/GLOSSARY_OF_EDUCATIONAL_ATTAINMENT.md)
  : Census variables for different levels of educational achievement

### Sustainable Income

- [`GLOSSARY_OF_EMPLOYMENT_STATUS`](https://higherx4racine.github.io/hercacstables/reference/GLOSSARY_OF_EMPLOYMENT_STATUS.md)
  : Factor values associated with specific rows within
  employment-related ACS tables
- [`GLOSSARY_OF_STANDARD_OF_LIVING`](https://higherx4racine.github.io/hercacstables/reference/GLOSSARY_OF_STANDARD_OF_LIVING.md)
  : Categorize ACS variables about income : poverty level ratios by
  family sustainability
- [`GLOSSARY_OF_LABOR_FORCE_PARTICIPATION`](https://higherx4racine.github.io/hercacstables/reference/GLOSSARY_OF_LABOR_FORCE_PARTICIPATION.md)
  : ACS data on sex, age, and labor force status

## Utilities

Functions that a typical user won’t need to bother with, but might be
useful for someone working to extend the capabilities of the package.

### Constructing API calls

These functions deal with technical aspects of accessing the Census API

- [`build_api_variable()`](https://higherx4racine.github.io/hercacstables/reference/build_api_variable.md)
  : Vectorized Creation of Census ACS Variables
- [`build_api_url()`](https://higherx4racine.github.io/hercacstables/reference/build_api_url.md)
  : Create an API call to send to api.census.gov

### Codes and data structures in the API

Glossary about abbreviations, codes, and other arcane shorthand that
appear in the Census API.

- [`TYPES_OF_TABLE`](https://higherx4racine.github.io/hercacstables/reference/TYPES_OF_TABLE.md)
  : A Census table's ID always starts with an alphanumeric code for its
  type.
- [`TYPES_OF_SUBJECT`](https://higherx4racine.github.io/hercacstables/reference/TYPES_OF_SUBJECT.md)
  : A code for the broad subject that a Census table covers.
- [`TYPES_OF_RACE_OR_ETHNICITY`](https://higherx4racine.github.io/hercacstables/reference/TYPES_OF_RACE_OR_ETHNICITY.md)
  : For selected tables, an alphabetic suffix follows to indicate that a
  table is repeated for the nine major race and Hispanic or Latino
  groups:
- [`TYPES_OF_VARIABLE`](https://higherx4racine.github.io/hercacstables/reference/TYPES_OF_VARIABLE.md)
  : ACS data contain variables ending in 1- or 2-letter codes.

### API key

These functions manage a key that the Census API uses to keep track of
users.

- [`api_key_is_set()`](https://higherx4racine.github.io/hercacstables/reference/api_key_is_set.md)
  : Check if the local environment contains an expected constant
  defining an API key
- [`api_key_setup()`](https://higherx4racine.github.io/hercacstables/reference/api_key_setup.md)
  : Guide a new user at setting up a Census API key
- [`api_key_value()`](https://higherx4racine.github.io/hercacstables/reference/api_key_value.md)
  : Get the current value of the local Census API key

### Miscellaneous

Other functions, usually legacy ones, that might help with things

- [`subtract_parts_from_whole()`](https://higherx4racine.github.io/hercacstables/reference/subtract_parts_from_whole.md)
  : Computes a remainder values from measures of some subgroups and one
  all-group
- [`the_year_right_now()`](https://higherx4racine.github.io/hercacstables/reference/the_year_right_now.md)
  : Today's year in the Gregorian calendar.

### Keeping the glossaries up-to-date

Functions for updating the glossary tables, generally functions that
only the package maintainers should run when the Census updates the ACS.
The logic of these functions might be helpful to someone who is looking
to better understand how the API works, though.

- [`build_info_url()`](https://higherx4racine.github.io/hercacstables/reference/build_info_url.md)
  : Get the URL for JSON glossary about one table of ACS data
- [`most_recent_vintage()`](https://higherx4racine.github.io/hercacstables/reference/most_recent_vintage.md)
  : Query the Census API for the most recent release year of a dataset.
- [`latest_acs_metadata()`](https://higherx4racine.github.io/hercacstables/reference/latest_acs_metadata.md)
  : Download glossary about the most recent versions of the 1- and
  5-year ACS
- [`fetch_metadata_table()`](https://higherx4racine.github.io/hercacstables/reference/fetch_metadata_table.md)
  : Fetch glossary about a specific ACS data set from the Census API.
- [`hoist_table_glossary()`](https://higherx4racine.github.io/hercacstables/reference/hoist_table_glossary.md)
  : Hoist details about a Census data group from a list of strings to
  separate columns
