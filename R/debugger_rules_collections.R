# NOTE: This code has been modified from AWS Sagemaker Python:
# https://github.com/awslabs/sagemaker-debugger-rulesconfig/blob/master/smdebug_rulesconfig/debugger_rules/_collections.py

#' @include debugger_rules_utils.R

get_collection = function(collection_name){
  return(.get_collection_config(collection_name))
}
