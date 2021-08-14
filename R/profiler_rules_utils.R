# NOTE: This code has been modified from AWS Sagemaker Python:
# https://github.com/awslabs/sagemaker-debugger-rulesconfig/blob/master/smdebug_rulesconfig/profiler_rules/utils.py

#' @include r_utils.R

#' @importFrom data.table between

invalid_boolean_error = "%s accepts only boolean values for %s "
invalid_key_format_error = "Key %s does not follow naming scheme: <rule_name>_<parameter_name>"
invalid_rule_error = "%s is an invalid rule name! Accepted case insensitive rule names are: %s"
invalid_param_error = "%s is an invalid parameter name! Accepted parameter names for %s are: %s"
invalid_positive_integer_error = "%s %s must be a positive integer!"
invalid_percentile_error = "%s %s must be a valid percentile!"


validate_positive_integer = function(rule_name, key, val){
  if(!(val>0))
    stopf(invalid_positive_integer_error, rule_name, key)
}

validate_percentile = function(rule_name, key, val){
  if(!between(val, 0, 100))
    stopf(invalid_percentile_error, rule_name, key)
}

validate_boolean = function(rule_name, key, val){
  if(!is.logical(val))
    stopf(invalid_boolean_error, rule_name, key)
}
