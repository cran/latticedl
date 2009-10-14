label.positions <- function
### Calculates table of positions of each label. This can be thought
### of as a lattice panel function. It takes the same sort of
### arguments but does not draw anything. Instead it is called for its
### return value.
(x,
### x values of points to draw.
 y,
### y values of points to draw.
 subscripts,
### subscripts of groups to consider.
 groups,
### vector of groups.
 debug=FALSE,
### logical indicating whether debug annotations should be added to
### the plot.
 method=perpendicular.lines,
### function used to choose position of labels.
 ...
### passed to positioning method
 ){
  levs <- levels(groups)
  groups <- groups[subscripts]
  d <- data.frame(x,groups)
  if(!missing(y))d$y <- y
  if(class(method)=="function")method <- list(method)
  for(m.num in seq_along(method)){
    m <- method[[m.num]]
    m.var <- names(method)[m.num]
    if(!(is.null(m.var)||m.var==""))d[[m.var]] <- m else{
      if(class(m)=="character"){
        method.name <- paste(m," ",sep="")
        m <- get(m)
      }else method.name <- ""
      d <- try(m(d,debug=debug,...))
      if(class(d)=="try-error")
        stop("direct label placement method ",method.name,"failed")
    }
  }
  ## rearrange factors in case pos fun messed up the order:
  d$groups <- factor(as.character(d$groups),levs)
  ## defaults for grid parameter values:
  for(p in c("hjust","vjust"))
    d[,p] <- if(p %in% names(d))as.character(d[,p]) else 0.5
  if(!"rot"%in%names(d))d$rot <- 0
  d <- unique(d)
  if(debug)print(d)
  d
### Data frame describing where direct labels should be positioned.
}

