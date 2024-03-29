% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_metadata_helpers.R
\name{metadata-helpers}
\alias{metadata-helpers}
\alias{get_categories}
\alias{get_category_combos}
\alias{get_category_option_combos}
\alias{get_category_option_group_sets}
\alias{get_category_option_groups}
\alias{get_category_options}
\alias{get_data_element_group_sets}
\alias{get_data_element_groups}
\alias{get_data_elements}
\alias{get_data_sets}
\alias{get_user_groups}
\alias{get_indicator_group_sets}
\alias{get_indicator_groups}
\alias{get_indicators}
\alias{get_option_group_sets}
\alias{get_option_groups}
\alias{get_option_sets}
\alias{get_options}
\alias{get_organisation_unit_groupsets}
\alias{get_organisation_unit_groups}
\alias{get_organisation_units}
\alias{get_dimensions}
\alias{get_period_types}
\title{Metadata Helper Functions}
\usage{
get_categories(..., fields = c("id", "name"))

get_category_combos(..., fields = c("id", "name"))

get_category_option_combos(..., fields = c("id", "name"))

get_category_option_group_sets(..., fields = c("id", "name"))

get_category_option_groups(..., fields = c("id", "name"))

get_category_options(..., fields = c("id", "name"))

get_data_element_group_sets(..., fields = c("id", "name"))

get_data_element_groups(..., fields = c("id", "name"))

get_data_elements(..., fields = c("id", "name"))

get_data_sets(..., fields = c("id", "name"))

get_user_groups(..., fields = c("id", "name"))

get_indicator_group_sets(..., fields = c("id", "name"))

get_indicator_groups(..., fields = c("id", "name"))

get_indicators(..., fields = c("id", "name"))

get_option_group_sets(..., fields = c("id", "name"))

get_option_groups(..., fields = c("id", "name"))

get_option_sets(..., fields = c("id", "name"))

get_options(..., fields = c("id", "name"))

get_organisation_unit_groupsets(..., fields = c("id", "name"))

get_organisation_unit_groups(..., fields = c("id", "name"))

get_organisation_units(..., fields = c("id", "name"))

get_dimensions(..., fields = c("id", "name"))

get_period_types(..., fields = c("id", "name"))
}
\arguments{
\item{...}{
  Arguments passed on to \code{\link[=get_metadata]{get_metadata}}
  \describe{
    \item{\code{retry}}{Number of times to retry the API call in case of failure
(defaults to 2).}
    \item{\code{verbosity}}{Level of HTTP information to print during the call:
\itemize{
\item 0: No output
\item 1: Show headers
\item 2: Show headers and bodies
\item 3: Show headers, bodies, and CURL status message.
}}
    \item{\code{timeout}}{Maximum number of seconds to wait for the API response.}
  }}

\item{fields}{The specific columns to be returned in the tibble.}
}
\value{
A tibble with the KHIS metadata response.
}
\description{
Wrappers for \code{\link[=get_metadata]{get_metadata()}} that retrieves data from a specific KHIS API endpoint.
}
\examples{
\dontshow{if (khis_has_cred()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}

# Get all organisation units
get_organisation_units()

# Get all data elements
get_data_elements()

# Get data elements by element ids
get_data_elements(id \%.in\% c('VR7vdS7P0Gb', 'gQro1y7Rsbq'))

# Get datasets by name with the word 'MOH 705'
get_data_sets(name \%.like\% 'MOH 705')
\dontshow{\}) # examplesIf}
}
