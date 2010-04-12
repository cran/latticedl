\name{top.points}
\Rdversion{1.1}
\alias{top.points}
\title{top points}
\description{Positioning Function for the top of a group of points.}
\usage{
top.points(d, ...)
}
\arguments{
  \item{d}{
}
  \item{\dots}{
}
}
\details{
}
\value{
}
\references{
}
\author{Toby Dylan Hocking <toby.hocking@inria.fr>}
\note{
}


\seealso{
}
\examples{loci <- data.frame(ppp=c(rbeta(800,10,10),rbeta(100,0.15,1),rbeta(100,1,0.15)),
                   type=factor(c(rep("NEU",800),rep("POS",100),rep("BAL",100))))
library(latticedl)
print(dl(densityplot,loci,~ppp,type,n=500))
## Not very informative but it should work:
print(dl(densityplot,loci,~ppp|type,type,n=500))}