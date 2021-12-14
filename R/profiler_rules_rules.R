# NOTE: This code has been modified from AWS Sagemaker Python:
# https://github.com/awslabs/sagemaker-debugger-rulesconfig/blob/master/smdebug_rulesconfig/profiler_rules/rules.py

#' @include profiler_rules_utils.R
#' @include r_utils.R

#' @import R6

#' @title Debugger ProfilerRule Base class
#' @keywords internal
ProfilerRuleBase = R6Class("ProfilerRuleBase",
  public = list(

    #' @description Initialize ProfilerRuleBase class
    #' @param ... : parameters rule_parameter
    initialize = function(...){
      self$rule_name = class(self)[[1]]
      rule_parameters = list(...)
      rule_parameters[["rule_to_invoke"]] = class(self)[[1]]
      self$rule_parameters = rule_parameters
    },

    #' @description format class
    format = function(){
      format_class(self)
    }
  ),
  lock_objects = F
)

#' @title Debugger BatchSize class
#' @description This rule helps to detect if GPU is underulitized because of the batch size being too small.
#'              To detect this the rule analyzes the average GPU memory footprint, CPU and GPU utilization.
#'              If utilization on CPU, GPU and memory footprint is on average low , it may indicate that user
#'              can either run on a smaller instance type or that batch size could be increased. This analysis does not
#'              work for frameworks that heavily over-allocate memory. Increasing batch size could potentially lead to
#'              a processing/dataloading bottleneck, because more data needs to be pre-processed in each iteration.
#' @export
BatchSize = R6Class("BatchSize",
  inherit = ProfilerRuleBase,
  public = list(

    #' @description Initialize BatchSize class
    #' @param cpu_threshold_p95 (numeric): defines the threshold for 95th quantile of CPU utilization.Default is 70\%.
    #' @param gpu_threshold_p95 (numeric): defines the threshold for 95th quantile of GPU utilization.Default is 70\%.
    #' @param gpu_memory_threshold_p95 (numeric): defines the threshold for 95th quantile of GPU memory utilization.Default is 70\%.
    #' @param patience (numeric): defines how many data points to capture before Rule runs the first evluation. Default 100
    #' @param window (numeric): window size for computing quantiles.
    #' @param scan_interval_us (numeric): interval with which timeline files are scanned. Default is 60000000 us.
    initialize = function(cpu_threshold_p95=70,
                          gpu_threshold_p95=70,
                          gpu_memory_threshold_p95=70,
                          patience=1000,
                          window=500,
                          scan_interval_us=60 * 1000 * 1000){
      validate_percentile("cpu_threshold_p95", cpu_threshold_p95)
      validate_percentile("gpu_threshold_p95", gpu_threshold_p95)
      validate_percentile("gpu_memory_threshold_p95", gpu_memory_threshold_p95)
      validate_positive_integer("patience", patience)
      validate_positive_integer("window", window)
      validate_positive_integer("scan_interval_us", scan_interval_us)

      super$initialize(
        cpu_threshold_p95=cpu_threshold_p95,
        gpu_threshold_p95=gpu_threshold_p95,
        gpu_memory_threshold_p95=gpu_memory_threshold_p95,
        patience=patience,
        window=window,
        scan_interval_us=scan_interval_us)
    }
  ),
  lock_objects = F
)


#' @title Debugger CPUBottleneck class
#' @description This rule helps to detect if GPU is underutilized due to CPU bottlenecks.
#'              Rule returns True if number of CPU bottlenecks exceeds a predefined threshold.
#' @export
CPUBottleneck = R6Class("CPUBottleneck",
  inherit = ProfilerRuleBase,
  public = list(

    #' @description Initialize CPUBottleneck class
    #' @param threshold : defines the threshold beyond which Rule should return True. Default is 50 percent.
    #'              So if there is a bottleneck more than 50\% of the time during the training Rule will return True.
    #' @param gpu_threshold : threshold that defines when GPU is considered being under-utilized. Default is 10\%
    #' @param cpu_threshold : threshold that defines high CPU utilization. Default is above 90\%
    #' @param patience : How many values to record before checking for CPU bottlenecks. During training
    #'              initialization, GPU is likely at 0 percent, so Rule should not check for
    #'              under utilization immediately. Default 1000.
    #' @param scan_interval_us : interval with which timeline files are scanned. Default is 60000000 us.
    initialize = function(threshold=50,
                          gpu_threshold=10,
                          cpu_threshold=90,
                          patience=1000,
                          scan_interval_us=60 * 1000 * 1000){
      validate_percentile(class(self)[[1]], "threshold", threshold)
      validate_percentile(class(self)[[1]], "gpu_threshold", gpu_threshold)
      validate_percentile(class(self)[[1]], "cpu_threshold", cpu_threshold)
      validate_positive_integer(class(self)[[1]], "patience", patience)
      validate_positive_integer(class(self)[[1]], "scan_interval_us", scan_interval_us)

      super$initialize(
        threshold=threshold,
        gpu_threshold=gpu_threshold,
        cpu_threshold=cpu_threshold,
        patience=patience,
        scan_interval_us=scan_interval_us)
    }
  ),
  lock_objects = F
)

