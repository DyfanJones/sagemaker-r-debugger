# NOTE: This code has been modified from AWS Sagemaker Python:
# https://github.com/awslabs/sagemaker-debugger-rulesconfig/blob/master/smdebug_rulesconfig/debugger_rules/_utils.py

#' @importFrom jsonlite fromJSON

.get_rule_config = function(rule_name){
  rule_config = NULL

  config_file_path = RULE_CONFIG_FILE()

  if (file.exists(config_file_path)){
    configs = fromJSON(config_file_path)
  }
  if (rule_name %in% names(configs))
    rule_config = configs[[rule_name]]
  return(rule_config)
}

.get_rule_list = function(framework){
  framework = toupper(framework)
  rule_set = UNIVERSAL_RULES
  if (framework %in% SUPPORTED_DL_FRAMEWORKS){
    rule_set = Reduce(union, list(rule_set, DEEP_LEARNING_RULES, DEEP_LEARNING_APPLICATION_RULES))
  } else if (framework == "XGBOOST"){
    rule_set = union(rule_set, XGBOOST_RULES)
  }else{
    stopf("%s is not supported by debugger rules", framework)
  }
  return(rule_set)
}

.get_config_for_group = function(rules){
  rules_config = list()

  config_file_path = RULE_CONFIG_FILE()

  if (file.exists(config_file_path)){
    configs = fromJSON(config_file_path)
    rule_config = configs[names(configs) %in% rules]
  }
  return(rules_config)
}

.get_collection_config = function(collection_name){
  coll_config = NULL
  config_file_path = COLLECTION_CONFIG_FILE()
  if (file.exists(config_file_path)){
    configs = fromJSON(config_file_path)
    if (collection_name %in% names(configs))
      coll_config = configs[[collection_name]]
  }
  return(coll_config)
}
