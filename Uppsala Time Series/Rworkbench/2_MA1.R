MA<-function(n,theta){
X<-rep(0,n)
Z<-rnorm(n,0,1)
X[1]<-Z[1]
for (j in 2:n){
	X[j]<-theta*Z[j-1]+Z[j]	
	}
return(ts(X))
}

theta<-0.6
X<-MA(1000,theta)
acfx<-acf(X)
gamma2.ar<-rep(0,31)
gamma2.ar[1]<-1
gamma2.ar[2]<-theta/(1+theta**2)
points(seq(0,30,1),gamma2.ar,"p",col=2,lwd=3,pch=19)

plugin<-rep(0,100)
CSS_ML<-rep(0,100)
CSS<-rep(0,100)
for (j in 1:100){
	X<-MA(500,theta)
	g2<-acf(X,plot=FALSE)[[1]][2]
	if ((1-4*g2^2)<0){plugin[j]<-1/(2*g2)
	print(g2)
	}
	else{plugin[j]<-1/(2*g2)-sqrt(1-4*g2^2)/(2*g2)}
	CSS_ML[j]<-arima(X,order=c(0,0,1),method="CSS-ML")$coef[[1]]
	CSS[j]<-arima(X,order=c(0,0,1),method="CSS")$coef[[1]]
}
boxplot(list(plugin,CSS_ML,CSS))

N<-c(100,200,300,400,500,600,700,800,900,1000)
D=data.frame(N=rep(N,rep(100,10)),estimator=rep(10*100))
i<-0
for (n in N){
for (j in 1:100){
	X<-MA(n,theta)
	D$estimator[i*100+j]<-arima(X,order=c(0,0,1),method="CSS-ML")$coef[[1]]
}
i<-i+1
}
boxplot(estimator~N,D)

