# TODO: Add comment
# 
# Author: Thibault
###############################################################################

MA2<-function(n,theta1,theta2){
	X<-rep(0,n)
	Z<-rnorm(n,0,1)
	X[1]<-Z[1]
	X[2]<-theta1*Z[1]+Z[2]
	for (j in 3:n){
		X[j]<-Z[j]+theta1*Z[j-1]+theta2*Z[j-2]
	}
	return(ts(X))
}

theta1<-(-0.5)
theta2<-(0.6)
X<-MA2(1000,theta1,theta2)
acfx<-acf(X)
gamma2.ar<-rep(0,31)
gamma2.ar[1]<-1
gamma2.ar[2]<-theta1*(theta2+1)/(1+theta1**2+theta2**2)
gamma2.ar[3]<-theta2/(1+theta1**2+theta2**2)
points(seq(0,30,1),gamma2.ar,"p",col=2,lwd=3,pch=19)

THETA1<-rep(0,100)
THETA2<-rep(0,100)
for (j in 1:100){
	X<-MA2(500,theta1,theta2)
	THETA1[j]<-arima(X,order=c(0,0,2))$coef[[1]]
	THETA2[j]<-arima(X,order=c(0,0,2))$coef[[2]]
}
boxplot(list(THETA2))



