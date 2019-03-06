A=c(48,36,20,29,42,42,20,42,22,41,45,14,6,0,33,28,34,4,32,24,47,41,24,26,30,41)
B=c(42,33,16,39,38,36,15,33,20,43,34,22,7,15,34,29,41,13,38,25,27,41,28,14,28,40)
plot(A,B,main="Spatial data set:",xlab="A",
ylab="B")

A=c(48,36,20,29,42,42,20,42,22,41,45,14,6,0,33,28,34,4,32,24,47,41,24,26,30,41)

T=function(x){
return((sum(x**2)/length(x)-mean(x)**2))} # bootstrap replications of the variance
bootsample=rep(NA,1000)
for( i in 1:1000){bootsample[i]<-T(sample(A,replace=TRUE))}
theta.hat=T(A)
L1=sort(bootsample)[25]
U1=sort(bootsample)[975]
L1
U1
theta.hat
hist(bootsample, xlab="theta*", main="Histogram of the bootstrap replicate estimation of theta")
points(theta.hat,0)

mu=mean(A)
sigma=sqrt((sum(A**2)-mean(A)**2*26)/25)
sigma
bootsample=rep(NA,1000)
for( i in 1:1000){bootsample[i]<-T(rnorm(26,mu,sigma))}
L2=sort(bootsample)[25]
U2=sort(bootsample)[975]
L2
U2
hist(bootsample, xlab="theta*", main="Histogram of the bootstrap replicate estimation of theta")
points(theta.hat,0)

V<-function(x){n<-length(x)
return((n-1)/n**3*T(x)**2*((n-1)/n*sum((x-mean(x))**4)/T(x)**2-n+3))}
bootsample<-rep(NA,1000)
for( i in 1:1000){
replicate<-sample(A,replace=TRUE)
bootsample[i]<-(T(replicate)-theta.hat)/sqrt(V(replicate))}
bootsample<-sort(theta.hat-sqrt(V(A))*bootsample)
L3<-bootsample[25]
U3<-bootsample[975]
L3
U3
hist(bootsample, xlab="theta*", main="Histogram of the bootstrap replicate estimation of theta")
points(theta.hat,0)



