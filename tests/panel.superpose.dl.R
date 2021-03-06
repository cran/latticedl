loci <- data.frame(ppp=c(rbeta(800,10,10),rbeta(100,0.15,1),rbeta(100,1,0.15)),
                   type=factor(c(rep("NEU",800),rep("POS",100),rep("BAL",100))))
library(latticedl)
## 4 ways to make the same plot:
print(dl(densityplot,loci,~ppp,type,n=500))
print(direct.label(
                   densityplot(~ppp,loci,groups=type,n=500)
                   ))
print(direct.label(
                   densityplot(~ppp,loci,groups=type,n=500,
                               panel=panel.superpose,
                               panel.groups="panel.densityplot")
                   ))
print(densityplot(~ppp,loci,groups=type,n=500,
                  panel=panel.superpose.dl,panel.groups="panel.densityplot"))

### Exploring custom panel and panel.groups functions
library(ggplot2)
data(BodyWeight,package="nlme")
## Say we want to use a simple linear model to explain rat body weight:
fit <- lm(weight~Time+Diet+Rat,BodyWeight)
bw <- fortify(fit,BodyWeight)
## lots of examples to come, all with these arguments:
ratxy <- function(...){
  xyplot(weight~Time|Diet,bw,groups=Rat,type="l",layout=c(3,1),...)
}
## No custom panel functions:
regular <- ratxy()
print(regular) ## normal lattice plot
print(direct.label(regular)) ## with direct labels

## The direct label panel function panel.superpose.dl can be used to
## display direct labels as well:
print(ratxy(panel=panel.superpose.dl,panel.groups="panel.xyplot"))
print(ratxy(panel=function(...)
            panel.superpose.dl(panel.groups="panel.xyplot",...)))

## Not very user-friendly, since default label placement is
## impossible, but these should work:
print(ratxy(panel=panel.superpose.dl,panel.groups=panel.xyplot,
            method=first.points))
print(ratxy(panel=function(...)
            panel.superpose.dl(panel.groups=panel.xyplot,...),
            method=first.points))

### Custom panel.groups functions:
## This panel.groups function will display the model fits:
panel.model <- function(x,subscripts,col.line,...){
  panel.xyplot(x=x,subscripts=subscripts,col.line=col.line,...)
  llines(x,bw[subscripts,".fitted"],col=col.line,lty=2)
}
pg <- ratxy(panel=panel.superpose,panel.groups=panel.model)
print(pg)
## If you use panel.superpose.dl with a custom panel.groups function,
## you need to manually specify the Positioning Function, since the
## name of panel.groups is used to infer a default:
print(direct.label(pg,method=first.points))
print(ratxy(panel=panel.superpose.dl,panel.groups="panel.model",
            method=first.points))

## Custom panel function that draws a box around values:
panel.line1 <- function(ps=panel.superpose){
  function(y,...){
    panel.abline(h=range(y))
    ps(y=y,...)
  }
}
custom <- ratxy(panel=panel.line1())
print(custom)
print(direct.label(custom))
## Alternate method, producing the same results, but using
## panel.superpose.dl in the panel function. This is useful for direct
## label plots where you use several datasets.
print(ratxy(panel=panel.line1(panel.superpose.dl),panel.groups="panel.xyplot"))

## Lattice plot with custom panel and panel.groups functions:
both <- ratxy(panel=panel.line1(),panel.groups="panel.model")
print(both)
print(direct.label(both,method=first.points))
print(ratxy(panel=panel.line1(panel.superpose.dl),
            panel.groups=panel.model,method=first.points))

