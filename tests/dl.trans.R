library(latticedl)
complicated <- list(dl.trans(x=x+10),
                    dl.indep(d[-2,]),
                    rot=c(30,180))
direct.label(
             dotplot(VADeaths,type="o")
             ,method=complicated)
