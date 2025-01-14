% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{GLOSSARY_OF_CHILDREN_IN_POVERTY}
\alias{GLOSSARY_OF_CHILDREN_IN_POVERTY}
\title{Categorize ACS variables about children living in poverty and parents' birth origins}
\format{
\subsection{GLOSSARY_OF_CHILDREN_IN_POVERTY}{

A data frame with 15 rows and 8 columns
\describe{
\item{Group}{<chr> The table, always "B05010"}
\item{Variable}{<chr> The full variable name, e.g. "B05010_001E"}
\item{Index}{<int> The row of this variable in the table}
\item{Least Poverty Ratio}{<dbl> The lowest ratio of income to poverty level in this tier}
\item{Greatest Poverty Ratio}{<dbl> The highest ratio of income to poverty level in this tier}
\item{Standard of Living}{<chr> One of "Unsustainable," or "Mixed"}
\item{Native-born Parents}{<int> How many of the parents in the household were born in the USA.}
\item{Foreign-born Parents}{<int> How many of the parents in the household were not born in the USA.}
}
}
}
\source{
https://api.census.gov/data/2022/acs/acs1/groups/B05010.html
}
\usage{
GLOSSARY_OF_CHILDREN_IN_POVERTY
}
\description{
These data come from table B05010, "RATIO OF INCOME TO POVERTY LEVEL IN THE
PAST 12 MONTHS BY NATIVITY OF CHILDREN UNDER 18 YEARS IN FAMILIES AND
SUBFAMILIES BY LIVING ARRANGEMENTS AND NATIVITY OF PARENTS."
}
\keyword{datasets}
