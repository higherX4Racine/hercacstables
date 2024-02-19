# Date: 10/24/2023
# Author: Amani Abou Harb
# Purpose: Create a table with employment data for people ages 18-24 in the city
# of Oakland for the years 2018-2023 disaggregated by race and income

# install.packages("tidycensus") #run once to install tidycensus if not installed
rm(list=ls())
library(tidycensus)
library(tidyverse)
library(writexl)
setwd("C:/Users/amani/Documents/get_counts/Data/ACS data") # modify working directory as needed
# census_api_key("REDACTED", install = TRUE)


# get income data for all races in oakland city using ac5 data (table B19037) for years 2018-2021

get_allincome_data <- function(year) {
  all_income <- get_acs(
    geography = "place",
    table = "B19037",
    state = "CA",
    survey = "acs5",
    year = year,
    cache_table = TRUE
  )
  #save wanted variables
  wanted_variables_all <- c("B19037_019", paste0("B19037_0", 29:35))
  #select only wanted variables
  all_income <- all_income %>%
    filter(NAME == "Oakland city, California") %>%
    filter(variable %in% wanted_variables_all)
  # Calculate numerator : sum of estimate for age group 25-44, for values of income 50k and above
  numerator <- all_income %>%
    filter(variable %in% paste0("B19037_0", 29:35)) %>%
    summarize(numerator = sum(estimate)) %>%
    pull(numerator)

  # Calculate denominator : population of age group 25-44 regardless of income
  denominator <- all_income %>%
    filter(variable == "B19037_019") %>%
    pull(estimate)

  # Return a data frame with the year, numerator, and denominator
  return(data.frame(
    year = year,
    race = "All",
    numerator = numerator,
    denominator = denominator
  ))
}
# Do the same thing for Whites
get_white_income_data <- function(year) {
  white_income <- get_acs(
    geography = "place",
    table = "B19037A",
    state = "CA",
    survey = "acs5",
    year = year,
    cache_table = TRUE
  )
  wanted_variables_white <- c("B19037A_019", paste0("B19037A_0", 29:35))

  white_income <- white_income %>%
    filter(NAME == "Oakland city, California") %>%
    filter(variable %in% wanted_variables_white)
  # Calculate numerator
  white_numerator <- white_income %>%
    filter(variable %in% paste0("B19037A_0", 29:35)) %>%
    summarize(numerator = sum(estimate)) %>%
    pull(numerator)

  # Calculate denominator
  white_denominator <- white_income %>%
    filter(variable == "B19037A_019") %>%
    pull(estimate)

  # Return a data frame with the year, numerator, and denominator
 return(data.frame(
    year = year,
    race = "White",
    numerator = white_numerator,
    denominator = white_denominator
  ))
}


# do the same thing for Asians
get_asian_income_data <- function(year) {
  asian_income <- get_acs(
    geography = "place",
    table = "B19037D",
    state = "CA",
    survey = "acs5",
    year = year,
    cache_table = TRUE
  )
  wanted_variables_asian <- c("B19037D_019", paste0("B19037D_0", 29:35))

  asian_income <- asian_income %>%
    filter(NAME == "Oakland city, California") %>%
    filter(variable %in% wanted_variables_asian)
  # Calculate numerator
  asian_numerator <- asian_income %>%
    filter(variable %in% paste0("B19037D_0", 29:35)) %>%
    summarize(numerator = sum(estimate)) %>%
    pull(numerator)

  # Calculate denominator
  asian_denominator <- asian_income %>%
    filter(variable == "B19037D_019") %>%
    pull(estimate)

  # Return a data frame with the year, numerator, and denominator
  return(data.frame(
    year = year,
    race = "Asian",
    numerator = asian_numerator,
    denominator = asian_denominator
  ))
}

# Do the same thing for Hispanic Data
get_hispanic_income_data <- function(year) {
  hispanic_income <- get_acs(
    geography = "place",
    table = "B19037I",
    state = "CA",
    survey = "acs5",
    year = year,
    cache_table = TRUE
  )
  wanted_variables_hispanic <- c("B19037I_019", paste0("B19037I_0", 29:35))

  hispanic_income <- hispanic_income %>%
    filter(NAME == "Oakland city, California") %>%
    filter(variable %in% wanted_variables_hispanic)
  # Calculate numerator
  hispanic_numerator <- hispanic_income %>%
    filter(variable %in% paste0("B19037I_0", 29:35)) %>%
    summarize(numerator = sum(estimate)) %>%
    pull(numerator)

  # Calculate denominator
  hispanic_denominator <- hispanic_income %>%
    filter(variable == "B19037I_019") %>%
    pull(estimate)

  # Return a data frame with the year, numerator, and denominator
  return(data.frame(
    year = year,
    race = "Hispanic",
    numerator = hispanic_numerator,
    denominator = hispanic_denominator
  ))
}

# Do the same thing for American Indian or Alaska Native

get_americanindianalaskan_income_data <- function(year) {
  americanindianalaskan_income <- get_acs(
    geography = "place",
    table = "B19037C",
    state = "CA",
    survey = "acs5",
    year = year,
    cache_table = TRUE
  )
  wanted_variables_americanindianalaskan <- c("B19037C_019", paste0("B19037C_0", 29:35))

  americanindianalaskan_income <- americanindianalaskan_income %>%
    filter(NAME == "Oakland city, California") %>%
    filter(variable %in% wanted_variables_americanindianalaskan)
  # Calculate numerator
  americanindianalaskan_numerator <- americanindianalaskan_income %>%
    filter(variable %in% paste0("B19037C_0", 29:35)) %>%
    summarize(numerator = sum(estimate)) %>%
    pull(numerator)

  # Calculate denominator
  americanindianalaskan_denominator <- americanindianalaskan_income %>%
    filter(variable == "B19037C_019") %>%
    pull(estimate)

  # Return a data frame with the year, numerator, and denominator
  return(data.frame(
    year = year,
    race = "Americanindianalaskan",
    numerator = americanindianalaskan_numerator,
    denominator = americanindianalaskan_denominator
  ))
}

