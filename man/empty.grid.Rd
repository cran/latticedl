\name{empty.grid}
\Rdversion{1.1}
\alias{empty.grid}
\title{empty grid}
\description{Label placement method for scatterplots that ensures labels are placed in different places. A grid is drawn over the whole plot. Each cluster is considered in sequence and assigned to the point on this grid which is closest to the point given by loc.fun().}
\usage{
empty.grid(d, debug = FALSE, loc.fun = get.means, ...)
}
\arguments{
  \item{d}{Data frame of points on the scatterplot with columns groups x y.}
  \item{debug}{Show debugging info on the plot? This is passed to loc.fun.}
  \item{loc.fun}{Function that takes d and returns a data frame with 1 column for each group, giving the point we will use to look for a close point on the grid, to put the group label.}
  \item{\dots}{ignored.}
}
\details{
}
\value{Data frame with columns groups x y, 1 line for each group, giving the positions on the grid closest to each cluster.}
\references{
}
\author{Toby Dylan Hocking <toby.hocking@inria.fr>}
\note{
}


\seealso{
}
\examples{library(latticedl)
library(proto)
library(ggplot2)
data(mpg)
m <- lm(cty~displ,data=mpg)
mpgf <- fortify(m,mpg)
plot(dl(xyplot,mpgf,.resid~.fitted,factor(cyl)))

plot(dl(xyplot,mpgf,.resid~.fitted,factor(cyl),
        panel=function(...){panel.abline(1);panel.xyplot(...)},
        main="foobar2",
        method=perpendicular.lines))
plot(dl(xyplot,mpgf,.resid~.fitted,factor(cyl),debug=TRUE))
## Should fail: (default method includes perpendicular line calculation, which makes no sense for only 1 group per panel
plot(dl(xyplot,mpgf,.resid~.fitted|cyl,factor(cyl)))
## Should work, but not very informative:
plot(dl(xyplot,mpgf,.resid~.fitted|cyl,factor(cyl),method=empty.grid))
mpgf$cyl10 <- sapply(mpgf$cyl,function(i)paste(rep(i,l=10),collapse=""))
plot(dl(xyplot,mpgf,.resid~.fitted|cyl,factor(cyl10),method=empty.grid))
plot(dl(xyplot,mpgf,.resid~.fitted|manufacturer,factor(cyl),method=empty.grid.2))}