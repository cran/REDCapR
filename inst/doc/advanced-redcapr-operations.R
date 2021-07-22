## ----set_options, echo=FALSE, results='hide'----------------------------------
report_render_start_time <- Sys.time()

library(knitr)
library(magrittr)
suppressPackageStartupMessages(requireNamespace("kableExtra"))

opts_chunk$set(
  comment = "#>",
  tidy    = FALSE
)

# knitr::opts_chunk$set(comment = "#>", collapse = TRUE)
knit_print.data.frame = function(x, ...) {
  # See https://cran.r-project.org/package=knitr/vignettes/knit_print.html

  x %>%
    # rmarkdown::print.paged_df() %>%
    kable(
      col.names = gsub("_", " ", colnames(.)),
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

## ----project_values-----------------------------------------------------------
library(REDCapR) #Load the package into the current R session.
uri                   <- "https://bbmc.ouhsc.edu/redcap/api/"
token_simple          <- "9A81268476645C4E5F03428B8AC3AA7B"
token_longitudinal    <- "0434F0E9CF53ED0587847AB6E51DE762"

## ----retrieve-longitudinal, results='hold'------------------------------------
library(magrittr);
suppressPackageStartupMessages(requireNamespace("dplyr"))
suppressPackageStartupMessages(requireNamespace("tidyr"))
events_to_retain  <- c("dose_1_arm_1", "visit_1_arm_1", "dose_2_arm_1", "visit_2_arm_1")

ds_long <- REDCapR::redcap_read_oneshot(redcap_uri = uri, token = token_longitudinal)$data
ds_long %>%
  dplyr::select(study_id, redcap_event_name, pmq1, pmq2, pmq3, pmq4)

## ----widen-simple, results='hold'---------------------------------------------
ds_wide <-
  ds_long %>%
  dplyr::select(study_id, redcap_event_name, pmq1) %>%
  dplyr::filter(redcap_event_name %in% events_to_retain) %>%
  tidyr::pivot_wider(
    id_cols     = study_id,
    names_from  = redcap_event_name,
    values_from = pmq1
  )
  # For old versions of tidyr that predate `pivot_wider()`:
  # tidyr::spread(key=redcap_event_name, value=pmq1)
ds_wide

## ----widen-typical------------------------------------------------------------
pattern <- "^(\\w+?)_arm_(\\d)$"
ds_wide <-
  ds_long %>%
  dplyr::select(study_id, redcap_event_name, pmq1, pmq2, pmq3, pmq4) %>%
  dplyr::mutate(
    event = sub(pattern, "\\1", redcap_event_name),
    event = dplyr::recode(event, "first_dose"="dose_1", "first_visit"="visit_1"),
    arm   = as.integer(sub(pattern, "\\2", redcap_event_name))
  ) %>%
  dplyr::select(study_id, event, arm, pmq1, pmq2, pmq3, pmq4) %>%
  dplyr::filter(!(event %in% c(
    "enrollment", "final_visit", "deadline_to_return", "deadline_to_opt_ou")
  )) %>%
  tidyr::pivot_wider(
    id_cols     = c(study_id, arm),
    names_from  = event,
    values_from = c(pmq1, pmq2, pmq3, pmq4)
  )

ds_wide

## ----widen-long-first---------------------------------------------------------
ds_eav <-
  ds_long %>%
  dplyr::select(study_id, redcap_event_name, pmq1, pmq2, pmq3, pmq4) %>%
  dplyr::mutate(
    event = sub(pattern, "\\1", redcap_event_name),
    event = dplyr::recode(event, "first_dose" = "dose_1", "first_visit" = "visit_1"),
    arm   = as.integer(sub(pattern, "\\2", redcap_event_name))
  ) %>%
  dplyr::select(study_id, event, arm, pmq1, pmq2, pmq3, pmq4) %>%
  tidyr::pivot_longer(
    cols      = c(pmq1, pmq2, pmq3, pmq4),
    names_to  = "key",
    values_to = "value"
  ) %>%
  # For old versions of tidyr that predate `pivot_wider()`:
  # tidyr::gather(key=key, value=value, pmq1, pmq2, pmq3, pmq4) %>%
  dplyr::filter(!(event %in% c(
    "enrollment", "final_visit", "deadline_to_return", "deadline_to_opt_ou")
  )) %>%
  dplyr::mutate( # Simulate correcting for mismatched names across arms:
    key = paste0(key, "_", event)
  ) %>%
  dplyr::select(-event)

# Show the first 10 rows of the EAV table.
ds_eav %>%
  head(10)

# Spread the EAV to wide.
ds_wide_2 <-
  ds_eav %>%
  tidyr::pivot_wider(
    id_cols     = c(study_id, arm),
    names_from  = key,
    values_from = value
  )
  # For old versions of tidyr that predate `pivot_wider()`:
  # tidyr::spread(key=key, value=value)
ds_wide_2

## -----------------------------------------------------------------------------
cert_location <- system.file("cacert.pem", package = "openssl")
if (file.exists(cert_location)) {
  config_options         <- list(cainfo = cert_location)
  ds_different_cert_file <- redcap_read_oneshot(
    redcap_uri     = uri,
    token          = token_simple,
    config_options = config_options
  )$data
}

## -----------------------------------------------------------------------------
config_options <- list(sslversion = 3)
ds_ssl_3 <- redcap_read_oneshot(
  redcap_uri     = uri,
  token          = token_simple,
  config_options = config_options
)$data

config_options <- list(ssl.verifypeer = FALSE)
ds_no_ssl <- redcap_read_oneshot(
  redcap_uri     = uri,
  token          = token_simple,
  config_options = config_options
)$data

## ----session-info, echo=FALSE-------------------------------------------------
if (requireNamespace("sessioninfo", quietly = TRUE)) {
  sessioninfo::session_info()
} else {
  sessionInfo()
}

## ----session-duration, echo=FALSE---------------------------------------------
report_render_duration_in_seconds <- round(as.numeric(difftime(Sys.time(), report_render_start_time, units = "secs")))