#' @title Debugger Dataloader class
#' @description This rule helps to detect how many dataloader processes are running
#'              in parallel and whether the total number is equal the number of available CPU cores.
#' @export
Dataloader = R6Class("Dataloader",
  inherit = ProfilerRuleBase,
  public = list(

    #' @description Initialize Dataloader class
    #' @param min_threshold : how many cores should be at least used by dataloading processes. Default 70\%
    #' @param max_threshold : how many cores should be at maximum used by dataloading processes. Default 200\%
    #' @param scan_interval_us : interval with which timeline files are scanned. Default is 60000000 us.
    initialize = function(min_threshold=70,
                          max_threshold=200,
                          scan_interval_us=60000000){
      validate_positive_integer("min_threshold", min_threshold)
      validate_positive_integer("max_threshold", max_threshold)
      validate_positive_integer("scan_interval_us", scan_interval_us)

      super$initialize(
        min_threshold=min_threshold,
        max_threshold=max_threshold,
        scan_interval_us=scan_interval_us)

      self$min_threshold = min_threshold
      self$max_threshold = max_threshold
      self$scan_interval_us = scan_interval_us
    }
  ),
  lock_objects = F
)

#' @title Debugger GPUMemoryIncrease class
#' @description This rule helps to detect large increase in memory usage on GPUs.
#'              The rule computes the moving average of continous datapoints and compares
#'              it against the moving average of previous iteration.
#' @export
GPUMemoryIncrease = R6Class("GPUMemoryIncrease",
  inherit = ProfilerRuleBase,
  public = list(

    #' @description Initialize GPUMemoryIncrease class
    #' @param increase : defines the threshold for absolute memory increase.Default is 5\%.
    #'              So if moving average increase from 5\% to 6\%, the rule will fire.
    #' @param patience : defines how many continous datapoints to capture before Rule runs
    #'              the first evluation. Default is 1000
    #' @param window : window size for computing moving average of continous datapoints
    #' @param scan_interval_us : interval with which timeline files are scanned. Default is 60000000 us.
    initialize = function(increase=5,
    patience=1000,
    window=10,
    scan_interval_us=60 * 1000 * 1000){
      validate_positive_integer("increase", increase)
      validate_positive_integer("patience", patience)
      validate_positive_integer("window", window)
      validate_positive_integer("scan_interval_us", scan_interval_us)

      super$initialize(
        increase=increase,
        patience=patience,
        window=window,
        scan_interval_us=scan_interval_us)
    }
  ),
  lock_objects = F
)

#' @title Debugger IOBottleneck class
#' @description This rule helps to detect if GPU is underutilized due to IO bottlenecks.
#'              Rule returns True if number of IO bottlenecks exceeds a predefined threshold.
#' @export
IOBottleneck = R6Class("IOBottleneck",
  inherit = ProfilerRuleBase,
  public = list(

    #' @description Initialize IOBottleneck class
    #' @param threshold : defines the threshold when Rule should return True. Default
    #'              is 50 percent. So if there is a bottleneck more than 50\% of the
    #'              time during the training Rule will return True.
    #' @param gpu_threshold : threshold that defines when GPU is considered being under-utilized.
    #'              Default is 70\%
    #' @param io_threshold : threshold that defines high IO wait time. Default is above 50\%
    #' @param patience : How many values to record before checking for IO bottlenecks. During
    #'              training initilization, GPU is likely at 0 percent, so Rule should not check
    #'              for underutilization immediatly. Default 1000.
    #' @param scan_interval_us : interval with which timeline files are scanned. Default is 60000000 us.
    initialize = function(threshold=50,
                          gpu_threshold=10,
                          io_threshold=50,
                          patience=1000,
                          scan_interval_us=60 * 1000 * 1000){
      validate_percentile("threshold", threshold)
      validate_percentile("gpu_threshold", gpu_threshold)
      validate_percentile("io_threshold", io_threshold)
      validate_positive_integer("patience", patience)
      validate_positive_integer("scan_interval_us", scan_interval_us)

      super$initialize(
        threshold=threshold,
        gpu_threshold=gpu_threshold,
        io_threshold=io_threshold,
        patience=patience,
        scan_interval_us=scan_interval_us)
    }
  ),
  lock_objects = F
)

