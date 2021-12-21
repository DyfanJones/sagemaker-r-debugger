# NOTE: This code has been modified from AWS Sagemaker Python:
# https://github.com/awslabs/sagemaker-debugger-rulesconfig/blob/master/smdebug_rulesconfig/debugger_rules/_constants.py

RULE_CONFIG_FILE = function(){
  system.file(file.path("rule_config_jsons", "ruleConfigs.json"), package="sagemaker.debugger")
}
COLLECTION_CONFIG_FILE = function(x){
  system.file(file.path("rule_config_jsons", "collections.json"), package="sagemaker.debugger")
}
SUPPORTED_DL_FRAMEWORKS = c("TENSORFLOW", "MXNET", "PYTORCH")
SUPPORTED_FRAMEWORKS = c("TENSORFLOW", "MXNET", "PYTORCH", "XGBOOST")
