evenR<-c(5*10^6,7.0*10^6,7.5*10^6,7.9*10^6,8.6*10^6,9.5*10^6,1.1*10^7,1.8*10^7,1.25*10^7,1.38*10^7,1.52*10^7,1.55*10^7,1.75*10^7,1.95*10^7,2.00*10^7,2.25*10^7,2.45*10^7,2.75*10^7,3*10^7,3.2*10^7,3.4*10^7)
evenW<-c(2.4354,1.7624,2.156,2.25263,1.724,1.94,1.6528,1.6169,1.5586,1.68638,1.45368,1.7258,1.438,1.58396,1.35369,1.42963,1.3583,1.48683,1.38368,1.45863,1.48645)
oddR<-c(2.3*10^6,2.32*10^6,2.35*10^6,4.1*10^6,4.2*10^6,4.35*10^6,4.9*10^6,5.3*10^6,7*10^6,7.3*10^6,7.35*10^6,8.3*10^6,9*10^6,9.8*10^6,9.9*10^6,1.15*10^7,1.42*10^7,1.5*10^7,1.7*10^7,1.9*10^7)
oddW<-c(1.95564,2.221,2.454,2.135,2.445,2.312,2.25123,2.3135,1.850,2.013215,2.1185,2.23135,2.15155,2.13145,2.6364,1.94264,1.7483,1.928546,1.55364,1.5253)
odd<-data.frame(x=oddR,y=oddW)
even<-data.frame(x=evenR,y=evenW)
pooled<-data.frame(x=c(evenR,oddR),y=c(evenW,oddW))
par(mfrow=c(2,1))
n=length(even$x)
plot(even$x,even$y,ylim=c(-1,2.83),xlim=c(0*10^6,4*10^7),col="red",lwd=2)
T<-ksmooth(even$x/10^7,even$y,"normal",bandwidth=0.87,n.points=200)
lines(T$x*10^7,T$y,col="red",lwd=2.5)
D<-T$y[2:200]-T$y[1:199]

lines(c(-4*10**8,4*10**8),c(2,2),col="red")
B=1000
M=matrix(NA,200,B)
for (i in seq(1:B)){
permutation<-sample(1:n, replace=TRUE)
X=even$x[permutation[1:n]]
Y=even$y[permutation[1:n]]
M[1:200,i]<-ksmooth(X/10^7,Y,"normal",bandwidth=0.87,n.points=200)$y}
N=M[2:200,]-M[1:199,]
M=apply(M,1,sort)
N=apply(N,1,sort)
Upper=M[round(0.975*B),]
Lower=M[round(0.025*B),]
DUpper=N[round(0.975*B),]
DLower=N[round(0.025*B),]
lines(T$x*10^7,Lower,col="red",lwd=1.5)
lines(T$x*10^7,Upper,col="red",lwd=1.5)


points(odd$x,odd$y,col="green",lwd=2)
T<-ksmooth(odd$x/10^7,odd$y,"normal",bandwidth=0.87,n.points=200)
lines(T$x*10^7,T$y,col="green",lwd=2.5)
D<-T$y[2:200]-T$y[1:199]

lines(c(-4*10**8,4*10**8),c(0,0),col="black")
B=1000
n=length(odd$x)
M=matrix(NA,200,B)
for (i in seq(1:B)){
permutation<-sample(1:n, replace=TRUE)
X=odd$x[permutation[1:n]]
Y=odd$y[permutation[1:n]]
M[1:200,i]<-ksmooth(X/10^7,Y,"normal",bandwidth=0.87,n.points=200,range.x = range(odd$x/10^7))$y}
N=M[2:200,]-M[1:199,]
M=apply(M,1,sort)
N=apply(N,1,sort)

Upper=M[round(0.975*B),]
Lower=M[round(0.025*B),]
DUpper=N[round(0.975*B),]
DLower=N[round(0.025*B),]
lines(T$x*10^7,Lower,col="green",lwd=1.5)
lines(T$x*10^7,Upper,col="green",lwd=1.5)

plot(even$x,even$y,xlim=c(0*10^6,4*10^7),col="red",lwd=2)
lines(T$x[1:199]*10**7,D,col="orange",lwd=2.5)
lines(T$x[1:199]*10**7,DUpper,col="orange",lwd=1.5)
lines(T$x[1:199]*10**7,DLower,col="orange",lwd=1.5)
lines(T$x[1:199]*10**7,D,col="cyan",lwd=2.5)
lines(T$x[1:199]*10**7,DUpper,col="cyan",lwd=1.5)
lines(T$x[1:199]*10**7,DLower,col="cyan",lwd=1.5)



