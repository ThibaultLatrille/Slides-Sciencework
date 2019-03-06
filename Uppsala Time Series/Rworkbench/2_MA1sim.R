# TODO: Add comment
# 
# Author: Thibault
###############################################################################


X<-arima.sim(list(ma=c(theta)),n=n)
acfx<-acf(X)
g2<-acfx[[1]][2]
g2
thetafit2<-1/(2*g2)-sqrt(1-4*g2^2)/(2*g2)
thetafit2
fit<-arima(X,order=c(0,0,1))
fit
tsdiag(fit)
