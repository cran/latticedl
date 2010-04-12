\name{label.positions}
\Rdversion{1.1}
\alias{label.positions}
\title{label positions}
\description{Calculates table of positions of each label. It does not draw anything, but is called for its return value. Normally you don't have to call label.positions explicitly. Instead, it is called for you by direct.label.}
\usage{
label.positions(x, y, subscripts, groups, debug = FALSE, method, ...)
}
\arguments{
  \item{x}{x values of points to draw.}
  \item{y}{y values of points to draw.}
  \item{subscripts}{Subscripts of groups to consider.}
  \item{groups}{Vector of groups.}
  \item{debug}{Show debug output? If TRUE, the resulting table of label positions will be printed.}
  \item{method}{Method for direct labeling, specified in one of the following ways: (1) a Positioning Function, (2) the name of a Positioning Function as a character string, or (3) a list containing any number of (1), (2), or additionally named values. Starting from the data frame of points to plot for the panel, the elements of the list are applied in sequence, and each row of the resulting data frame is used to draw a direct label. See examples in ?direct.label and ?positioning.functions. NULL indicates to choose a Positioning Function based on the high-level plot function chosen (this is done in panel.superpose.dl).}
  \item{\dots}{Passed to positioning method(s).}
}
\details{
}
\value{Data frame of direct label positions. Each row describes the position of 1 label to be drawn later.}
\references{
}
\author{Toby Dylan Hocking <toby.hocking@inria.fr>}
\note{
}


\seealso{
}
\examples{}