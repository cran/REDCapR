## -----------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  tidy    = FALSE
)

## ----codebook-race------------------------------------------------------------
knitr::include_graphics("images/codebook-race.png")

## ----session-info, echo=FALSE-------------------------------------------------
if (requireNamespace("sessioninfo", quietly = TRUE)) {
  sessioninfo::session_info()
} else {
  sessionInfo()
}

