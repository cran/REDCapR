library(testthat)

credential  <- retrieve_credential_testing()

test_that("One Shot: Bad Uri -Not HTTPS", {
  testthat::skip_on_cran()
  testthat::skip("The response is dependent on the client.  This test is probably too picky anyway.")
  # expected_message_411 <- "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\"http://www.w3.org/TR/html4/strict.dtd\">\n<HTML><HEAD><TITLE>Length Required</TITLE>\n<META HTTP-EQUIV=\"Content-Type\" Content=\"text/html; charset=us-ascii\"></HEAD>\n<BODY><h2>Length Required</h2>\n<hr><p>HTTP Error 411. The request must be chunked or have a content length.</p>\n</BODY></HTML>\n"
  # expected_message_501 <- "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><hash><error>The requested method is not implemented.</error></hash>"

  expect_error(
    # returned_object <-
      redcap_read_oneshot(
        redcap_uri    = "http://bbmc.ouhsc.edu/redcap/api/", # Not HTTPS
        token         = credential$token
      )
  )

  # expect_equal(returned_object$data, expected=data.frame(), label="An empty data.frame should be returned.")
  # expect_true(returned_object$status_code %in% c(411L, 501L))
  # expect_true(returned_object$raw_text %in% c(expected_message_411, expected_message_501))
  # # expect_equal(returned_object$raw_text, expected=expected_message)
  # expect_equal(returned_object$records_collapsed, "")
  # expect_equal(returned_object$fields_collapsed, "")
  # expect_false(returned_object$success)
})

test_that("One Shot: Bad Uri -wrong address", {
  testthat::skip_on_cran()
  # expected_message <- "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n<html xmlns=\"http://www.w3.org/1999/xhtml\">\n<head>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\"/>\n<title>404 - File or directory not found.</title>\n<style type=\"text/css\">\n<!--\nbody{margin:0;font-size:.7em;font-family:Verdana, Arial, Helvetica, sans-serif;background:#EEEEEE;}\nfieldset{padding:0 15px 10px 15px;} \nh1{font-size:2.4em;margin:0;color:#FFF;}\nh2{font-size:1.7em;margin:0;color:#CC0000;} \nh3{font-size:1.2em;margin:10px 0 0 0;color:#000000;} \n#header{width:96%;margin:0 0 0 0;padding:6px 2% 6px 2%;font-family:\"trebuchet MS\", Verdana, sans-serif;color:#FFF;\nbackground-color:#555555;}\n#content{margin:0 0 0 2%;position:relative;}\n.content-container{background:#FFF;width:96%;margin-top:8px;padding:10px;position:relative;}\n-->\n</style>\n</head>\n<body>\n<div id=\"header\"><h1>Server Error</h1></div>\n<div id=\"content\">\n <div class=\"content-container\"><fieldset>\n  <h2>404 - File or directory not found.</h2>\n  <h3>The resource you are looking for might have been removed, had its name changed, or is temporarily unavailable.</h3>\n </fieldset></div>\n</div>\n</body>\n</html>\n"
  expected_message <- "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>404 Not Found</title>\n</head><body>\n<h1>Not Found</h1>\n<p>The requested URL was not found on this server.</p>\n</body></html>\n"

  # expected_outcome_message <- "The initial call failed with the code: 404."
  # expected_outcome_message <- "The requested URL was not found on this server."

  expect_message(
    returned_object <-
      redcap_read_oneshot(
        redcap_uri    = "https://bbmc.ouhsc.edu/redcap/apiFFFFFFFFFFFFFF/", # Wrong url
        token         = credential$token
      )
  )

  expect_equal(returned_object$data, expected=data.frame(), label="An empty data.frame should be returned.")
  expect_equal(returned_object$status_code, expected=404L)
  expect_equal(returned_object$raw_text, expected=expected_message)
  expect_equal(returned_object$records_collapsed, "")
  expect_equal(returned_object$fields_collapsed, "")
  expect_false(returned_object$success)
})

test_that("Batch: Bad Uri -Not HTTPS", {
  testthat::skip_on_cran()
  testthat::skip("The response is dependent on the client.  This test is probably too picky anyway.")
  # expected_outcome_message <- "The initial call failed with the code: (411|501)."

  expect_error(
    # returned_object <-
      redcap_read(
        redcap_uri    = "http://bbmc.ouhsc.edu/redcap/api/", # Not HTTPS
        token         = credential$token
      )
  )

  # expect_equal(returned_object$data, expected=data.frame(), label="An empty data.frame should be returned.")
  # expect_true(returned_object$status_code %in% c(411L, 501L))
  # expect_equal(returned_object$records_collapsed, "failed in initial batch call")
  # expect_equal(returned_object$fields_collapsed, "failed in initial batch call")
  # expect_match(returned_object$outcome_messages, expected_outcome_message)
  # expect_false(returned_object$success)
})

test_that("Batch: Bad Uri -wrong address", {
  testthat::skip_on_cran()
  expected_message <- "The initial call failed with the code: 404."
  # expected_message <- "The requested URL was not found on this server."

  expect_message(
    returned_object <-
      redcap_read(
        redcap_uri    = "https://bbmc.ouhsc.edu/redcap/apiFFFFFFFFFFFFFF/", # Wrong url
        token         = credential$token
      ),
    "The requested URL was not found on this server."
  )

  expect_equal(returned_object$data, expected=data.frame(), label="An empty data.frame should be returned.")
  expect_equal(returned_object$status_code, expected=404L)
  expect_equal(returned_object$records_collapsed, "failed in initial batch call")
  expect_equal(returned_object$fields_collapsed, "failed in initial batch call")
  expect_equal(returned_object$outcome_messages, expected_message)
  expect_false(returned_object$success)
})

test_that("hashed record -warn", {
  testthat::skip_on_cran()
  # This dinky little test is mostly to check that the warning message has legal syntax.
  expected_warning <- "^It appears that the REDCap record IDs have been hashed.+"

  expect_warning(
    REDCapR:::warn_hash_record_id(),
    expected_warning
  )
})

test_that("guess_max deprecated -warn", {
  testthat::skip_on_cran()
  expected_outcome_message <- "The `guess_max` parameter in `REDCapR::redcap_read\\(\\)` is deprecated\\."

  expect_warning(
    regexp           = expected_outcome_message,
    returned_object <- redcap_read(
      redcap_uri    = credential$redcap_uri,
      token         = credential$token,
      guess_max     = 100
    )
  )
})

rm(credential)
