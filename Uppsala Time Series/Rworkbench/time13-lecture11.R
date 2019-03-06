##### simulation of a time series by arima.sim ######
#help(arima.sim)
require(graphics)

TSIM<-arima.sim(n = 63, list(ar = c(0.8897, -0.4858), ma = c(-0.2279, 0.2488)),
          sd = sqrt(0.1796))
plot(TSIM)
TX1<-arima.sim(n=100, list(ma=c(0.8)))
plot(TX1,lwd=2, main="MA(1)")
###### simulate different MA(1) #####
TX2<-arima.sim(n=100, list(ma=c(0.01)))
lines(TX2, col=2,lwd=2)
legend(locator(n=1),legend=c("theta=0.8","theta=0.01"),col=1:2,lty=1,lwd=2)
######## Estimation  ##################
help(arima)
arima(TX1,c(0,0,1))
arima(TX1,c(0,0,1),include.mean=F)
arima(TX2,c(0,0,1),include.mean=F)
arima(TSIM,c(2,0,2),include.mean=F)
E1<-arima(TSIM,c(2,0,2),include.mean=F)
str(E1)
E2<-arima(TSIM,c(2,0,2),include.mean=F,method="CSS")
E3<-arima(TSIM,c(2,0,2),include.mean=F,method="ML")
E4<-arima(TSIM,c(2,0,2),include.mean=F,method="CSS-ML")
E2$coef
E3$coef
E4$coef
###################### prediction ######################

help(predict)
predict(arima(TX1, order = c(0,0,1)), n.ahead = 2)
predict(arima(TX1, order = c(0,0,1)), n.ahead = 10)
################################
TX4<-arima.sim(n=100, list(ma=c(0.01),ar=c(0.1)))
plot(TX4)
predict(arima(TX4, order = c(1,0,1)), n.ahead = 10)

###################
### data USAccDeaths #####
data(USAccDeaths)
help(USAccDeaths)
str(USAccDeaths)
plot(USAccDeaths)
### remind! ####
dea<-as.numeric(USAccDeaths)
t<-1:72
plot(t,dea)
lines(t,dea)
### harmonic regression, Figure 1-11 ####
x1<-cos(6*2*pi/72*t)
x2<-sin(6*2*pi/72*t)
x3<-cos(12*2*pi/72*t)
x4<-sin(12*2*pi/72*t)
M3<-lm(dea~x1+x2+x3+x4)
#str(M3)
#summary(M3)
M3$fitted
x11()
plot.ts(dea)
lines(t,M3$fitted,"l",lwd=2,col=2 )
points(t,dea)## Figure 1-11 ###
rest1<-dea-M3$fitted
plot.ts(rest1)
acf(rest1)
pacf(rest1)
#spec.pgram(rest1,span=c(5,5))(later Chapter 4 needed)
#cpgram(rest1)
A1<-arima(rest1,c(0,0,5),include.mean=F)
A2<-arima(rest1,c(2,0,0),include.mean=F)
A2
A1
str(A1)
A1$aic

AA<-arima(rest1,c(0,0,3))
AA$aic

### Compare different models #####
AA<-rep(0,10)
for (i in 1:10){AA[i]<-arima(rest1,c(0,0,i),include.mean=F)$aic}
plot(1:10,AA,col=2,"h",lwd=5,main="Comparing different MA models",ylab="AIC",xlab="order")
######
#### Diagnostic checking
str(A1)
A1$residuals
plot.ts(A1$residuals)
acf(A1$residuals)
cpgram(A1$residuals)
ks.test(A1$residuals,punif)
acf(A2$residuals)
cpgram(A2$residuals)
ks.test(A2$residuals,punif)
A3<-arima(rest1,c(0,0,6),include.mean=F)
A3
### Lake Huron ######## 
data(LakeHuron)
help(LakeHuron)
plot(LakeHuron)
str(LakeHuron)
y<-LakeHuron
year<-seq(1875,1972,1)
length(year)
length(y)
plot(year,y,"p",lwd=3, main="Lake Huron")
M1<-lm(y~year)
summary(M1)
abline(M1,col=2,lwd=2)
lines(year,y)#### Figure 1-9 ####
y2<-M1$resid
plot(year,y2,"p",lwd=3,main="Lake Huron - mean corrected")### Figure 1-10 ###
lines(year,y2)
acf(y2)
pacf(y2)
### fit a AR(2) model ####
arima(y2,c(2,0,0),include.mean=F)### compare Example 5.14, there Yule Walker is used
arima(y2,c(2,0,0),include.mean=F,method="CSS")
arima(y2,c(2,0,0),include.mean=F,method="ML")
arima(y2,c(2,0,0),include.mean=F,method="CSS-ML")
### fit ARMA(1,1)##
M3<-arima(y2,c(1,0,1),include.mean=F,method="ML")
M3
str(M3)
cpgram(M3$resid)
acf(M3$resid)

M4<-arima(y2,c(2,0,0),include.mean=F,method="ML")
cpgram(M4$resid)
acf(M4$resid)
M3$aic
M4$aic
M5<-arima(y2,c(1,0,0),include.mean=F,method="ML")
M5$aic
cpgram(M5$resid)