perpendicular.lines <- function
### Draw a line between the centers of each cluster, then draw a
### perpendicular line for each cluster that goes through its
### center. For each cluster, return the point the lies furthest out
### along this line.
(d,
### Data frame with groups x y.
 debug=FALSE,
### If TRUE will draw points at the center of each cluster and some
### lines that show how the points returned were chosen.
 ...
### ignored.
 ){
  means <- get.means(d)
  names(means)[2:3] <- c("mx","my")
  big <- merge(d,means,by="groups")
  fit <- lm(my~mx,means)
  b <- coef(fit)[1]
  m <- coef(fit)[2]
  big2 <- transform(big,x1=(mx+x+(my-y)*m)/2)
  big3 <- transform(big2,y1=m*(x1-x)+y)
  big4 <- transform(big3,
                    d=sqrt((x-x1)^2+(y-y1)^2),
                    dm=sqrt((x-mx)^2+(y-my)^2))
  big5 <- transform(big4,ratio=d/dm)
  winners <- ddply(big5,.(groups),subset,
                   subset=seq_along(ratio)==which.min(ratio))
  ## gives back a function of a line that goes through the designated center
  f <- function(v)function(x){
    r <- means[means$groups==v,]
    -1/m*(x-r$mx)+r$my
  }
  ##dd <- ddply(means,.(groups),summarise,x=x+sdx*seq(0,-2,l=5)[-1])
  ##dd$y <- mdply(dd,function(groups,x)f(groups)(x))$x
  if(debug){
    ## First find the mean of each cluster
    grid.points(means$mx,means$my,default.units="native")
    ## myline draws a line over the range of the data for a given fun F
    myline <- function(F)
      grid.lines(range(d$x),F(range(d$x)),default.units="native")
    ## Then draw a line between these means
    myline(function(x)m*x+b)
    ## Then draw perpendiculars that go through each center
    for(v in means$groups)myline(f(v))
  }
  winners[,c("x","y","groups")]
### Data frame with groups x y, giving the point for each cluster
### which is the furthest out along the line drawn through its center.
}
empty.grid <- function
### Label placement method for scatterplots that ensures labels are
### placed in different places. A grid is drawn over the whole
### plot. Each cluster is considered in sequence and assigned to the
### point on this grid which is closest to the point given by
### loc.fun().
(d,
### Data frame of points on the scatterplot with columns groups x y.
 debug=FALSE,
### Show debugging info on the plot? This is passed to loc.fun.
 loc.fun=get.means,
### Function that takes d and returns a data frame with 1 column for
### each group, giving the point we will use to look for a close point
### on the grid, to put the group label.
 ...
### ignored.
 ){
  loc <- loc.fun(d,debug)
  NREP <- 10
  gl <- function(v){
    s <- seq(from=min(d[,v]),to=max(d[,v]),l=NREP)
    list(centers=s,diff=(s[2]-s[1])/2)
  }
  L <- sapply(c("x","y"),gl,simplify=FALSE)
  g <- expand.grid(x=L$x$centers,y=L$y$centers)
  g2 <- transform(g,
                  left=x-L$x$diff,
                  right=x+L$x$diff,
                  top=y+L$y$diff,
                  bottom=y-L$y$diff)
  inbox <- function(x,y,left,right,top,bottom)
    c(data=sum(d$x>left & d$x<right & d$y>bottom & d$y<top))
  count.tab <- cbind(mdply(g2,inbox),expand.grid(i=1:NREP,j=1:NREP))
  count.mat <- matrix(count.tab$data,nrow=NREP,ncol=NREP,
                      byrow=TRUE,dimnames=list(1:NREP,1:NREP))[NREP:1,]
  mode(count.mat) <- "character"
  g3 <- transform(subset(count.tab,data==0))
  res <- data.frame()
  for(v in loc$groups){
    r <- subset(loc,groups==v)
    len <- sqrt((r$x-g3$x)^2+(r$y-g3$y)^2)
    i <- which.min(len) ## the box to use for this group
    count.mat[as.character(g3[i,"j"]),
              as.character(g3[i,"i"])] <- paste("*",v,sep="")
    res <- rbind(res,g3[i,c("x","y")])
    g3 <- g3[-i,]
  }
  if(debug)print(count.mat)
  cbind(res,groups=loc$groups)
### Data frame with columns groups x y, 1 line for each group, giving
### the positions on the grid closest to each cluster.
}
empty.grid.2 <- function
### Use the perpendicular lines method in combination with the empty
### grid method.
(d,
### Data frame with columns groups x y.
 debug,
### Show debugging graphics on the plot?
 ...
### ignored.
 ){
  empty.grid(d,debug,perpendicular.lines)
}
dl.indep <- function
### Makes a function you can use to specify the location of each group
### independently.
(expr
### Expression that takes a subset of the d data frame, with data from
### only a single group, and returns the direct label position.
 ){
  foo <- substitute(expr)
  f <- function(d,...)eval(foo)
  function(d,...){
    ddply(d,.(groups),f,...)
  }
### The constructed label position function.
}
### Positioning Function for the mode of a density estimate.
top.points <- dl.indep({
  maxy <- which.max(d$y)
  data.frame(x=d$x[maxy],y=d$y[maxy],hjust=0.5,vjust=0)
})
### Transformation function for 1d densityplots.
trans.densityplot <- dl.indep({
  dens <- density(d$x)
  data.frame(x=dens$x,y=dens$y)
})
### Positioning Function for first points of longitudinal data.
first.points <-
  dl.indep(data.frame(d[order(d$x),][1,c("x","y")],hjust=1,vjust=0.5))
### Positioning Function for last points of longitudinal data.
last.points <-
  dl.indep(data.frame(d[order(d$x),][nrow(d),c("x","y")],hjust=0,vjust=0.5))
### Transformation function for 1d qqmath plots.
trans.qqmath <- function(d,...){
  ddply(d,.(groups),function(d){
    r <- prepanel.default.qqmath(d$x,...)
    data.frame(x=r$x,y=r$y)
  })
}
### Positioning Function for the mean of each cluster of points.
get.means <-
  dl.indep(data.frame(x=mean(d$x),y=mean(d$y)))
### Place points on top of the mean value of the rug.
rug.mean <- function(d,...,end)
  ddply(d,.(groups),function(d)
        data.frame(x=mean(d$x),
                   y=as.numeric(convertY(unit(end,"npc"),"native")),
                   vjust=0))
### Do first or last, whichever has points most spread out.
maxvar.points <- function(d,...){
  v <- ddply(d,.(x),summarise,v=var(y))
  x <- subset(v,v==max(v))$x
  if(x==min(d$x))first.points(d,...) else last.points(d,...)
}
