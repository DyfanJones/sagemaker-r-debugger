# NOTE: This code has been modified from AWS Sagemaker Python:
# https://github.com/awslabs/sagemaker-debugger-rulesconfig/blob/master/smdebug_rulesconfig/debugger_rules/builtin_rules.py

#' @include debugger_rules_utils.R

vanishing_gradient = function(){
  rule_config = .get_rule_config("VanishingGradient")
  return(rule_config)
}

similar_across_runs = function(){
  rule_config = .get_rule_config("SimilarAcrossRuns")
  return(rule_config)
}

weight_update_ratio = function(){
  rule_config = .get_rule_config("WeightUpdateRatio")
  return(rule_config)
}

all_zero = function(){
  rule_config = .get_rule_config("AllZero")
  return(rule_config)
}

exploding_tensor = function(){
  rule_config = .get_rule_config("ExplodingTensor")
  return(rule_config)
}

unchanged_tensor = function(){
  rule_config = .get_rule_config("UnchangedTensor")
  return(rule_config)
}

loss_not_decreasing = function(){
  rule_config = .get_rule_config("LossNotDecreasing")
  return(rule_config)
}

check_input_images = function(){
  rule_config = .get_rule_config("CheckInputImages")
  return(rule_config)
}

dead_relu = function(){
  rule_config = .get_rule_config("DeadRelu")
  return(rule_config)
}

confusion = function(){
  rule_config = .get_rule_config("Confusion")
  return(rule_config)
}

tree_depth = function(){
  rule_config = .get_rule_config("TreeDepth")
  return(rule_config)
}

class_imbalance = function(){
  rule_config = .get_rule_config("ClassImbalance")
  return(rule_config)
}

overfit = function(){
  rule_config = .get_rule_config("Overfit")
  return(rule_config)
}

tensor_variance = function(){
  rule_config = .get_rule_config("TensorVariance")
  return(rule_config)
}

overtraining = function(){
  rule_config = .get_rule_config("Overtraining")
  return(rule_config)
}

poor_weight_initialization = function(){
  rule_config = .get_rule_config("PoorWeightInitialization")
  return(rule_config)
}

saturated_activation = function(){
  rule_config = .get_rule_config("SaturatedActivation")
  return(rule_config)
}

nlp_sequence_ratio = function(){
  rule_config = .get_rule_config("NLPSequenceRatio")
  return(rule_config)
}

stalled_training_rule = function(){
  rule_config = .get_rule_config("StalledTrainingRule")
  return(rule_config)
}

feature_importance_overweight = function(){
  rule_config = .get_rule_config("FeatureImportanceOverweight")
  return(rule_config)
}

create_xgboost_report = function(){
  rule_config = .get_rule_config("CreateXgboostReport")
  return(rule_config)
}
