#' @title Retrieve value labels of labelled data
#' @name get_labels
#'
#' @description This function returns the value labels of labelled data.
#'
#' @seealso See \href{http://www.strengejacke.de/sjPlot/}{online documentation}
#'            for more details; \code{\link{set_labels}} to manually set value
#'            labels, \code{\link{get_label}} to get variable labels and
#'            \code{\link{get_values}} to retrieve the values associated
#'            with value labels.
#'
#' @param x A data frame with variables that have value label attributes (e.g.
#'          from an imported SPSS, SAS or STATA data set, via \code{\link{read_spss}},
#'          \code{\link{read_sas}} or \code{\link{read_stata}}); a variable
#'          (vector) with value label attributes; or a \code{list} of variables
#'          with values label attributes. If \code{x} has no label attributes,
#'          factor levels are returned. See 'Examples'.
#' @param include.values String, indicating whether the values associated with the
#'          value labels are returned as well. If \code{include.values = "as.name"}
#'          (or \code{include.values = "n"}), values are set as \code{\link{names}}
#'          attribute of the returned object. If \code{include.values = "as.prefix"}
#'          (or \code{include.values = "p"}), values are included as prefix
#'          to each label. See 'Examples'.
#' @param attr.only Logical, if \code{TRUE}, labels are only searched for
#'          in the the vector's \code{\link{attributes}}; else, if \code{attr.only = FALSE}
#'          and \code{x} has no label attributes, factor levels or string values
#'          are returned. See 'Examples'.
#' @param include.non.labelled Logical, if \code{TRUE}, values without labels will
#'          also be included in the returned labels (see \code{\link{fill_labels}}).
#' @param drop.na Logical, whether labels of tagged NA values (see \code{\link[haven]{tagged_na}})
#'          should be included in the return value or not. By default, labelled
#'          (tagged) missing values are not returned. See \code{\link{get_na}}
#'          for more details on tagged NA values.
#' @param drop.unused Logical, if \code{TRUE}, unused labels will be removed from
#'          the return value.
#' @return Either a list with all value labels from all variables if \code{x}
#'           is a \code{data.frame} or \code{list}; a string with the value
#'           labels, if \code{x} is a variable;
#'           or \code{NULL} if no value label attribute was found.
#'
#' @details This package can add (and read) value and variable labels either in \CRANpkg{foreign}
#'            package style (attributes are named \emph{value.labels} and \emph{variable.label})
#'            or in \CRANpkg{haven} package style (attributes are named \emph{labels} and
#'            \emph{label}). By default, the \pkg{haven} package style is used.
#'            \cr \cr
#'            Working with labelled data is a key feature of the \CRANpkg{sjPlot} package,
#'            which accesses these attributes to automatically read label attributes
#'            for labelling axis categories and titles or table rows and columns
#'            in graphical or tabular outputs.
#'            \cr \cr
#'            When working with labelled data, you can, e.g., use
#'            \code{\link{get_label}} or \code{\link{get_labels}}
#'            to get a vector of value and variable labels, which can then be
#'            used with other functions like \code{\link{barplot}} etc.
#'            See 'Examples'. Furthermore, value and variable labels are used
#'            when saving data, e.g. to SPSS (see \code{\link{write_spss}}),
#'            which means that the written SPSS file contains proper labels
#'            for each variable.
#'
#' @note This function works with vectors that have value and variable
#'        label attributes (as provided, for instance, by \code{\link[haven]{labelled}}
#'        objects). Adding label attributes is automatically done when importing data sets
#'        with the \code{\link{read_spss}}, \code{\link{read_sas}} or \code{\link{read_stata}}
#'        functions. Labels can also manually be added using the \code{\link{set_labels}}
#'        and \code{\link{set_label}} functions. If vectors \emph{do not} have
#'        label attributes, either factor-levels or the numeric values
#'        of the vector are returned as labels.
#'        \cr \cr
#'        Most functions of the \CRANpkg{sjPlot} package make use of value and variable
#'        labels to automatically label axes, legend or title labels in plots
#'        (\code{sjp.}-functions) respectively column or row headers in table
#'        outputs (\code{sjt.}-functions). See
#'        \href{http://www.strengejacke.de/sjPlot/datainit/}{this} and
#'        \href{http://www.strengejacke.de/sjPlot/labelleddata/}{this}
#'        online manual for more details.
#'
#' @examples
#' # import SPSS data set
#' # mydat <- read_spss("my_spss_data.sav")
#'
#' # retrieve variable labels
#' # mydat.var <- get_label(mydat)
#'
#' # retrieve value labels
#' # mydat.val <- get_labels(mydat)
#'
#' data(efc)
#' get_labels(efc$e42dep)
#'
#' # simple barplot
#' barplot(table(efc$e42dep))
#' # get value labels to annotate barplot
#' barplot(table(efc$e42dep),
#'         names.arg = get_labels(efc$e42dep),
#'         main = get_label(efc$e42dep))
#'
#' # include associated values
#' get_labels(efc$e42dep, include.values = "as.name")
#'
#' # include associated values
#' get_labels(efc$e42dep, include.values = "as.prefix")
#'
#' # get labels from multiple variables
#' get_labels(list(efc$e42dep, efc$e16sex, efc$e15relat))
#'
#'
#' # create a dummy factor
#' f1 <- factor(c("hi", "low", "mid"))
#' # search for label attributes only
#' get_labels(f1, attr.only = TRUE)
#' # search for factor levels as well
#' get_labels(f1)
#'
#' # same for character vectors
#' c1 <- c("higher", "lower", "mid")
#' # search for label attributes only
#' get_labels(c1, attr.only = TRUE)
#' # search for string values as well
#' get_labels(c1)
#'
#'
#' # create vector
#' x <- c(1, 2, 3, 2, 4, NA)
#' # add less labels than values
#' x <- set_labels(x, labels = c("yes", "maybe", "no"), force.values = FALSE)
#' # get labels for labelled values only
#' get_labels(x)
#' # get labels for all values
#' get_labels(x, include.non.labelled = TRUE)
#'
#'
#' # get labels, including tagged NA values
#' library(haven)
#' x <- labelled(c(1:3, tagged_na("a", "c", "z"), 4:1),
#'               c("Agreement" = 1, "Disagreement" = 4, "First" = tagged_na("c"),
#'                 "Refused" = tagged_na("a"), "Not home" = tagged_na("z")))
#' # get current NA values
#' x
#' get_labels(x, include.values = "n", drop.na = FALSE)
#'
#'
#' # create vector with unused labels
#' data(efc)
#' efc$e42dep <- set_labels(
#'   efc$e42dep,
#'   labels = c("independent" = 1, "dependent" = 4, "not used" = 5)
#' )
#' get_labels(efc$e42dep)
#' get_labels(efc$e42dep, drop.unused = TRUE)
#' get_labels(efc$e42dep, include.non.labelled = TRUE, drop.unused = TRUE)
#'
#' @export
get_labels <- function(x, attr.only = FALSE, include.values = NULL,
                       include.non.labelled = FALSE, drop.na = TRUE, drop.unused = FALSE) {
  UseMethod("get_labels")
}

