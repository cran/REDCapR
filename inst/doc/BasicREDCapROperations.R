## ----set_options--------------------------------------------------------------
report_render_start_time <- Sys.time()
report_render_duration_in_seconds <- -999 # In case the vignette isn't evaluated (on CRAN)

library(knitr)
library(magrittr)
requireNamespace("kableExtra")

opts_chunk$set(
  eval    = !REDCapR:::on_cran(),
  collapse = TRUE,
  comment = "#>",
  tidy    = FALSE
)

## ----project_values-----------------------------------------------------------
# library(REDCapR) # Load the package into the current R session.
# uri   <- "https://redcap-dev-2.ouhsc.edu/redcap/api/"
# token <- "9A068C425B1341D69E83064A2D273A70" # simple

## ----return_all---------------------------------------------------------------
# # Return all records and all variables.
# ds_all_rows_all_fields <- redcap_read(redcap_uri = uri, token = token)$data
# ds_all_rows_all_fields # Inspect the returned dataset

## ----read_row_subset----------------------------------------------------------
# # Return only records with IDs of 1 and 3
# desired_records <- c(1, 3)
# ds_some_rows_v1 <- redcap_read(
#   redcap_uri = uri,
#   token      = token,
#   records    = desired_records
# )$data

## ----read_field_subset--------------------------------------------------------
# # Return only the fields record_id, name_first, and age
# desired_fields <- c("record_id", "name_first", "age")
# ds_some_fields <- redcap_read(
#   redcap_uri = uri,
#   token      = token,
#   fields     = desired_fields
# )$data

## ----read_record_field_subset-------------------------------------------------
# ######
# ## Step 1: First call to REDCap
# desired_fields_v3 <- c("record_id", "dob", "weight")
# ds_some_fields_v3 <- redcap_read(
#   redcap_uri = uri,
#   token      = token,
#   fields     = desired_fields_v3
# )$data
# 
# ds_some_fields_v3 #Examine the these three variables.
# 
# ######
# ## Step 2: identify desired records, based on age & weight
# before_1960 <- (ds_some_fields_v3$dob <= as.Date("1960-01-01"))
# heavier_than_70_kg <- (ds_some_fields_v3$weight > 70)
# desired_records_v3 <- ds_some_fields_v3[before_1960 & heavier_than_70_kg, ]$record_id
# 
# desired_records_v3 #Peek at IDs of the identified records
# 
# ######
# ## Step 3: second call to REDCap
# #Return only records that met the age & weight criteria.
# ds_some_rows_v3 <- redcap_read(
#   redcap_uri = uri,
#   token      = token,
#   records    = desired_records_v3
# )$data
# 
# ds_some_rows_v3 #Examine the results.

## -----------------------------------------------------------------------------
# #Return only the fields record_id, name_first, and age
# all_information <- redcap_read(
#   redcap_uri = uri,
#   token      = token,
#   fields     = desired_fields
# )
# all_information #Inspect the additional information

## ----session-info, echo=FALSE-------------------------------------------------
# if (requireNamespace("sessioninfo", quietly = TRUE)) {
#   sessioninfo::session_info()
# } else {
#   sessionInfo()
# }

## ----session-duration, echo=FALSE---------------------------------------------
# report_render_duration_in_seconds <- round(as.numeric(difftime(Sys.time(), report_render_start_time, units = "secs")))

