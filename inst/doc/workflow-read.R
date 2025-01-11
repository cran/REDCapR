## -----------------------------------------------------------------------------
knitr::opts_chunk$set(
  eval    = !REDCapR:::on_cran(),
  collapse = TRUE,
  comment = "#>",
  tidy    = FALSE
)

## ----pre-req------------------------------------------------------------------
# requireNamespace("REDCapR")
# 
# # If this fails, run `install.packages("REDCapR")` or `remotes::install_github(repo="OuhscBbmc/REDCapR")`

## ----retrieve-credential------------------------------------------------------
# path_credential <- system.file("misc/dev-2.credentials", package = "REDCapR")
# credential  <- REDCapR::retrieve_credential_local(
#   path_credential = path_credential,
#   project_id      = 33
# )
# 
# credential

## ----unstructured-1-----------------------------------------------------------
# ds_1 <-
#   REDCapR::redcap_read(
#     redcap_uri  = credential$redcap_uri,
#     token       = credential$token
#   )$data

## ----unstructured-2, fig.alt = "histogram of patient weight"------------------
# ds_1
# 
# hist(ds_1$weight)
# 
# summary(ds_1)
# 
# summary(lm(age ~ 1 + sex + bmi, data = ds_1))

## ----choose-records-----------------------------------------------------------
# # Return only records with IDs of 1 and 4
# desired_records <- c(1, 4)
# REDCapR::redcap_read(
#   redcap_uri  = credential$redcap_uri,
#   token       = credential$token,
#   records     = desired_records,
#   verbose     = FALSE
# )$data

## ----choose-records-filter----------------------------------------------------
# # Return only records with a birth date after January 2003
# REDCapR::redcap_read(
#   redcap_uri    = credential$redcap_uri,
#   token         = credential$token,
#   filter_logic  = "'2003-01-01' < [dob]",
#   verbose       = FALSE
# )$data

## ----choose-fields------------------------------------------------------------
# # Return only the fields record_id, name_first, and age
# desired_fields <- c("record_id", "name_first", "age")
# REDCapR::redcap_read(
#   redcap_uri  = credential$redcap_uri,
#   token       = credential$token,
#   fields      = desired_fields,
#   verbose     = FALSE
# )$data

## ----col_types----------------------------------------------------------------
# # Specify the column types.
# desired_fields <- c("record_id", "race")
# col_types <- readr::cols(
#   record_id  = readr::col_integer(),
#   race___1   = readr::col_logical(),
#   race___2   = readr::col_logical(),
#   race___3   = readr::col_logical(),
#   race___4   = readr::col_logical(),
#   race___5   = readr::col_logical(),
#   race___6   = readr::col_logical()
# )
# REDCapR::redcap_read(
#   redcap_uri  = credential$redcap_uri,
#   token       = credential$token,
#   fields      = desired_fields,
#   verbose     = FALSE,
#   col_types   = col_types
# )$data

## ----col_types-string---------------------------------------------------------
# # Specify the column types.
# desired_fields <- c("record_id", "race")
# col_types <- readr::cols(.default = readr::col_character())
# REDCapR::redcap_read(
#   redcap_uri  = credential$redcap_uri,
#   token       = credential$token,
#   fields      = desired_fields,
#   verbose     = FALSE,
#   col_types   = col_types
# )$data

## ----session-info, echo=FALSE-------------------------------------------------
# if (requireNamespace("sessioninfo", quietly = TRUE)) {
#   sessioninfo::session_info()
# } else {
#   sessionInfo()
# }

