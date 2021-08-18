# NOTE: This code has been modified from AWS Sagemaker Python:
# https://github.com/awslabs/sagemaker-debugger-rulesconfig/blob/master/tests/core/actions/test_actions.py

stop_training_name = "stoptraining"
email_name = "email"
sms_name = "sms"
training_job_prefix = "training-job-prefix"
training_job_name = "training-job-name"
email_address = "abc@abc.com"
phone_number = "+11223445567890"


# Validate that creating a `StopTraining` action object is a valid action object, that it is serialized correctly into
# an action string, and that the resulting action parameters are correct.
# Also validate that creating this object without a custom training job prefix allows this prefix to be manually
# updated later on (this mimics the exact behavior in sagemaker SDK, where the actual training job name is used
# as the prefix if the user did not specify a custom training job prefix).
test_that("test default stop training action", {
  action = StopTraining$new()
  expect_true(is_valid_action_object(action))
  expect_true(action$use_default_training_job_prefix)
  expect_equal(action$action_parameters, list("name"=stop_training_name))

  action$update_training_job_prefix_if_not_specified(training_job_name)
  expect_equal(action$action_parameters, list(
    "name"=stop_training_name,
    "training_job_prefix"=training_job_name
    )
  )
})

# Validate that creating a `StopTraining` action object is a valid action object, that it is serialized correctly into
# an action string, and that the resulting action parameters are correct.
# Also validate that creating this object with a custom training job prefix does not allow this prefix to be
# manually updated later on (this again mimics the exact behavior in sagemaker SDK: if user specifies custom prefix,
# this should actually be used in the rule container).
test_that("test custom stop training action", {
  action = StopTraining$new(training_job_prefix)
  expect_true(is_valid_action_object(action))
  expect_false(action$use_default_training_job_prefix)
  expect_equal(action$action_parameters, list(
    "training_job_prefix"=training_job_prefix,
    "name"=stop_training_name
    )
  )

  action$update_training_job_prefix_if_not_specified(training_job_name)
  expect_equal(action$action_parameters, list(
    "training_job_prefix"=training_job_prefix,
    "name"=stop_training_name
    )
  )
})

# Validate that creating a `Email` action object is a valid action object, that it is serialized correctly into
# an action string, and that the resulting action parameters are correct.
test_that("test email action", {
  action = Email$new(email_address)
  expect_true(is_valid_action_object(action))
  expect_equal(action$action_parameters, list("endpoint"=email_address, "name"=email_name))
})

# Validate that creating a `SMS` action object is a valid action object, that it is serialized correctly into
# an action string, and that the resulting action parameters are correct.
test_that("test sms action", {
  action = SMS$new(phone_number)
  expect_true(is_valid_action_object(action))
  expect_equal(action$action_parameters, list("endpoint"=phone_number, "name"=sms_name))
})

# Validate that creating a `ActionList` action object (with `StopTraining`, `Email` and `SMS` actions)  is a valid
# action object, that it is serialized correctly into an action string, and that the resulting action parameters are
# correct.
# Also validate that creating this object without a custom training job prefix for the `StopTraining` action allows
# this prefix to be manually updated later on by simply calling the update function defined in the ActionList class
# (this mimics the exact behavior in sagemaker SDK, where the actual training job name is used as the prefix if
# the user did not specify a custom training job prefix).
test_that("test action list", {
  actions = ActionList$new(StopTraining$new(), Email$new(email_address), SMS$new(phone_number))
  expect_true(is_valid_action_object(actions))
  action_parameters = lapply(actions$actions, function(action) action$action_parameters)
  expect_equal(action_parameters, list(
    list("name"=stop_training_name),
    list("endpoint"=email_address, "name"=email_name),
    list("endpoint"=phone_number, "name"=sms_name)
    )
  )
})

# Validate that bad input for actions triggers an AssertionError.
# Also verify that the `is_valid_action_object` returns `False` for any input that isn't an `Action` or `ActionList`.
# This is important, as the sagemaker SDK uses this function to validate actions input.
test_that("test action validation", {
  expect_error(StopTraining$new("bad_training_job_prefix"))
  expect_error(Email$new("bad.email.com"))
  expect_error(SMS$new("1234"))
  expect_error(ActionList$new(StopTraining$new(), "bad_action"))

  expect_false(is_valid_action_object("bad_action"))
})
