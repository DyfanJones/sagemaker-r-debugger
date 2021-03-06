% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/profiler_rules_rules.R
\name{StepOutlier}
\alias{StepOutlier}
\title{Debugger StepOutlier class}
\description{
This rule helps to detect outlier in step durations. Rule returns
             True if duration is larger than stddev * standard deviation.
}
\section{Super class}{
\code{\link[sagemaker.debugger:ProfilerRuleBase]{sagemaker.debugger::ProfilerRuleBase}} -> \code{StepOutlier}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{StepOutlier$new()}}
\item \href{#method-clone}{\code{StepOutlier$clone()}}
}
}
\if{html}{
\out{<details open ><summary>Inherited methods</summary>}
\itemize{
\item \out{<span class="pkg-link" data-pkg="sagemaker.debugger" data-topic="ProfilerRuleBase" data-id="format">}\href{../../sagemaker.debugger/html/ProfilerRuleBase.html#method-format}{\code{sagemaker.debugger::ProfilerRuleBase$format()}}\out{</span>}
}
\out{</details>}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
Initialize StepOutlier class
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{StepOutlier$new(
  stddev = 3,
  mode = NULL,
  n_outliers = 10,
  scan_interval_us = 60 * 1000 * 1000
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{stddev}}{: factor by which to multiply the standard deviation. Default is 3}

\item{\code{mode}}{: select mode under which steps have been saved and on which Rule should run on.
Per default rule will run on steps from EVAL and TRAIN phase.}

\item{\code{n_outliers}}{: How many outliers to ignore before rule returns True. Default 10.}

\item{\code{scan_interval_us}}{: interval with which timeline files are scanned. Default is 60000000 us.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{StepOutlier$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
