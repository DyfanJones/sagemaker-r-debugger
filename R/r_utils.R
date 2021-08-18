`%||%` <- function(x, y) if (is.null(x)) return(y) else return(x)

format_class <- function(self){
  sprintf(
    "<%s at %s>\n",
    class(self)[1],
    data.table::address(self))
}

# helper function add sprintf functionality to stop functions.
stopf <- function(fmt, ...){
  msg = sprintf(fmt, ...)
  stop(msg, call. = FALSE)
}

split_str <- function(str, split = ",") unlist(strsplit(str, split = split))
