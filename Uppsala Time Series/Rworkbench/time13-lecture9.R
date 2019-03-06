########################Lecture 9 acf, pacf #########################
## model acf, caculated with R ###
help(ARMAacf)# theoretical, input: parameters
help(acf)# sample, input: timeseries 




## Example 3.2.1: ARMA(1,1), phi=0.3, theta=0.7, sigma=1 ###
phi<-0.3
theta<-0.7
sigma<-1
ARMAacf(ar=0.3,ma=0.7,lag.max=10)
str(ARMAacf(ar=0.3,ma=0.7,lag.max=10))
acf<-as.numeric(ARMAacf(ar=0.3,ma=0.7,lag.max=10))[1:11]


plot(ARMAacf(ar=0.3,ma=0.7,lag.max=10),xlab="lag",ylab="acf",main="Model acf of ARMA(1,1)")
plot(ARMAacf(ar=0.3,ma=0.7,lag.max=10),type='h',lwd=2,main="Theoretical autocorrelation function",xlab="lag",ylab="autocorralation")
### Compare it with the formulare on page 89 ####
gamma<-rep(1,11)
gamma[1]<-sigma*(1+(theta+phi)*(theta+phi)/(1-phi^2))
gamma[2]<-sigma*(theta+phi+(theta+phi)*(theta+phi)*phi/(1-phi^2))
for (i in 3:11)(gamma[i]<-phi^(i-2)*gamma[2])
plot(0:10,gamma,xlab="lag",main="ACVF of ARMA(1,1)",col=2,lwd=3)
#calculate the autocorellation
rho<-gamma/gamma[1]
plot(0:10,rho,xlab="lag",main="ACF of ARMA(1,1)",col=2,lwd=3)

# sign in the acf calculated by  ARMAacf 
lines(0:10,acf, lwd=2) ### 
## another way of comparison###
plot(rho,acf)
lines(c(0,1),c(0,1),lwd=2,col=2)
#######

### model pacf  calculated with R #####

#help(ARMAacf)
## Example 3.2.1: ARMA(1,1), phi=0.3, theta=0.7, sigma=1 ###
phi<-0.3
theta<-0.7
sigma<-1
ARMAacf(ar=0.3,ma=0.7,lag.max=10,pacf=T)
pacf<-ARMAacf(ar=0.3,ma=0.7,lag.max=10,pacf=T)
length(pacf)
plot(1:10,pacf)
plot(1:10,pacf,"h",lwd=3,main="pacf of ARMA(1,1)")
lines(1:10,rep(0,10))

### cut off properties ###
### cut off of model acf for MA processes ###  
# Example Ma(3)
ARMAacf(ma=c(0.5,-0.2,0.1),lag.max=10)
acf2<-ARMAacf(ma=c(0.5,-0.2,0.1),lag.max=10)
length(acf2)
plot(0:10,acf2)
plot(0:10,acf2,"h",lwd=4,main="model acf of MA(3)",xlab="lag",col=2)
lines(0:10,rep(0,11),lwd=2)

### compare with simulated time series and sample acf ###
#help(arima.sim)
TT<-arima.sim(list(ma=c(0.5,-0.2,0.1)),n=100)
plot(TT)
acf(TT,lwd=3)
lines(0:10+0.2,acf2,"h",col=2,lwd=3)## for comparison reasons shifted by 0.2##


###### cut off of model pacf for AR processes ####
## Example AR(3)
ARMAacf(ar=c(0.5,-0.2,0.3),lag.max=10,pacf=TRUE)
pacf2<-ARMAacf(ar=c(0.5,-0.2,0.3),lag.max=10,pacf=TRUE)
length(pacf2)
plot(1:10,pacf2)
plot(1:10,pacf2,"h",lwd=4,main="pacf of AR(3)",xlab="lag",col=1)
lines(1:10,rep(0,10),lwd=2) ### Cut off at the rught lag ???? ''#

### compare with simulated time series and sample pacf ###
TT<-arima.sim(list(ar=c(0.5,-0.2,0.3)),n=100)
plot(TT)
x11()
pacf(TT)
lines(1:10+0.1,pacf2,"h",col=2,lwd=2)

