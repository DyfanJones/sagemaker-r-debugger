# NOTE: This code has been modified from AWS Sagemaker Python:
# https://github.com/awslabs/sagemaker-debugger-rulesconfig/blob/master/smdebug_rulesconfig/debugger_rules/builtin_rules.py

#' @include debugger_rules_utils.R

#' @title List of Debugger Built-in Rules
#' @description Use the Debugger built-in rules provided by Amazon SageMaker Debugger
#'              and analyze tensors emitted while training your models. The Debugger
#'              built-in rules monitor various common conditions that are critical for
#'              the success of a training job. You can call the built-in rules using
#'              Amazon SageMaker Python SDK or the low-level SageMaker API operations.
#'              Depending on deep learning frameworks of your choice, there are four
#'              scopes of validity for the built-in rules as shown in the following table.
#'              \url{https://docs.aws.amazon.com/sagemaker/latest/dg/debugger-built-in-rules.html}
#' @name rule_config
#' @return list to be used in Amazon SageMaker Debugger
NULL

#' @rdname rule_config
#' @export
vanishing_gradient = function(){
  rule_config = .get_rule_config("VanishingGradient")
  return(rule_config)
}

#' @rdname rule_config
#' @export
similar_across_runs = function(){
  rule_config = .get_rule_config("SimilarAcrossRuns")
  return(rule_config)
}

#' @rdname rule_config
#' @export
weight_update_ratio = function(){
  rule_config = .get_rule_config("WeightUpdateRatio")
  return(rule_config)
}

#' @rdname rule_config
#' @export
all_zero = function(){
  rule_config = .get_rule_config("AllZero")
  return(rule_config)
}

#' @rdname rule_config
#' @export
exploding_tensor = function(){
  rule_config = .get_rule_config("ExplodingTensor")
  return(rule_config)
}

#' @rdname rule_config
#' @export
unchanged_tensor = function(){
  rule_config = .get_rule_config("UnchangedTensor")
  return(rule_config)
}

#' @rdname rule_config
#' @export
loss_not_decreasing = function(){
  rule_config = .get_rule_config("LossNotDecreasing")
  return(rule_config)
}

#' @rdname rule_config
#' @export
check_input_images = function(){
  rule_config = .get_rule_config("CheckInputImages")
  return(rule_config)
}

#' @rdname rule_config
#' @export
dead_relu = function(){
  rule_config = .get_rule_config("DeadRelu")
  return(rule_config)
}

#' @rdname rule_config
#' @export
confusion = function(){
  rule_config = .get_rule_config("Confusion")
  return(rule_config)
}

#' @rdname rule_config
#' @export
tree_depth = function(){
  rule_config = .get_rule_config("TreeDepth")
  return(rule_config)
}

#' @rdname rule_config
#' @export
class_imbalance = function(){
  rule_config = .get_rule_config("ClassImbalance")
  return(rule_config)
}

#' @rdname rule_config
#' @export
overfit = function(){
  rule_config = .get_rule_config("Overfit")
  return(rule_config)
}

#' @rdname rule_config
#' @export
tensor_variance = function(){
  rule_config = .get_rule_config("TensorVariance")
  return(rule_config)
}

#' @rdname rule_config
#' @export
overtraining = function(){
  rule_config = .get_rule_config("Overtraining")
  return(rule_config)
}

#' @rdname rule_config
#' @export
poor_weight_initialization = function(){
  rule_config = .get_rule_config("PoorWeightInitialization")
  return(rule_config)
}

#' @rdname rule_config
#' @export
saturated_activation = function(){
  rule_config = .get_rule_config("SaturatedActivation")
  return(rule_config)
}

#' @rdname rule_config
#' @export
nlp_sequence_ratio = function(){
  rule_config = .get_rule_config("NLPSequenceRatio")
  return(rule_config)
}

#' @rdname rule_config
#' @export
stalled_training_rule = function(){
  rule_config = .get_rule_config("StalledTrainingRule")
  return(rule_config)
}

#' @rdname rule_config
#' @export
feature_importance_overweight = function(){
  rule_config = .get_rule_config("FeatureImportanceOverweight")
  return(rule_config)
}

#' @rdname rule_config
#' @export
create_xgboost_report = function(){
  rule_config = .get_rule_config("CreateXgboostReport")
  return(rule_config)
}
