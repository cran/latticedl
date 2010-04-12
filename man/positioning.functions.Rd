\name{positioning.functions}
\Rdversion{1.1}
\alias{positioning.functions}
\alias{positioning.function}
\alias{Positioning.Function}
\alias{Positioning.Functions}
\title{Built-in Positioning Functions for direct label placement}
\description{When adding direct labels to a grouped plot, label
  placement can be specified using a Positioning Function (or a list of
  them), of the form function(d,...), where d is a data frame of the
  points to plot, with columns x y groups. The job of the Positioning
  Function(s) is to return the position of each direct label you want to
  plot as a data frame, with 1 row for each label. Thus normally a
  Positioning Function will return 1 row for each group. Several
  built-in Positioning Functions are discussed below, but you can also
  create your own, either from scratch or by using dl.indep and
  dl.trans.}
\usage{
## Longitudinal data:
## first.points
## left.points    ## same as first.points
## last.points
## right.points   ## same as last.points
## bottom.points
## low.points     ## same as bottom.points

## Also good for density plots:
## top.points
## high.points    ## same as top.points

## Scatter plots:
## get.means
## perpendicular.lines
## empty.grid
## empty.grid.2
}
\arguments{
  \item{d}{Data frame of points to plot, with columns x y groups.}
  \item{...}{Ignored.}
}
\details{
}
\value{Data frame of label positions.}
\references{
}
\author{Toby Dylan Hocking <toby.hocking@inria.fr>}
\note{
}


\seealso{
}
