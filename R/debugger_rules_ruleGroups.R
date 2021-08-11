# NOTE: This code has been modified from AWS Sagemaker Python:
# https://github.com/awslabs/sagemaker-debugger-rulesconfig/blob/master/smdebug_rulesconfig/debugger_rules/_ruleGroups.py

# set of rules that are expected to work for all supported frameworks
# Supported Frameworks: Mxnet, Pytorch, Tensorflow, Xgboost
UNIVERSAL_RULES = c(
  "AllZero",
  "ClassImbalance",
  "Confusion",
  "LossNotDecreasing",
  "Overfit",
  "Overtraining",
  "SimilarAcrossRuns",
  "StalledTrainingRule",
  "UnchangedTensor"
)

# set of rules that are expected to work for only for supported deep learning frameworks
# Supported Deep Learning Frameworks: Mxnet, Pytorch, Tensorflow
DEEP_LEARNING_RULES = c(
  "DeadRelu",
  "ExplodingTensor",
  "PoorWeightInitialization",
  "SaturatedActivation",
  "TensorVariance",
  "VanishingGradient",
  "WeightUpdateRatio"
)

# Rules intended to be used as part of a DL Application
DEEP_LEARNING_APPLICATION_RULES = c("CheckInputImages", "NLPSequenceRatio")

# Rules only compatible with XGBOOST
XGBOOST_RULES = c("FeatureImportanceOverweight", "TreeDepth")