# Do the same thing for Native Hawaiian or Pacific Islandar

get_nativehawaiianorpacificislander_income_data <- function(year) {
  nativehawaiianorpacificislander_income <- get_acs(
    geography = "place",
    table = "B19037E",
    state = "CA",
    survey = "acs5",
    year = year,
    cache_table = TRUE
  )
  wanted_variables_nativehawaiianorpacificislander <- c("B19037E_019", paste0("B19037E_0", 29:35))

  nativehawaiianorpacificislander_income <- nativehawaiianorpacificislander_income %>%
    filter(NAME == "Oakland city, California") %>%
    filter(variable %in% wanted_variables_nativehawaiianorpacificislander)
  # Calculate numerator
  nativehawaiianorpacificislander_numerator <- nativehawaiianorpacificislander_income %>%
    filter(variable %in% paste0("B19037E_0", 29:35)) %>%
    summarize(numerator = sum(estimate)) %>%
    pull(numerator)

  # Calculate denominator
  nativehawaiianorpacificislander_denominator <- nativehawaiianorpacificislander_income %>%
    filter(variable == "B19037E_019") %>%
    pull(estimate)

  # Return a data frame with the year, numerator, and denominator
  return(data.frame(
    year = year,
    race = "Nativehawaiianorpacificislander",
    numerator = nativehawaiianorpacificislander_numerator,
    denominator = nativehawaiianorpacificislander_denominator
  ))
}

#Do the same thing for Muliracial

get_multirace_income_data <- function(year) {
  multirace_income <- get_acs(
    geography = "place",
    table = "B19037G",
    state = "CA",
    survey = "acs5",
    year = year,
    cache_table = TRUE
  )
  wanted_variables_multirace <- c("B19037G_019", paste0("B19037G_0", 29:35))

  multirace_income <- multirace_income %>%
    filter(NAME == "Oakland city, California") %>%
    filter(variable %in% wanted_variables_multirace)
  # Calculate numerator
  multirace_numerator <- multirace_income %>%
    filter(variable %in% paste0("B19037G_0", 29:35)) %>%
    summarize(numerator = sum(estimate)) %>%
    pull(numerator)

  # Calculate denominator
  multirace_denominator <- multirace_income %>%
    filter(variable == "B19037G_019") %>%
    pull(estimate)

  # Return a data frame with the year, numerator, and denominator
  return(data.frame(
    year = year,
    race = "Multirace",
    numerator = multirace_numerator,
    denominator = multirace_denominator
  ))
}

# Do the same thing for Other race
get_otherrace_income_data <- function(year) {
  otherrace_income <- get_acs(
    geography = "place",
    table = "B19037F",
    state = "CA",
    survey = "acs5",
    year = year,
    cache_table = TRUE
  )
  wanted_variables_otherrace <- c("B19037F_019", paste0("B19037F_0", 29:35))

  otherrace_income <- otherrace_income %>%
    filter(NAME == "Oakland city, California") %>%
    filter(variable %in% wanted_variables_otherrace)
  # Calculate numerator
  otherrace_numerator <- otherrace_income %>%
    filter(variable %in% paste0("B19037F_0", 29:35)) %>%
    summarize(numerator = sum(estimate)) %>%
    pull(numerator)

  # Calculate denominator
  otherrace_denominator <- otherrace_income %>%
    filter(variable == "B19037F_019") %>%
    pull(estimate)

  # Return a data frame with the year, numerator, and denominator
  return(data.frame(
    year = year,
    race = "Otherrace",
    numerator = otherrace_numerator,
    denominator = otherrace_denominator
  ))
}

# Do the same thing for African Americans/Black

get_black_income_data <- function(year) {
  black_income <- get_acs(
    geography = "place",
    table = "B19037B",
    state = "CA",
    survey = "acs5",
    year = year,
    cache_table = TRUE
  )
  wanted_variables_black <- c("B19037B_019", paste0("B19037B_0", 29:35))

  black_income <- black_income %>%
    filter(NAME == "Oakland city, California") %>%
    filter(variable %in% wanted_variables_black)
  # Calculate numerator
  black_numerator <- black_income %>%
    filter(variable %in% paste0("B19037B_0", 29:35)) %>%
    summarize(numerator = sum(estimate)) %>%
    pull(numerator)

  # Calculate denominator
  black_denominator <- black_income %>%
    filter(variable == "B19037B_019") %>%
    pull(estimate)

  # Return a data frame with the year, numerator, and denominator
  return(data.frame(
    year = year,
    race = "Black",
    numerator = black_numerator,
    denominator = black_denominator
  ))
}

# call the function

years <- 2018:2021
white_data <- map_df(years, get_white_income_data)
all_data <- map_df(years, get_allincome_data)
asian_data <- map_df(years, get_asian_income_data)
hispanic_data <- map_df(years, get_hispanic_income_data)
americanindianalaska <-map_df(years, get_americanindianalaskan_income_data)
nativehawaiian <- map_df(years, get_nativehawaiianorpacificislander_income_data)
multirace <- map_df(years, get_multirace_income_data)
otherrace <- map_df(years, get_otherrace_income_data)
black <- map_df(years, get_black_income_data)

#merge the data into one table
strive_together_oakland_income_data <- bind_rows(white_data, all_data, asian_data, hispanic_data, americanindianalaska, nativehawaiian, multirace, otherrace, black)

#export to excel
write_xlsx(strive_together_oakland_income_data, "strive_together_employment.xlsx")