#' @export
get_labels.data.frame <- function(x, attr.only = FALSE, include.values = NULL,
                                  include.non.labelled = FALSE, drop.na = TRUE,
                                  drop.unused = FALSE) {
  lapply(x, FUN = get_labels_helper, attr.only = attr.only, include.values = include.values,
         include.non.labelled = include.non.labelled, drop.na = drop.na, drop.unused = drop.unused)
}

#' @export
get_labels.list <- function(x, attr.only = FALSE, include.values = NULL,
                            include.non.labelled = FALSE, drop.na = TRUE, drop.unused = FALSE) {
  lapply(x, FUN = get_labels_helper, attr.only = attr.only, include.values = include.values,
         include.non.labelled = include.non.labelled, drop.na = drop.na, drop.unused = drop.unused)
}

#' @export
get_labels.default <- function(x, attr.only = FALSE, include.values = NULL,
                               include.non.labelled = FALSE, drop.na = TRUE,
                               drop.unused = FALSE) {
  get_labels_helper(x, attr.only = attr.only, include.values = include.values,
                    include.non.labelled = include.non.labelled, drop.na = drop.na,
                    drop.unused = drop.unused)
}

# Retrieve value labels of a data frame or variable
# See 'get_labels'
#' @importFrom haven is_tagged_na na_tag
get_labels_helper <- function(x, attr.only, include.values, include.non.labelled, drop.na, drop.unused) {
  labels <- NULL
  add_vals <- NULL
  # get label attribute, which may differ depending on the package
  # used for reading the data
  attr.string <- getValLabelAttribute(x)
  # if variable has no label attribute, use factor levels as labels
  if (is.null(attr.string)) {
    # only use factor level if explicitly chosen by user
    if (!attr.only) {
      # get levels of vector
      lv <- levels(x)
      # do we have any levels?
      if (!is.null(lv)) {
        labels <- lv
      } else if (is.character(x)) {
        # finally, if we even don't have values, check for
        # character elements
        labels <- unique(x)
      }
    }
  } else {
    # retrieve named labels
    lab <- attr(x, attr.string, exact = T)
    # drop na?
    if (drop.na) lab <- lab[!haven::is_tagged_na(lab)]
    # check if we have anything
    if (!is.null(lab) && length(lab) > 0) {
      # sort labels
      lab <- lab[order(lab)]
      # retrieve values associated with labels. for character vectors
      # or factors with character levels, these values are character values,
      # else, they are numeric values
      if (is.character(x) || (is.factor(x) && !is_num_fac(x)))
        values <- unname(lab)
      else
        values <- as.numeric(unname(lab))
      # retrieve label values in correct order
      labels <- names(lab)
      # do we have any tagged NAs? If so, get tagged NAs
      # and annotate them properly
      if (any(haven::is_tagged_na(values))) {
        values[haven::is_tagged_na(values)] <- paste0("NA(", haven::na_tag(values[haven::is_tagged_na(values)]), ")")
      }
      # do we want to include non-labelled values as well? if yes,
      # find all values in variable that have no label attributes
      if (include.non.labelled) {
        # get values of variable
        valid.vals <- sort(unique(stats::na.omit(as.vector(x))))
        # check if we have different amount values than labels
        # or, if we have same amount of values and labels, whether
        # values and labels match or not
        if (length(valid.vals) != length(labels) || anyNA(match(values, valid.vals))) {
          # We now need to know, which values of "x" don't
          # have labels.
          add_vals <- valid.vals[!valid.vals %in% values]
          # add to labels
          labels <- c(labels, as.character(add_vals))
          # fix value prefix
          new_vals <- c(as.character(values), as.character(add_vals))
          # check if values are numeric or not. if not,
          # make sure it's character, so we can order
          # consistently
          if (suppressWarnings(anyNA(as.numeric(values)))) {
            orderpart <- as.character(values)
          } else {
            orderpart <- as.numeric(values)
          }
          # sort values and labels
          labels <- labels[order(c(orderpart, add_vals))]
          new_vals <- new_vals[order(c(orderpart, add_vals))]
          # set back new values
          values <- new_vals
        }
      }
      # include associated values?
      if (!is.null(include.values)) {
        # for backwards compatibility, we also accept "TRUE"
        # here we set values as names-attribute
        if ((is.logical(include.values) && isTRUE(include.values)) ||
            include.values == "as.name" || include.values == "n") {
          names(labels) <- values
        }
        # here we include values as prefix of labels
        if (include.values == "as.prefix" || include.values == "p") {
          if (is.numeric(values))
            labels <- sprintf("[%i] %s", values, labels)
          else
            labels <- sprintf("[%s] %s", values, labels)
        }
      }
    }
  }
  # foreign? then reverse order
  if (is_foreign(attr.string)) labels <- rev(labels)

  # drop unused labels with no values in data
  if (drop.unused) {
    # get all values
    av <- c(get_values(x, drop.na = drop.na), add_vals)
    # drop unused values
    if (!is.null(av)) labels <- labels[sort(av) %in% names(table(x))]
  }

  # return them
  return(labels)
}
