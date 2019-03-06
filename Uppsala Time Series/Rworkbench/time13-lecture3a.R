### Lecture 3 
### acf theoretical and sample acf ###
### White noise ###
TX<-ts(rnorm(100,0,2))
acf(TX)
points(0,1,col=2,pch=19)
points(1:20,rep(0,20),col=2,pch=19)
help(acf)
acf(TX,type="covariance",ylim=c(0,4),main="Autocovariance function")
points(0,4,col=2,pch=19)
points(1:20,rep(0,20),col=2,pch=19)

## MA(1)### 
### theoretical acf of MA(1) with theta=0.8 ###
gamma1<-rep(0,21)
gamma1[1]<-1
gamma1[2]<-0.8/(1+0.8*0.8)
plot(seq(0,20,1),gamma1,"h", col=2,lwd=2,xlab="Lag",ylab="acf",main="MA(1)")### sign in the theoretical acf ####
points(seq(0,20,1),gamma1,col=2,pch=19)
## simulate a MA(1)ts with theta=0.8#####
require(graphics)
TX1<-arima.sim(n=100, list(ma=c(0.8)))
plot(TX1,lwd=2, main="MA(1)")
## sample acf ###
acf(TX1)
# sign in the theoretical acf###
points(seq(0,20,1),gamma1,col=2,pch=19)


### AR(1)with phi=-0.5####
### theoretical acf ###
gamma2.ar<-rep(1,21)
for(j in 2:21){gamma2.ar[j]<-(1/2)^{j+1}*(-1)^{j+1}}
gamma2.ar[2]
plot(seq(0,20,1),gamma2.ar,"h",col=2,lwd=3,main="ACF of AR(1)",xlab="lag",ylab="acf")
points(seq(0,20,1),gamma2.ar,col=2,pch=19,lwd=3)
## simulate a ts and compare ###
###simulate####
TX2<-arima.sim(n = 100, list(ar = c( -0.5)),
          sd = sqrt(0.1796))
plot(TX2,lwd=2,main="AR(1)")
acf(TX2)
#### sign in the theoretical acf ###
points(seq(0,20,1),gamma2.ar,col=2,pch=19,lwd=3)
#################################




