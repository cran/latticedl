library(latticedl)
library(ggplot2)
data(BodyWeight,package="nlme")
print(dl(xyplot,BodyWeight,weight~Time|Diet,Rat,
         type='l',layout=c(3,1)))
## Say we want to use a simple linear model to explain rat body weight:
fit <- lm(weight~Time+Diet+Rat,BodyWeight)
bw <- fortify(fit,BodyWeight)
## And we want to use this panel function to display the model fits:
panel.model <- function(x,subscripts,col.line,...){
  panel.xyplot(x=x,subscripts=subscripts,col.line=col.line,...)
  llines(x,bw[subscripts,".fitted"],col=col.line,lty=2)
}
## Just specify the custom panel function as usual:
print(dl(xyplot,bw,weight~Time|Diet,Rat,
         type='l',layout=c(3,1),panel=panel.model))

## Fails: default method for scatterplot doesn't make sense here
##print(dl(xyplot,BodyWeight,weight~Time|Diet,Rat))
