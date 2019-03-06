n<-10000
f<-function(x) exp(-(x-1)**2)
mu1<-integrate(f,-2,0)
mu2<-sqrt(pi)*(pnorm(sqrt(2)*(0-1))-pnorm(sqrt(2)*(-2-1)))
mu1
mu2
data<-rnorm(n,1,1/sqrt(2))
data<-data[((data>-2 & data<0))|((data>2 & data<4))]
mu3=sqrt(pi)/2*length(data)/n
mu3

library(fOptions)
V=runif.sobol(n, 2, scrambling=2)

f<-function(x) exp(-(x-1)**2)
a=runif(n,-2,0)
b=runif(n,0,exp(-1))
mu4=(2*exp(-1)/n)*length(b[b<f(a)])
mu4
#x=seq(-2,0,0.001)
#plot(x,f(x))
#points(a[b>f(a)],b[b>f(a)],col="red")
#points(a[b<f(a)],b[b<f(a)],col="dark green")

data<-rcauchy(n,1)
w<-function(x) dnorm(x,1,1/sqrt(2))/dcauchy(x,1)
wdata<-w(data[((data>-2 & data<0))|((data>2 & data<4))])
mu5=sqrt(pi)/2*sum(wdata)/sum(w(data))
mu5

MCMC<-function(a,seed,N){
rand<-rep(NA,N);
rand[1]<-seed;
for(i in 2:N) {
	rand[i]<-seed+a*runif(1,-1,1);
	r<-min(1,exp((seed-1)^2-(rand[i]-1)^2));
	if (runif(1)<r){seed<-rand[i]}else{rand[i]<-seed}
	};
return(rand)
}

AMCMC<-function(seed,N,to){
N<-N+to
rand<-rep(NA,N);
C0<-1
Sd<-2.4^2
eps<-0.1
rand[1]<-seed;
for(i in 2:to) {
	rand[i]<-seed+sqrt(3*C0)*runif(1,-1,1);
	r<-min(1,exp((seed-1)^2-(rand[i]-1)^2));
	if (runif(1)<r){seed<-rand[i]}else{rand[i]<-seed}
 }
Mean<-mean(rand[1:to])
C0<-(sum(rand[1:to])-to*Mean**2)/(to-1)
for (i in (to+1):N) {
	t=i-1
	rand[i]<-seed+sqrt(3*abs(C0))*runif(1,-1,1);
	r<-min(1,exp((seed-1)^2-(rand[i]-1)^2));
	if (runif(1)<r){seed<-rand[i]} else{rand[i]<-seed};
	NMean<-(Mean*(i-1)+rand[i])/i
	C0<-(t-1)*C0/t+Sd*(t*Mean**2-i*NMean**2+rand[i]**2+eps)/t
	Mean<-NMean
     }
return(rand[(to+1):N])
}

data<-MCMC(1,1,n)
hist(data)
data<-data[((data>-2 & data<0))|((data>2 & data<4))]
mu6=sqrt(pi)/2*length(data)/n

data<-AMCMC(0,n,(n/10))
length(data)
data<-data[((data>-2 & data<0))|((data>2 & data<4))]
mu7=sqrt(pi)/2*length(data)/n

mu1
mu2
mu3
mu4
mu5
mu6
mu7

#plot.ts(MCMC(0.01,0,1000),ylab="",main="Simulation with a=0.01")
#plot.ts(MCMC(10,0,1000),ylab="",main="Simulation with a=10")