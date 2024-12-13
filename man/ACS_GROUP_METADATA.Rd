% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{ACS_GROUP_METADATA}
\alias{ACS_GROUP_METADATA}
\title{Details about the groups in the most recent American Community Series}
\format{
A list with three items
\describe{
\item{Group}{The code for the group, such as "B01001B" or "B25063"}
\item{Universe}{The population the data describe, such as "People who are Black or African American alone" or "Renter-occupied housing units"}
\item{Description}{Details about what the table actually reports, such as "Sex by Age (Black or African American Alone)" and "Gross Rent."}
\item{ACS1}{Whether this group is available in the most recent 1-year dataset.}
\item{ACS5}{Whether this group is available in the most recent 5-year dataset.}
}
}
\usage{
ACS_GROUP_METADATA
}
\description{
In the context of ACS data, a "group" is what you would get from running a
query about a specific topic. For example, group B01001B reports population
numbers by sex and age, and group B25063 reports the number of housing units
in different rent brackets.
}
\concept{metadata}
\keyword{datasets}
