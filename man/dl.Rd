\name{dl}
\Rdversion{1.1}
\alias{dl}
\title{ Quick lattice direct label plot}
\description{Shortcut for a lattice plot with direct labels. This is a convenience function so you do not have to explicitly type groups=. This simply constructs the lattice plot and then calls direct.label on it.}
\usage{
dl(lattice.fun, data, x, groups, method = NULL, debug = FALSE, ...)
}
\arguments{
  \item{lattice.fun}{High-level lattice plot function to use.}
  \item{data}{Data to use.}
  \item{x}{Lattice model formula.}
  \item{groups}{To be passed to lattice as groups= argument.}
  \item{method}{Method for direct labeling as described in ?label.positions.}
  \item{debug}{Show debug output?}
  \item{\dots}{Other arguments to be passed to lattice.fun.}
}
\details{
}
\value{The lattice plot.}
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
plot(dl(xyplot,mpgf,.resid~.fitted,factor(cyl),method=get.means,par.settings=list()))

plot(dl(xyplot,mpgf,.resid~.fitted,factor(cyl),
        panel=function(...){panel.abline(1);panel.xyplot(...)},
        main="foobar2",
        method=perpendicular.lines))
plot(dl(xyplot,mpgf,.resid~.fitted,factor(cyl),debug=TRUE))
## Should fail: (default method includes perpendicular line
## calculation, which makes no sense for only 1 group per panel
plot(dl(xyplot,mpgf,.resid~.fitted|cyl,factor(cyl)))
## Should work, but not very informative:
plot(dl(xyplot,mpgf,.resid~.fitted|cyl,factor(cyl),method=empty.grid))
mpgf$cyl10 <- sapply(mpgf$cyl,function(i)paste(rep(i,l=10),collapse=""))
plot(dl(xyplot,mpgf,.resid~.fitted|cyl,factor(cyl10),method=empty.grid))
plot(dl(xyplot,mpgf,.resid~.fitted|manufacturer,factor(cyl),method=empty.grid.2))

data(BodyWeight,package="nlme")
print(dl(xyplot,BodyWeight,weight~Time|Diet,Rat,
         type='l',layout=c(3,1)))
## Say we want to use a simple linear model to explain rat body weight:
fit <- lm(weight~Time+Diet+Rat,BodyWeight)
bw <- fortify(fit,BodyWeight)
## And we want to use this panel.groups function to display the model
## fits:
panel.model <- function(x,subscripts,col.line,...){
  panel.xyplot(x=x,subscripts=subscripts,col.line=col.line,...)
  llines(x,bw[subscripts,".fitted"],col=col.line,lty=2)
}
## Custom panel.groups functions:
print(dl(xyplot,bw,weight~Time|Diet,Rat,type="l",layout=c(3,1),
         panel=panel.superpose,
         panel.groups=panel.model,method=first.points))
## Custom panel function which highlights min and max values:
panel.range <- function(y,...){
  panel.abline(h=range(y))
  panel.superpose(y=y,...)
}
print(dl(xyplot,bw,weight~Time|Diet,Rat,type="l",layout=c(3,1),
         panel=panel.range))
## Custom panel and panel.groups functions:
print(dl(xyplot,bw,weight~Time|Diet,Rat,type="l",layout=c(3,1),
         panel=panel.range,panel.groups=panel.model,method=first.points))

## Fails: default method for scatterplot doesn't make sense here
##print(dl(xyplot,BodyWeight,weight~Time|Diet,Rat))


## dl with densityplots:
loci <- data.frame(ppp=c(rbeta(800,10,10),rbeta(100,0.15,1),rbeta(100,1,0.15)),
                   type=factor(c(rep("NEU",800),rep("POS",100),rep("BAL",100))))
print(dl(densityplot,loci,~ppp,type,n=500))
## Not very informative but it should work:
print(dl(densityplot,loci,~ppp|type,type,n=500))}