#' @title Debugger LoadBalancing class
#' @description This rule helps to detect issues in workload balancing between multiple GPUs.
#'              It computes a histogram of utilization per GPU and measures the distance between
#'              those histograms. If the histogram exceeds a pre-defined threshold then rule triggers.
#' @export
LoadBalancing = R6Class("LoadBalancing",
  inherit = ProfilerRuleBase,
  public = list(

    #' @description Initialize LoadBalancing class
    #' @param threshold : difference between 2 histograms 0.5
    #' @param patience : how many values to record before checking for loadbalancing issues
    #' @param scan_interval_us : interval with which timeline files are scanned. Default is 60000000 us.
    initialize = function(threshold=0.5,
                          patience=1000,
                          scan_interval_us=60 * 1000 * 1000){
      validate_percentile("threshold", threshold)
      validate_positive_integer("patience", patience)
      validate_positive_integer("scan_interval_us", scan_interval_us)

      super$initialize(
        threshold=threshold,
        patience=patience,
        scan_interval_us=scan_interval_us)
    }
  ),
  lock_objects = F
)

#' @title Debugger LowGPUUtilization class
#' @description This rule helps to detect if GPU utilization is low or suffers from
#'              fluctuations. This is checked for each single GPU on each worker node.
#'              Rule returns True if 95th quantile is below threshold_p95 which indicates
#'              under-utilization. Rule returns true if 95th quantile is above threshold_p95
#'              and 5th quantile is below threshold_p5 which indicates fluctuations.
#' @export
LowGPUUtilization = R6Class("LowGPUUtilization",
  inherit = ProfilerRuleBase,
  public = list(

    #' @description Initialize LowGPUUtilization class
    #' @param threshold_p95 : threshold for 95th quantile below which GPU is considered
    #'              to be underutilized. Default is 70 percent.
    #' @param threshold_p5 : threshold for 5th quantile. Default is 10 percent.
    #' @param window : number of past datapoints which are used to compute the quantiles.
    #' @param patience : How many values to record before checking for underutilization/fluctuations.
    #'              During training initilization, GPU is likely at 0 percent, so Rule should not
    #'              check for underutilization immediately. Default 1000.
    #' @param scan_interval_us : interval with which timeline files are scanned. Default is 60000000 us.
    initialize = function(threshold_p95=70,
                          threshold_p5=10,
                          window=500,
                          patience=1000,
                          scan_interval_us=60 * 1000 * 1000){
      validate_percentile("threshold_p95", threshold_p95)
      validate_percentile("threshold_p5", threshold_p5)
      validate_positive_integer("window", window)
      validate_positive_integer("patience", patience)
      validate_positive_integer("scan_interval_us", scan_interval_us)

      super$initialize(
        threshold_p95=threshold_p95,
        threshold_p5=threshold_p5,
        window=window,
        patience=patience,
        scan_interval_us=scan_interval_us)
    }
  ),
  lock_objects = F
)

#' @title Debugger MaxInitializationTime class
#' @description This rule helps to detect if the training intialization is taking too
#'              much time. The rule waits until first step is available.
#' @export
MaxInitializationTime = R6Class("MaxInitializationTime",
  inherit = ProfilerRuleBase,
  public = list(

    #' @description Initialize MaxInitializationTime class
    #' @param threshold : defines the threshold in minutes to wait for first step to
    #'              become available. Default is 20 minutes.
    #' @param scan_interval_us : interval with which timeline files are scanned. Default is 60000000 us.
    initialize = function(threshold=20,
                          scan_interval_us=60 * 1000 * 1000){
      validate_positive_integer("threshold", threshold)
      validate_positive_integer("scan_interval_us", scan_interval_us)

      super$initialize(
        threshold=threshold,
        scan_interval_us=scan_interval_us)
    }
  ),
  lock_objects = F
)

#' @title Debugger OverallSystemUsage class
#' @description This rule measures overall system usage per worker node. The rule
#'              currently only aggregates values per node and computes their percentiles. The
#'              rule does currently not take any threshold parameters into account nor can it trigger.
#'              The reason behind that is that other rules already cover cases such as under utilization
#'              and they do it at a more fine-grained level e.g. per GPU. We may change this in the future.
#' @export
OverallSystemUsage = R6Class("OverallSystemUsage",
  inherit = ProfilerRuleBase,
  public = list(

    #' @description Initialize OverallSystemUsage class
    #' @param scan_interval_us : interval with which timeline files are scanned. Default is 60000000 us.
    initialize = function(scan_interval_us=60 * 1000 * 1000){
      validate_positive_integer("scan_interval_us", scan_interval_us)

      super$initialize(scan_interval_us=scan_interval_us)
    }
  ),
  lock_objects = F
)

