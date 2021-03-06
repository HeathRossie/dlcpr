% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read.all.r
\name{read.all}
\alias{read.all}
\title{The function all csv files and combine}
\usage{
read.all(
  files,
  serialnumber = TRUE,
  direc = NULL,
  fps = NULL,
  spline = TRUE,
  threshold = 0.9
)
}
\arguments{
\item{[serialnumber]}{if TRUE, serial number variables are added, which index each set of trajectories}

\item{[direc]}{optional: directory of csv files}

\item{[fps]}{optional: camera fps}

\item{[spline]}{if TRUE , drop frames of low likelihood frames and interpolate with smooth spline function. Since peformance of extrapolation is serverely bad, initial and last dropped frames would be NA. Default is TRUE.}

\item{[threshold]}{threshold for dropping frames if spine = TRUE. Default is .9}
}
\value{
data frame of trajectories. "ser" variable specify time series of trajectories, if serialnumber=TRUE.
}
\description{
The function all csv files and combine
}
