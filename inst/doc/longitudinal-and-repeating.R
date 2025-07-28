## -----------------------------------------------------------------------------
library(knitr)
knitr::opts_chunk$set(
  eval    = !REDCapR:::on_cran(),
  collapse = TRUE,
  comment = "#>",
  tidy    = FALSE
)

knit_print.data.frame <- function(x, ...) {
  # See https://cran.r-project.org/package=knitr/vignettes/knit_print.html
  . <- NULL # Avoid lintr check
  x %>%
    # rmarkdown::print.paged_df() %>%
    kable(
      col.names = gsub("_", "<br>", colnames(.)),
      # col.names = paste0("<code>", gsub("_", "<br>", colnames(.)), "</code>"),
      # col.names = gsub("_", " ", colnames(.)),
      escape = FALSE,
      format = "html"
    ) %>%
    kableExtra::kable_styling(
      bootstrap_options = c("striped", "hover", "condensed", "responsive"),
      full_width        = FALSE
    ) %>%
    c("", "", .) %>%
    paste(collapse = "\n") %>%
    asis_output()
}

# register the method
registerS3method("knit_print", "data.frame", knit_print.data.frame)

## ----retrieve-credential------------------------------------------------------
# # Support pipes
# library(magrittr)
# 
# # Retrieve token
# path_credential <- system.file("misc/dev-2.credentials", package = "REDCapR")
# credential  <- REDCapR::retrieve_credential_local(
#   path_credential = path_credential,
#   project_id      = 62
# )

## ----redcapr-intake-----------------------------------------------------------
# col_types_intake <-
#   readr::cols_only(
#     record_id                 = readr::col_integer(),
#     height                    = readr::col_double(),
#     weight                    = readr::col_double(),
#     bmi                       = readr::col_double()
#   )
# 
# ds_intake <-
#   REDCapR::redcap_read(
#     redcap_uri  = credential$redcap_uri, # From the previous code snippet.
#     token       = credential$token,
#     forms       = c("intake"),
#     col_types   = col_types_intake,
#     verbose     = FALSE,
#   )$data
# 
# ds_intake

## ----redcapr-repeating--------------------------------------------------------
# col_types_blood_pressure <-
#   readr::cols(
#     record_id                 = readr::col_integer(),
#     redcap_repeat_instrument  = readr::col_character(),
#     redcap_repeat_instance    = readr::col_integer(),
#     sbp                       = readr::col_double(),
#     dbp                       = readr::col_double(),
#     blood_pressure_complete   = readr::col_integer()
#   )
# 
# ds_blood_pressure <-
#   REDCapR::redcap_read(
#     redcap_uri  = credential$redcap_uri,
#     token       = credential$token,
#     forms       = c("blood_pressure"),
#     col_types   = col_types_blood_pressure,
#     verbose     = FALSE
#   )$data
# 
# ds_blood_pressure %>%
#   tidyr::drop_na(redcap_repeat_instrument)
# 
# col_types_laboratory  <-
#   readr::cols(
#     record_id                 = readr::col_integer(),
#     redcap_repeat_instrument  = readr::col_character(),
#     redcap_repeat_instance    = readr::col_integer(),
#     lab                       = readr::col_character(),
#     conc                      = readr::col_character(),
#     laboratory_complete       = readr::col_integer()
#   )
# 
# ds_laboratory  <-
#   REDCapR::redcap_read(
#     redcap_uri  = credential$redcap_uri,
#     token       = credential$token,
#     forms       = c("laboratory"),
#     col_types   = col_types_laboratory,
#     verbose     = FALSE
#   )$data
# 
# ds_laboratory %>%
#   tidyr::drop_na(redcap_repeat_instrument)

## ----redcapr-block------------------------------------------------------------
# ds_block <-
#   REDCapR::redcap_read(
#     redcap_uri  = credential$redcap_uri,
#     token       = credential$token,
#     col_types   = readr::cols(.default = readr::col_character()),
#     verbose     = FALSE,
#   )$data
# 
# ds_block

## ----session-info, echo=FALSE-------------------------------------------------
# if (requireNamespace("sessioninfo", quietly = TRUE)) {
#   sessioninfo::session_info()
# } else {
#   sessionInfo()
# }

