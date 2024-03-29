% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/redcap-download-instrument.R
\name{redcap_download_instrument}
\alias{redcap_download_instrument}
\title{Download REDCap Instruments}
\usage{
redcap_download_instrument(
  file_name = NULL,
  directory = NULL,
  overwrite = FALSE,
  redcap_uri,
  token,
  record = character(0),
  instrument = "",
  event = "",
  verbose = TRUE,
  config_options = NULL
)
}
\arguments{
\item{file_name}{The name of the file where the downloaded pdf is saved.
Optional.}

\item{directory}{The directory where the file is saved. By default current
directory. Optional.}

\item{overwrite}{Boolean value indicating if existing files should be
overwritten. Optional.}

\item{redcap_uri}{The URI (uniform resource identifier) of the REDCap
project.  Required.}

\item{token}{The user-specific string that serves as the password for a
project.  Required.}

\item{record}{The record ID of the instrument(s).  If empty, the responses
are blank.  Optional.}

\item{instrument}{The instrument(s) to download.  If empty, all instruments
are returned.  Optional.}

\item{event}{The unique event name. For a longitudinal project, if record is
not blank and event is blank, it will return data for all events from that
record. If record is not blank and event is not blank, it will return data
only for the specified event from that record. Optional.}

\item{verbose}{A boolean value indicating if \code{message}s should be printed
to the R console during the operation.  Optional.}

\item{config_options}{A list of options to pass to \code{\link[httr:POST]{httr::POST()}} method
in the 'httr' package.  See the details below. Optional.}
}
\value{
Currently, a list is returned with the following elements,
\itemize{
\item \code{success}: A boolean value indicating if the operation was apparently
successful.
\item \code{status_code}: The
\href{https://en.wikipedia.org/wiki/List_of_HTTP_status_codes}{http status code}
of the operation.
\item \code{outcome_message}: A human readable string indicating the operation's
outcome.
\item \code{record_id}: The record_id of the instrument.
\item \code{elapsed_seconds}: The duration of the function.
\item \code{raw_text}: If an operation is NOT successful, the text returned by
REDCap.  If an operation is successful, the \code{raw_text} is returned as an
empty string to save RAM.
\item \code{file_name}: The name of the file persisted to disk. This is useful if
the name stored in REDCap is used (which is the default).
}
}
\description{
Download instruments as a pdf, with or without responses.
}
\details{
Currently, the function doesn't modify any variable types to conform to
REDCap's supported variables.  See \code{\link[=validate_for_write]{validate_for_write()}} for a helper
function that checks for some common important conflicts.
}
\examples{
\dontrun{
uri     <- "https://bbmc.ouhsc.edu/redcap/api/"
token   <- "D70F9ACD1EDD6F151C6EA78683944E98" #pid=213
# event <- "" # only for longitudinal projects

(full_name <- base::temp(pattern="instruments-all-records-all", fileext=".pdf"))
result_1   <- REDCapR::redcap_download_instrument(
  file_name     = full_name,
  redcap_uri    = uri,
  token         = token
)
base::unlink(full_name)

(full_name <- base::tempfile(pattern="instruments-all-record-1-", fileext=".pdf"))
result_2   <- REDCapR::redcap_download_instrument(
  record        = 5,
  file_name     = full_name,
  redcap_uri    = uri,
  token         = token
)
base::unlink(full_name)
(full_name <- base::tempfile(pattern="instrument-1-record-1-", fileext=".pdf"))
result_3   <- REDCapR::redcap_download_instrument(
  record        = 5,
  instrument    = "health",
  file_name     = full_name,
  redcap_uri    = uri,
  token         = token
)
base::unlink(full_name)
}
}
\references{
The official documentation can be found on the 'API Help Page'
and 'API Examples' pages on the REDCap wiki (\emph{i.e.},
https://community.projectredcap.org/articles/456/api-documentation.html and
https://community.projectredcap.org/articles/462/api-examples.html).
If you do not have an account for the wiki, please ask your campus REDCap
administrator to send you the static material.
}
\author{
Will Beasley
}
