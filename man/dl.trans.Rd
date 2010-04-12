\name{dl.trans}
\Rdversion{1.1}
\alias{dl.trans}
\title{ Direct label data transform}
\description{Make a function that transforms the data. This is for conveniently making a function that calls transform on the data frame, with the arguments provided. See examples.}
\usage{
dl.trans(...)
}
\arguments{
  \item{\dots}{Arguments to pass to transform.}
}
\details{
}
\value{A Positioning Function.}
\references{
}
\author{Toby Dylan Hocking <toby.hocking@inria.fr>}
\note{
}


\seealso{
}
\examples{library(latticedl)
complicated <- list(dl.trans(x=x+10),
                    dl.indep(d[-2,]),
                    rot=c(30,180))
direct.label(
             dotplot(VADeaths,type="o")
             ,method=complicated)}