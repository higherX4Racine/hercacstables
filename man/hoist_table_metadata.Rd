% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hoist_table_metadata.R
\name{hoist_table_metadata}
\alias{hoist_table_metadata}
\title{Hoist details about a Census data group from a list of strings to separate columns}
\usage{
hoist_table_metadata(.metadata, .group, .fields)
}
\arguments{
\item{.metadata}{\if{html}{\out{<data-frame>}} a table of metadata about Census API variables, e.g. \code{hercacstables::METADATA_ACS5$variables}}

\item{.group}{\if{html}{\out{<chr>}} the code for the group, e.g. "B01001"}

\item{.fields}{<chr[]> names for the new columns, e.g. c("Sex", "Age")}
}
\value{
a new data frame with more columns
}
\description{
Hoist details about a Census data group from a list of strings to separate columns
}
\examples{
hoist_table_metadata(METADATA_ACS5$variables, "B06002", c("Median age", "Place of birth"))
}
\concept{metadata}
