library(latticedl)
library(proto)
library(ggplot2)
data(mpg)
m <- lm(cty~displ,data=mpg)
mpgf <- fortify(m,mpg)
mpg.scatter <- xyplot(.resid~.fitted,mpgf,groups=factor(cyl))
plot(direct.label(mpg.scatter))
plot(direct.label(mpg.scatter,debug=TRUE))
plot(direct.label(
        xyplot(.resid~.fitted,mpgf,groups=factor(cyl),
               panel=function(...){panel.abline(1);panel.xyplot(...)},
               main="foobar2")
        ,method=perpendicular.lines))
## Should plot but show direct label placement error in each panel:
## default method includes perpendicular line calculation, which makes
## no sense for only 1 group per panel
trellised <- xyplot(.resid~.fitted|cyl,mpgf,groups=factor(cyl))
plot(direct.label(trellised))
## Should work, but not very informative:
plot(direct.label(trellised,method=empty.grid))
mpgf$cyl10 <- sapply(mpgf$cyl,function(i)paste(rep(i,l=10),collapse=""))
plot(direct.label(
        xyplot(.resid~.fitted|cyl,mpgf,groups=factor(cyl10))
        ,method=empty.grid))
## Some label placements fail, some dont:
plot(direct.label(
        xyplot(.resid~.fitted|manufacturer,mpgf,groups=factor(cyl))
        ,method=empty.grid.2))

data(BodyWeight,package="nlme")
print(direct.label(
         xyplot(weight~Time|Diet,BodyWeight,groups=Rat,type='l',layout=c(3,1))
         ))
## Say we want to use a simple linear model to explain rat body weight:
fit <- lm(weight~Time+Diet+Rat,BodyWeight)
bw <- fortify(fit,BodyWeight)
## And we want to use this panel function to display the model fits:
panel.model <- function(x,subscripts,col.line,...){
  panel.xyplot(x=x,subscripts=subscripts,col.line=col.line,...)
  llines(x,bw[subscripts,".fitted"],col=col.line,lty=2)
}
## Just specify the custom panel function as usual:
print(direct.label(
         xyplot(weight~Time|Diet,bw,groups=Rat,type='l',layout=c(3,1),
                panel=panel.superpose,panel.groups=panel.model)
         ,method=last.points))

## Fails: default method for scatterplot doesn't make sense here
##print(direct.label(xyplot,BodyWeight,weight~Time|Diet,Rat))
loci <- data.frame(ppp=c(rbeta(800,10,10),rbeta(100,0.15,1),rbeta(100,1,0.15)),
                   type=factor(c(rep("NEU",800),rep("POS",100),rep("BAL",100))))
plot(direct.label(
             densityplot(~ppp,loci,groups=type,n=500)
             ))
## Not very informative but it should work:
plot(direct.label(
             densityplot(~ppp|type,loci,groups=type,n=500)
             ))


data(Chem97,package="mlmRev")
qqm <- qqmath(~gcsescore,Chem97,groups=gender,
              type=c("p","g"),f.value=ppoints(100),auto.key=TRUE)
direct.label(qqm)
static.labels <- data.frame(x=c(-2,0),y=c(6,4),groups=c("F","M"))
direct.label(qqm,method=function(d,...)static.labels,debug=TRUE)
direct.label(qqm,method=static.labels,debug=TRUE)
## Should work: static.labels overwrites values from
## last.points. Applying last.points should change the hjust as well:
direct.label(qqm,method=c("last.points",static.labels),debug=TRUE)
direct.label(qqm,method=c(static.labels,"last.points"),debug=TRUE)
direct.label(qqmath(~gcsescore|gender,Chem97,groups=factor(score),
                    type=c('l','g'),f.value=ppoints(100)))

direct.label(dotplot(VADeaths,type="o"),method=list("last.points",rot=30))
