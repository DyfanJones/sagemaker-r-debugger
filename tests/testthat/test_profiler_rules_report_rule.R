# NOTE: This code has been modified from AWS Sagemaker Python:
# https://github.com/awslabs/sagemaker-debugger-rulesconfig/blob/master/tests/core/profiler_rules/test_profiler_report_rule.py

rule_names = sapply(ProfilerReport$private_methods$.get_rules(),
                    function(rule) rule$classname)

test_that("test default profiler report rule", {
  rule = ProfilerReport$new()
  expect_equal(rule$rule_name, ProfilerReport$classname)
  expect_equal(rule$rule_parameters, list(
    opt_out_telemetry=FALSE,
    custom_rule_parameters=list(),
    rule_to_invoke=ProfilerReport$classname
    )
  )
})

test_that("test opt out flag for profiler report rule", {
  # Default Case
  rule = ProfilerReport$new()
  expect_equal(rule$rule_parameters, list(
    opt_out_telemetry=FALSE,
    custom_rule_parameters=list(),
    rule_to_invoke=ProfilerReport$classname
    )
  )

  # Explicit Opt In
  rule = ProfilerReport$new(opt_out_telemetry=FALSE)
  expect_equal(rule$rule_parameters, list(
    opt_out_telemetry=FALSE,
    custom_rule_parameters=list(),
    rule_to_invoke=ProfilerReport$classname
    )
  )

  # Explicit Opt Out
  rule = ProfilerReport$new(opt_out_telemetry=TRUE)
  expect_equal(rule$rule_parameters, list(
    opt_out_telemetry=TRUE,
    custom_rule_parameters=list(),
    rule_to_invoke=ProfilerReport$classname
    )
  )

  # Invalid Input
  expect_error(
    ProfilerReport$new(opt_out_telemetry="False"),
    "accepts only boolean values for"
  )
})

test_that("test valid profiler report rule custom params", {
  rule = ProfilerReport$new(CPUBottleneck_threshold=30)
  expect_equal(rule$rule_name, ProfilerReport$classname)
  expect_equal(rule$rule_parameters,list(
    "opt_out_telemetry"=FALSE,
    "custom_rule_parameters"=list("CPUBottleneck_threshold"=30),
    "rule_to_invoke"=ProfilerReport$classname
    )
  )

  # case of parameter doesn't matter
  rule = ProfilerReport$new(cpubottleneck_threshold=20)
  expect_equal(rule$rule_name, ProfilerReport$classname)
  expect_equal(rule$rule_parameters,list(
    "opt_out_telemetry"=FALSE,
    "custom_rule_parameters"=list("CPUBottleneck_threshold"=20),
    "rule_to_invoke"=ProfilerReport$classname
    )
  )
})

test_that("test invalid profiler report rule custom params", {
  # invalid parameter key format
  expect_error(
    ProfilerReport$new(CPUBottleneckthreshold=30),
    "does not follow naming scheme: <rule_name>_<parameter_name>"
  )
  # invalid parameter key name (unknown rule)
  expect_error(
    ProfilerReport$new(BadRule_threshold=30),
    "is an invalid rule name! Accepted case insensitive rule names are:"
  )

  # invalid parameter key name (unknown parameter)
  expect_error(
    ProfilerReport$new(CPUBottleneck_bad_param=30),
    "is an invalid parameter name! Accepted parameter names for"
  )

  # invalid parameter value (invalid percentile)
  expect_error(
    ProfilerReport$new(CPUBottleneck_threshold=200),
    "is an invalid parameter name! Accepted parameter names for"
  )

  # invalid parameter value (invalid positive integer)
  expect_error(
    ProfilerReport$new(CPUBottleneck_patience=-1),
    "is an invalid parameter name! Accepted parameter names for"
  )
})
