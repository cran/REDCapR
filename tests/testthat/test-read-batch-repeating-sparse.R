library(testthat)

credential  <- retrieve_credential_testing(project_id = 2603L)
update_expectation  <- FALSE

test_that("smoke test", {
  testthat::skip_on_cran()
  expect_message(
    returned_object <-
      redcap_read(
        redcap_uri    = credential$redcap_uri,
        token         = credential$token
      )
  )
})

test_that("default", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-batch-repeating-sparse/default.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp          = expected_outcome_message,
    returned_object <-
      redcap_read(
        redcap_uri    = credential$redcap_uri,
        token         = credential$token#,
        # batch_size    = 1
      )
  )

  if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected="200")
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})


test_that("batch size 3", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-batch-repeating-sparse/default.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp          = expected_outcome_message,
    returned_object <-
      redcap_read(
        redcap_uri    = credential$redcap_uri,
        token         = credential$token,
        batch_size    = 3
      )
  )

  # if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected="200; 200")
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})


test_that("batch size 2", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-batch-repeating-sparse/default.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp          = expected_outcome_message,
    returned_object <-
      redcap_read(
        redcap_uri    = credential$redcap_uri,
        token         = credential$token,
        batch_size    = 2
      )
  )

  # if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected="200; 200; 200")
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})


test_that("batch size 1", {
  testthat::skip_on_cran()
  path_expected <- "test-data/specific-redcapr/read-batch-repeating-sparse/default.R"
  expected_outcome_message <- "\\d+ records and \\d+ columns were read from REDCap in \\d+(\\.\\d+\\W|\\W)seconds\\."

  expect_message(
    regexp          = expected_outcome_message,
    returned_object <-
      redcap_read(
        redcap_uri    = credential$redcap_uri,
        token         = credential$token,
        batch_size    = 1
      )
  )

  # if (update_expectation) save_expected(returned_object$data, path_expected)
  expected_data_frame <- retrieve_expected(path_expected)

  expect_equal(returned_object$data, expected=expected_data_frame, label="The returned data.frame should be correct", ignore_attr = TRUE) # dput(returned_object$data)
  expect_equal(returned_object$status_code, expected="200; 200; 200; 200; 200")
  expect_true(returned_object$records_collapsed=="", "A subset of records was not requested.")
  expect_true(returned_object$fields_collapsed=="", "A subset of fields was not requested.")
  expect_true(returned_object$filter_logic=="", "A filter was not specified.")
  expect_match(returned_object$outcome_message, regexp=expected_outcome_message, perl=TRUE)
  expect_true(returned_object$success)
})

rm(credential)

