# NOTE: This code has been modified from AWS Sagemaker Python:
# https://github.com/awslabs/sagemaker-debugger-rulesconfig/blob/master/smdebug_rulesconfig/actions/utils.py

#' @include r_utils.R

#' @importFrom jsonlite fromJSON

TRAINING_JOB_PREFIX_REGEX = "^[A-Za-z0-9\\-]+$"
EMAIL_ADDRESS_REGEX = "^[a-z0-9]+[@]\\w+[.]\\w{2,3}$"
PHONE_NUMBER_REGEX = "^\\+\\d{1,15}$"

validate_training_job_prefix = function(key, value){
  if (!is.character(value))
    stopf("%s must be a string!", key)
  if (!grepl(RAINING_JOB_PREFIX_REGEX, value))
    stopf("Invalid training job prefix! Must contain only letters, numbers and hyphens!")
}

validate_email_address = function(key, value){
  if (!is.character(value))
    stopf("%s must be a string!", key)
  if (!grepl(EMAIL_ADDRESS_REGEX, value))
    stopf("Invalid email address provided! Must follow this scheme: username@domain")
}

validate_phone_number = function(key, value){
  if (!is.character(value))
    stopf("%s must be a string!", key)
  if (!grepl(PHONE_NUMBER_REGEX, value))
    stopf(paste(
      "Invalid phone number provided! Must follow the E.164 format.",
      "See https://docs.aws.amazon.com/sns/latest/dg/sms_publish-to-phone.html for more info."))
}

# Parse the action string as JSON within an exec call and verify that it matches the original action parameters.
# Note that we need the exec call to mimic the same behavior in the rules container.
# If this triggers a syntax error, the exec call is set up incorrectly and needs to be fixed.
# If this triggers a JSON decode error, the action string is badly formatted. This is probably due to invalid action
# parameters being specified (are you using any escape characters?)
# If this triggers an assertion error, the deserialized action JSON does not match the original action parameters,
# so the exec call is set up incorrectly and needs to be fixed.
validate_action_str = function(action_str, action_parameters){
  tryCatch({
    identical(jsonlite::fromJSON(action_str), action_parameters)
  })
}
