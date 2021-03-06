% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/profiler_rules_rules.R
\name{Dataloader}
\alias{Dataloader}
\title{Debugger Dataloader class}
\description{
This rule helps to detect how many dataloader processes are running
             in parallel and whether the total number is equal the number of available CPU cores.
}
\section{Super class}{
\code{\link[sagemaker.debugger:ProfilerRuleBase]{sagemaker.debugger::ProfilerRuleBase}} -> \code{Dataloader}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{Dataloader$new()}}
\item \href{#method-clone}{\code{Dataloader$clone()}}
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
Initialize Dataloader class
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Dataloader$new(
  min_threshold = 70,
  max_threshold = 200,
  scan_interval_us = 6e+07
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{min_threshold}}{: how many cores should be at least used by dataloading processes. Default 70\%}

\item{\code{max_threshold}}{: how many cores should be at maximum used by dataloading processes. Default 200\%}

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
\if{html}{\out{<div class="r">}}\preformatted{Dataloader$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
