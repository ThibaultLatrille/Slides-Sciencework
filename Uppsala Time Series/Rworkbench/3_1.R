# TODO: Add comment
# 
# Author: Thibault
###############################################################################

theta<-0.7
n<-500
TS<-arima.sim(list(ma=c(theta)),n=n)
spec<-spectrum(TS,plot=FALSE)
bandwidth<-c(5,10,20,40,60,80,160)
f<-as.numeric(spec$freq)
s<-as.numeric(spec$spec)
plot(f,s,"l",lwd=2,main="Estimation of the spectral density",xlab="frequency",ylab="spectrum")
col=2
for (i in bandwidth){
spec1<-spectrum(TS,span=c(i,i),plot=FALSE)
f1<-as.numeric(spec1$freq)
s1<-as.numeric(spec1$spec)
lines(f1,s1,col=col,lwd=2)
col<-col+1
}
legend(locator(n=1),legend=c("raw",bandwidth),col=seq(1:(length(bandwidth)+1)),lty=1,lwd=2)
library(TSA)### additional packet TSA is needed ####
spec<-spectrum(TS,span=c(80,80))
ARMAspec(model=list(ma=c(theta)),lwd=2,main="spectral density of MA(1) with theta=0.7")
x<-as.numeric(spec$freq)
y<-as.numeric(spec$spec)
lines(x,y,lwd=2,col=2)
plot(TS)