# NOTE: This code has been modified from AWS Sagemaker Python:
# https://github.com/awslabs/sagemaker-debugger-rulesconfig/blob/master/smdebug_rulesconfig/actions/actions.py

#' @include r_utils.R
#' @include actions_utils.R

#' @import R6
#' @importFrom jsonlite toJSON

#' @title Debugger Action Class
#' @description Base class for action, which is to be invoked when a rule fires.
#'              Offers `serialize` function to convert action parameters to a
#'              string dictionary.
#' @export
Action = R6Class("Action",
  public = list(

    #' @description This class is not meant to be initialized directly.
    #'              Accepts dictionary of action parameters and drops keys whose values are `None`.
    #' @param ... : Dictionary of action parameters.
    initialize = function(...){
      action_parameters = list(...)
      action_parameters[["name"]] = tolower(class(self)[[1]])
      self$action_parameters = Filter(Negate(is.null), action_parameters)
      validate_action_str(
        self$serialize(), self$action_parameters
      )  # sanity check, not expected to error!
    },

    #' @description Serialize the action parameters as a string dictionary.
    #' @return Action parameters serialized as a string dictionary.
    serialize = function(){
      return (jsonlite::toJSON(self$action_parameters, auto_unbox = T))
    },

    #' @description format class
    format_class = function(){
      format_class(self)
    }
  ),
  lock_objects = F
)

#' @title Debugger ActionList Action Class
#' @description Higher level object to maintain a list of actions to be invoked
#'              when a rule is fired.
#' @export
ActionList = R6Class("ActionList",
  public = list(

    #' @description Offers higher level `serialize` function to
    #'              handle serialization of actions as a string list of dictionaries.
    #' @param actions : List of actions.
    initialize = function(actions){
      stopifnot(
        is.list(actions)
      )
      if (!all(sapply(actions, function(action) inherits(action, "Action"))))
        stopf("actions must be list of Action objects!")
      self$actions = actions
    },

    #' @description For any StopTraining actions in the action list, update the trainingjob
    #'              prefix to be the training job name if the user has not already specified
    #'              a custom training job prefix. This is meant to be called via the sagemaker
    #'              SDK when `estimator.fit` is called by the user. Validation is purposely
    #'              excluded here so that any failures in validation of the training job name
    #'              are intentionally caught in the sagemaker SDK and not here.
    #' @param training_job_name : Name of the training job, passed in when `estimator.fit` is called.
    update_training_job_prefix_if_specified = function(training_job_name){
      for (action in self$actions){
        if (inherits(action, "StopTraining"))
          action$update_training_job_prefix_if_not_specified(training_job_name)
      }
    },

    #' @description Serialize the action parameters as a string dictionary.
    #' @return  Action parameters serialized as a string dictionary.
    serialize = function(){
      parts = paste(lapply(self$actions, function(action) action$serialize()), collapse="\n")
      return(paste0("[", parts, "]"))
    }
  ),
  lock_objects = F
)

#' @title Debugger StopTraining Action class
#' @description Action for stopping the training job when a rule is fired.
#' @export
StopTraining = R6Class("StopTraining",
  inherit = Action,
  public = list(

    #' @description Note that a policy must be created in the AWS account to allow the sagemaker
    #'              role to stop the training job.
    #' @param training_job_prefix : The prefix of the training job to stop if the rule is fired.
    #'              This must only refer to one active training job, otherwise no training job will
    #'              be stopped.
    initialize = function(training_job_prefix=NULL){
      self$use_default_training_job_prefix = TRUE
      if (!is.null(training_job_prefix))
        validate_training_job_prefix("training_job_prefix", training_job_prefix)
      self$use_default_training_job_prefix = FALSE
      super$initialize(training_job_prefix=training_job_prefix)
    },

    #' @description Update the training job prefix to be the training job name if the user
    #'              has not already specified a custom training job prefix. This is only meant
    #'              to be called via the sagemaker SDK when `estimator.fit` is called by the
    #'              user. Validation is purposely excluded here so that any failures in validation
    #'              of the training job name are intentionally caught in the sagemaker SDK and not here.
    #' @param training_job_name : Name of the training job, passed in when `estimator.fit` is called.
    update_training_job_prefix_if_not_specified = function(training_job_name){
      if (!is.null(self$use_default_training_job_prefix))
        self$action_parameters[["training_job_prefix"]] = training_job_name
    }
  ),
  lock_objects = F
)

#' @title Debugger Email Action class
#' @description Action for sending an email to the provided email address when
#'              the rule is fired. Note that a policy must be created in the AWS
#'              account to allow the sagemaker role to send an email to the user.
#' @export
Email = R6Class("Email",
  inherit = Action,
  public = list(

    #' @description Initialize Email action class.
    #' @param email_address : Email address to send the email notification to.
    initialize = function(email_address){
      validate_email_address("email_address", email_address)
      super$initialize(endpoint=email_address)
    }
  ),
  lock_objects = F
)

#' @title Debugger SMS Action Class
#' @description Action for sending an SMS to the provided phone number when the rule
#'              is fired. Note that a policy must be created in the AWS account to allow
#'              the sagemaker role to send an SMS to the user.
#' @export
SMS = R6Class("SMS",
  inherit = Action,
  public = list(

    #' @description Initialize SMS action class
    #' @param phone_number : Valid phone number that follows the the E.164 format. See
    #'              \url{https://docs.aws.amazon.com/sns/latest/dg/sms_publish-to-phone.html}
    #'              for more info.
    initialize = function(phone_number){
      validate_phone_number("phone_number", phone_number)
      super$initialize(endpoint=phone_number)
    }
  ),
  lock_objects = F
)

# Helper function to be used by the sagemaker SDK to determine whether the provided
# object is a valid action object or not (must be of type `Action` or `ActionList`.
# :param actions: actions object specified by the user when calling `Rule.sagemaker` in the
# sagemaker SDK.
# :return: Boolean for whether the provided actions object is valid or not.
is_valid_action_object = function(actions){
  return(inherits(actions, c("Action", "ActionList")))
}
