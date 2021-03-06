% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/set_label.R, R/var_labels.R
\name{set_label}
\alias{set_label}
\alias{set_label<-}
\alias{var_labels}
\title{Add variable label(s) to variables}
\usage{
set_label(x, lab, attr.string = NULL)

set_label(x, attr.string = NULL) <- value

var_labels(x, ...)
}
\arguments{
\item{x}{Variable (vector), list of variables or a data frame where variables
labels should be added as attribute. For \code{var_labels()}, \code{x}
must be a data frame only.}

\item{lab}{If \code{x} is a vector (single variable), use a single character string with
the variable label for \code{x}. If \code{x} is a data frame, use a
vector with character labels of same length as \code{ncol(x)}.
Use \code{lab = ""} to remove labels-attribute from \code{x}, resp.
set any value of vector \code{lab} to \code{""} to remove specific variable
label attributes from a data frame's variable.}

\item{attr.string}{Attribute string for the variable label. \strong{Note:}
Usually, this argument should be ignored. It is only used internally
for the \code{\link{write_spss}} and \code{\link{write_stata}} functions.}

\item{value}{See \code{lab}.}

\item{...}{Pairs of named vectors, where the name equals the variable name,
which should be labelled, and the value is the new variable label.}
}
\value{
\code{x}, with variable label attribute(s), which contains the
          variable name(s); or with removed label-attribute if
          \code{lab = ""}.
}
\description{
This function adds variable labels as attribute
               (named \code{"label"}) to the variable \code{x}, resp. to a
               set of variables in a data frame or a list-object. \code{var_labels()}
               is intended for use within pipe-workflows and has a tidyverse-consistent
               syntax (see 'Examples').
}
\details{
See 'Details' in \code{\link{get_labels}}
}
\note{
See 'Note' in \code{\link{get_labels}}
}
\examples{
# sample data set, imported from SPSS.
data(efc)
frq(efc$e42dep)

# manually set value and variable labels
dummy <- sample(1:4, 40, replace = TRUE)
dummy <- set_labels(dummy, labels = c("very low", "low", "mid", "hi"))
dummy <- set_label(dummy, lab = "Dummy-variable")

# or use:
# set_label(dummy) <- "Dummy-variable"

# auto-detection of value labels by default, auto-detection of
# variable labels if argument "title" set to NULL.
\dontrun{
library(sjPlot)
sjp.frq(dummy, title = NULL)}


# Set variable labels for data frame
dummy <- data.frame(a = sample(1:4, 10, replace = TRUE),
                    b = sample(1:4, 10, replace = TRUE),
                    c = sample(1:4, 10, replace = TRUE))
dummy <- set_label(dummy, c("Variable A", "Variable B", "Variable C"))
str(dummy)

# remove one variable label
dummy <- set_label(dummy, c("Variable A", "", "Variable C"))
str(dummy)


# setting same variable labels to multiple vectors

# create a set of dummy variables
dummy1 <- sample(1:4, 40, replace = TRUE)
dummy2 <- sample(1:4, 40, replace = TRUE)
dummy3 <- sample(1:4, 40, replace = TRUE)
# put them in list-object
dummies <- list(dummy1, dummy2, dummy3)
# and set variable labels for all three dummies
dummies <- set_label(dummies, c("First Dummy", "2nd Dummy", "Third dummy"))
# see result...
get_label(dummies)


# use 'var_labels()' to set labels within a pipe-workflow, and
# when you need "tidyverse-consistent" api.
library(dplyr)
# Set variable labels for data frame
dummy <- data.frame(a = sample(1:4, 10, replace = TRUE),
                    b = sample(1:4, 10, replace = TRUE),
                    c = sample(1:4, 10, replace = TRUE))

dummy \%>\%
  var_labels(a = "First variable", c = "third variable") \%>\%
  get_label()

}
\seealso{
The sjPlot manual on \href{http://www.strengejacke.de/sjPlot/datainit/}{data initialization} or
           \href{http://www.strengejacke.de/sjPlot/view_spss/}{inspecting (SPSS imported) data frames} for
           more details; \code{\link{set_labels}} to manually set value labels or \code{\link{get_label}}
           to get variable labels.
}
