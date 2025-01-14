% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/search_in_columns.R
\name{search_in_columns}
\alias{search_in_columns}
\title{Search for terms in a glossary in case-insensitive ways}
\usage{
search_in_columns(.dataframe, ...)
}
\arguments{
\item{.dataframe}{\if{html}{\out{<dfr>}} the table to search in}

\item{...}{<\link[rlang:dyn-dots]{rlang::dyn-dots}> Named arrays of search terms.}
}
\value{
<dfr> a filtered version of \code{.dataframe}
}
\description{
Each of the dynamic arguments to this function must be a named array of
strings.
The function will look for each string in the column of \code{.dataframe} that
corresponds to the argument's name. For example, providing the argument
\code{Universe = c("Wom[ae]n", "years?")} will search the "Universe" column for
any elements that include both "women"  or "woman" and "year" or "years".
The search is NOT case-sensitive.
You can also exclude patterns by prefacing the column name with "-".
For example, the argument \code{"-Universe" = "household"} will exclude rows
where the "Universe" column contains the string "household".
}
\examples{
hercacstables::search_in_columns(
  hercacstables::METADATA_FOR_ACS_GEOGRAPHIES,
  `Wildcard Option` = "."
)
hercacstables::search_in_columns(
  hercacstables::METADATA_FOR_ACS_GEOGRAPHIES,
  `-Wildcard Option` = "."
)
}