#' @title Debugger StepOutlier class
#' @description This rule helps to detect outlier in step durations. Rule returns
#'              True if duration is larger than stddev * standard deviation.
#' @export
StepOutlier = R6Class("StepOutlier",
  inherit = ProfilerRuleBase,
  public = list(

    #' @description Initialize StepOutlier class
    #' @param stddev : factor by which to multiply the standard deviation. Default is 3
    #' @param mode : select mode under which steps have been saved and on which Rule should run on.
    #'              Per default rule will run on steps from EVAL and TRAIN phase.
    #' @param n_outliers : How many outliers to ignore before rule returns True. Default 10.
    #' @param scan_interval_us : interval with which timeline files are scanned. Default is 60000000 us.
    initialize = function(stddev=3,
                          mode=NULL,
                          n_outliers=10,
                          scan_interval_us=60 * 1000 * 1000){
      validate_positive_integer("stddev", stddev)
      if(!(is.null(mode) || is.character(mode))) stop("Mode must be a string if specified!", call. = F)
      validate_positive_integer("n_outliers", n_outliers)
      validate_positive_integer("scan_interval_us", scan_interval_us)

      super$initialize(
        stddev=stddev,
        mode=mode,
        n_outliers=n_outliers,
        scan_interval_us=scan_interval_us)
    }
  ),
  lock_objects = F
)

#' @title Debugger ProfilerReport class
#' @description This rule will create a profiler report after invoking all of the rules. The parameters
#'              used in any of these rules can be customized by following this naming scheme:
#'              <rule_name>_<parameter_name> : value
#'              Validation is also done here to ensure that:
#'              \itemize{
#'                \item{The key names follow the above format}
#'                \item{rule_name corresponds to a valid rule name.}
#'                \item{parameter_name corresponds to a valid parameter of this rule.}
#'                \item{The parameter for this rule's parameter is valid.}
#'              }
#' @export
ProfilerReport = R6Class("ProfilerReport",
  inherit = ProfilerRuleBase,
  public = list(

    #' @description Initialize ProfilerReport class
    # #' @param opt_out_telemetry : Place holder
    #' @param ... : Dictionary mapping rule + parameter name to value.
    initialize = function(# opt_out_telemetry = FALSE, # revert test for 1.0.1 to be compatible with sagemaker-python-sdk
                          ...){
      rule_parameters = list(...)

      rule_classes = private$.get_rules()
      rule_names = lapply(rule_classes, function(x) x$classname)
      names(rule_classes) = tolower(rule_names)
      # validate_boolean(class(self)[[1]], "opt_out_telemetry", opt_out_telemetry)

      formatted_rule_parameters = list()

      for (i in seq_along(rule_parameters)){
        key = names(rule_parameters)[i]
        val = rule_parameters[[i]]
        if(!grepl("_", key))
          stopf(invalid_key_format_error, key)
        splits = split_str(key, "_")
        rule_name = tolower(splits[1])
        parameter_name = paste0(tolower(splits[-1]), collapse = "_")
        if(!(rule_name %in% names(rule_classes)))
          stopf(invalid_rule_error, rule_name, paste(rule_names, collapse =", "))
        rule_class = rule_classes[[rule_name]]
        init_params = as.list(val)
        names(init_params) = parameter_name
        tryCatch({
          do.call(rule_class$new, init_params)
        },
        error = function(e){
          rule_args = names(Filter(Negate(is.null), as.list(args(rule_class$public_methods$initialize))))
          stopf(invalid_param_error, parameter_name, rule_class$classname, paste(rule_args,  collapse =", "))
        })
        formatted_key = sprintf("%s_%s", rule_class$classname, parameter_name)
        formatted_rule_parameters[[formatted_key]] = val
      }
      super$initialize(
        # opt_out_telemetry=opt_out_telemetry, # revert test for 1.0.1 to be compatible with sagemaker-python-sdk
        # custom_rule_parameters=formatted_rule_parameters # revert test for 1.0.1 to be compatible with sagemaker-python-sdk
        ...
      )
    }
  ),
  private = list(
    .get_rules = function(){
      return(list(
        BatchSize,
        CPUBottleneck,
        Dataloader,
        GPUMemoryIncrease,
        IOBottleneck,
        LoadBalancing,
        LowGPUUtilization,
        MaxInitializationTime,
        OverallSystemUsage,
        StepOutlier)
      )
    }
  ),
  lock_objects = F
)
