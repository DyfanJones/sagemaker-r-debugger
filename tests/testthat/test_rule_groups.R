# NOTE: This code has been modified from AWS Sagemaker Python:
# https://github.com/awslabs/sagemaker-debugger-rulesconfig/blob/master/tests/core/test_rule_groups.py

rule_framework = list(
  list(rule=UNIVERSAL_RULES, framework=SUPPORTED_FRAMEWORKS),
  list(rule=DEEP_LEARNING_RULES, framework=SUPPORTED_DL_FRAMEWORKS),
  list(rule=DEEP_LEARNING_APPLICATION_RULES, framework=SUPPORTED_DL_FRAMEWORKS),
  list(rule=XGBOOST_RULES, framework="xgboost")
)

test_that("test framework rule compatibility", {
  for (i in seq_along(rule_framework)){
    for(rule in rule_framework[[i]]$rule){
      for(framework in rule_framework[[i]]$framework){
        expect_true(rule %in%.get_rule_list(framework))
      }
    }
  }
})

rule_framework = list(
  list(rule=DEEP_LEARNING_RULES, framework="xgboost"),
  list(rule=XGBOOST_RULES, framework=SUPPORTED_DL_FRAMEWORKS)
)

test_that("test framework rule incompatibility",{
  # Deep Learning Rules Do Not Support Xgboost
  # Xgboost Rules Do Not Support Deep Learning Frameworks
  for (i in seq_along(rule_framework)){
    for(rule in rule_framework[[i]]$rule){
      for(framework in rule_framework[[i]]$framework){
        expect_false(rule %in%.get_rule_list(framework))
      }
    }
  }
})
