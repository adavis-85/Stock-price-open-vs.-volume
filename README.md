# Stock price with splines

Searching through Tesla's stock prices from the last year it is evident that there is relationships
between the different variables.  The dates can be checked for their variances but first the opening prices
and the volumes will be checked against each other as to determine which has the strongest impact on the closing prices
First the opening:

```
library(splines)
attach(TSLA)

openlimits=range(Open)
Open.grid=seq(from=openlimits[1],to=openlimits[2])
fit_open=lm(Close~ns(Open,df=6),data=Te)
plot(Open,Close,col="black")
pred=predict(fit_open,newdata=list(Open=Open.grid),se=T)
lines(Open.grid,pred$fit,col="red",lwd=3)


```
To use a spline in R the range over which the spline function will be fit to needs to be specified.  The range of opening
prices is used to make a prediction using a natural spline with six degrees of freedom to start.  As seen in the attached 
graph file there is a strong linear relationship between the opening price and the closing price.  There is not many dips
and rises in the price besides very few outliers.  
The volume is tested for its relationship to the closing prices.
```
for(i in 1:length(Volume))
{
  volume[i]=(Volume[i]/1000)
}
```
A new variable is needed because the Volume column contains incredibly large values and would vary too much.  It is divided
by 1000.
```
Tv=data.frame(c(Close,volume))
volimits=range(volume)
volume.grid=seq(from=volimits[1],to=volimits[2])
fit2=lm(Close~ns(volume,df=16),data=Tv)
prediction_volume=predict(fit2,newdata=list(volume=volume.grid),se=T)
plot(volume,Close,col="gray")
lines(volume.grid,prediction_volume$fit,col="red",lwd=3)

```
As seen in the graph the fit using 16 degrees of freedom the volume does vary greatly pertaining to the closing price.
Next a smooth spline is fit to the same data using cross-validation to find the best degree of freedom.
```
fit3=smooth.spline(volume,Close,cv=TRUE)
lines(fit3,col="red",lwd=2)
fit3$df

[1] 7.550358
```
The graph still varies as it pertains to the data.  Most of the closing prices are jumbled in the first part of the plot 
where the volume is smallest.  Another line is fit using 8 degrees of freedom to see what the fit will be.
```
fit4=smooth.spline(volume,Close,df=8)
fit4_predictions=predict(fit4,newdata=list(volume=volume.grid),se=T)
lines(fit4_predictions,col="black",lwd=2)
```
As seen the smooth splines are close to the natural spline using 16 degrees of freedom.  Also the differences in the volume
versus the opening price as a predictor of the closing price is evident.  It would be better to use the opening price to 
try and predict the closing price.  The relationship is stronger than the splines and also the opening prices do not vary 
as much as the volume does.  
