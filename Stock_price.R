install.packages("ISLR")
library(ISLR)

library(splines)
attach(TSLA)


names(TSLA)

Te=data.frame(TSLA[c(2,5)])

##Trying a linear model with a natural spline starting off with 6 degrees of freedom.  We see that the closing price vs.
##the opening price have a linear relationship.  Trying a smoothing spline will not improve anything over a linear relationship
openlimits=range(Open)
Open.grid=seq(from=openlimits[1],to=openlimits[2])
fit_open=lm(Close~ns(Open,df=6),data=Te)
plot(Open,Close,col="black")
pred=predict(fit_open,newdata=list(Open=Open.grid),se=T)
lines(Open.grid,pred$fit,col="red",lwd=3)

##The range of the volume would be too large so to make it smaller divide by 1000.
for(i in 1:length(Volume))
{
  volume[i]=(Volume[i]/1000)
}
volume[1:10]

##A new data frame is created to see the relationship between the closing price as pertains to the volume.  We see that there 
##is not a linear relationship.  A smooth spline will be fit using cross validation to find a best fit degree of freedom 
##which is close to 8 so that value will be tested and compared to the first smoothing spline.
Tv=data.frame(c(Close,volume))
volimits=range(volume)
volume.grid=seq(from=volimits[1],to=volimits[2])
fit2=lm(Close~ns(volume,df=16),data=Tv)
prediction_volume=predict(fit2,newdata=list(volume=volume.grid),se=T)
plot(volume,Close,col="gray")
lines(volume.grid,prediction_volume$fit,col="blue",lwd=3)

fit3=smooth.spline(volume,Close,cv=TRUE)
lines(fit3,col="red",lwd=2)
fit3$df

fit4=smooth.spline(volume,Close,df=8)
fit4_predictions=predict(fit4,newdata=list(volume=volume.grid),se=T)
lines(fit4_predictions,col="black",lwd=2)

legend(1000,800,legend=c("Natural Spline","Smooth CV","Smooth DF"),col=c("blue","red"
                    ,"black"),lty=1,cex=.8)
