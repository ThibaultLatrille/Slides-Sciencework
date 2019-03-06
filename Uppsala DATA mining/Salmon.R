evenR<-c(5*10^6,7.0*10^6,7.5*10^6,7.9*10^6,8.6*10^6,9.5*10^6,1.1*10^7,1.8*10^7,1.25*10^7,1.38*10^7,1.52*10^7,1.55*10^7,1.75*10^7,1.95*10^7,2.00*10^7,2.25*10^7,2.45*10^7,2.75*10^7,3*10^7,3.2*10^7,3.4*10^7)
evenW<-c(2.4354,1.7624,2.156,2.25263,1.724,1.94,1.6528,1.6169,1.5586,1.68638,1.45368,1.7258,1.438,1.58396,1.35369,1.42963,1.3583,1.48683,1.38368,1.45863,1.48645)
oddR<-c(2.3*10^6,2.32*10^6,2.35*10^6,4.1*10^6,4.2*10^6,4.35*10^6,4.9*10^6,5.3*10^6,7*10^6,7.3*10^6,7.35*10^6,8.3*10^6,9*10^6,9.8*10^6,9.9*10^6,1.15*10^7,1.42*10^7,1.5*10^7,1.7*10^7,1.9*10^7)
oddW<-c(1.95564,2.221,2.454,2.135,2.445,2.312,2.25123,2.3135,1.850,2.013215,2.1185,2.23135,2.15155,2.13145,2.6364,1.94264,1.7483,1.928546,1.55364,1.5253)
odd<-data.frame(popsize=oddR,weight=oddW)
even<-data.frame(popsize=evenR,weight=evenW)
pooled<-data.frame(popsize=c(evenR,oddR),weight=c(evenW,oddW))
par(mfrow=c(1,1))
plot(even$popsize,even$weight,ylim=c(1,3),xlim=c(-5*10^6,4.5*10^7),col="red")
points(odd$popsize,odd$weight,col="green")
plot(pooled$popsize,pooled$weight,ylim=c(1,3),xlim=c(2*10^6,3.5*10^7))

plot(density(pooled$popsize,kernel="gaussian",bw="sj"),ylim=c(0,8*10^-8))
lines(density(even$popsize,kernel="gaussian",bw="sj"),col="red")
lines(density(odd$popsize,kernel="gaussian",bw="sj"),col="green")

plot(density(pooled$weight,kernel="gaussian",bw="sj"),ylim=c(0,1.8))
lines(density(even$weight,kernel="gaussian",bw="sj"),col="red")
lines(density(odd$weight,kernel="gaussian",bw="sj"),col="green")
wilcox.test(even$weight,odd$weight)
wilcox.test(even$popsize,odd$popsize)

library(FNN)


Bandwidth<-function(Data){
n<-length(Data);k<-floor(0.86*n);eps<-0
while (eps<0.02){
	permutation<-sample(1:n, replace=FALSE)
	training<-Data[permutation[1:k]]
	test<-Data[permutation[seq(k+1,n)]]
	eps<-min(get.knnx(training, test, k=1, algorithm="brute")$nn.dist)}
FIT<-0
bandw<-0
for (h in seq(.0001,10*max(Data)/n,max(Data)/100)){
	ds<-density(training,kernel="gaussian",bw=h)
	mini<-ds$x[1]
	maxi<-ds$x[512]
	TEST<-test[c(test>mini & test<maxi)]
	j<-round((TEST-mini)/(maxi-mini)*511)+1
	SUM<-sum(ds$y[j])
	if (FIT <= SUM){
		FIT<-SUM
		bandw<-h}
}
plot(density(training,kernel="gaussian",bw="sj"),ylim=c(0,1.8),lwd=2,col="blue")
points(training,rep(0,length(training)),lwd=2)
points(test,rep(0,length(test)),lwd=2,col="red")
ds=density(training,kernel="gaussian",bw=bandw)
lines(ds,col="cyan",lwd=2)
mini<-ds$x[1]
	maxi<-ds$x[512]
	TEST<-test[c(test>mini & test<maxi)]
	j<-round((TEST-mini)/(maxi-mini)*511)+1
	SUM<-sum(ds$y[j])
print("bandwidth : ")
print(bandw)
print(SUM)

legend(locator(n=1),legend=" ")
plot(density(training,kernel="gaussian",bw="sj"),ylim=c(0,1.8),lwd=2,col="blue")
points(training,rep(0,length(training)),lwd=2)
points(test,rep(0,length(test)),lwd=2,col="red")
ds=density(training,kernel="gaussian",bw=0.04)
lines(ds,col="cyan",lwd=2)
mini<-ds$x[1]
	maxi<-ds$x[512]
	TEST<-test[c(test>mini & test<maxi)]
	j<-round((TEST-mini)/(maxi-mini)*511)+1
	SUM<-sum(ds$y[j])
print("bandwidth : ")
print("0.04")
print(SUM)

legend(locator(n=1),legend=" ")
plot(density(training,kernel="gaussian",bw="sj"),ylim=c(0,1.8),lwd=2,col="blue")
points(training,rep(0,length(training)),lwd=2)
points(test,rep(0,length(test)),lwd=2,col="red")
ds=density(training,kernel="gaussian",bw=0.35)
lines(ds,col="cyan",lwd=2)
mini<-ds$x[1]
	maxi<-ds$x[512]
	TEST<-test[c(test>mini & test<maxi)]
	j<-round((TEST-mini)/(maxi-mini)*511)+1
	SUM<-sum(ds$y[j])
print("bandwidth : ")
print("0.35")
print(SUM)

return(bandw)
}

plot(even$popsize,even$weight,ylim=c(1.2,2.83),xlim=c(0*10^6,4*10^7),col="black")
points(odd$popsize,odd$weight,col="black")
B<-ksmooth(pooled$popsize/10^7,pooled$weight,"normal",n.points=200)
lines(B$x*10^7,B$y,col="blue",lwd=2)
G<-ksmooth(odd$popsize/10^7,odd$weight,"normal",n.points=200)
lines(G$x*10^7,G$y,col="green")
R<-ksmooth(even$popsize/10^7,even$weight,"normal",n.points=200)
lines(R$x*10^7,R$y,col="red")


Bsmooth<-function(Data){
Data[,1]<-Data[,1]/10^7
n<-length(Data[,1]);k<-floor(0.8*n);
permutation<-sample(1:n, replace=FALSE)
training<-data.frame(x=Data[permutation[1:k],1],y=Data[permutation[1:k],2])
test<-data.frame(x=Data[permutation[seq(k+1,n)],1],y=Data[permutation[seq(k+1,n)],2])
MSE<-Inf
bandw<-0
for (h in seq(0.2,2,0.001)){
	reg<-ksmooth(training$x,training$y,"normal",bandwidth=h,range.x = range(Data[,1]))
	mini<-reg$x[1]
	maxi<-reg$x[100]
	j<-round((test$x-mini)/(maxi-mini)*99)+1
	SUM<-sum((reg$y[j]-test$y)^2)
	if (SUM <= MSE){
		MSE<-SUM
		bandw<-h}
}

plot(training$x*10^7,training$y,ylim=c(1.2,2.8),xlim=c(0*10^6,3.5*10^7),lwd=1.5)
points(test$x*10^7,test$y,col="red",lwd=1.5)
B<-ksmooth(training[,1],training[,2],"normal",range.x = range(Data[,1]))
lines(B$x*10^7,B$y,col="blue",lwd=2)
C<-ksmooth(training[,1],training[,2],"normal",bandwidth=bandw,range.x = range(Data[,1]))
lines(C$x*10^7,C$y,col="cyan",lwd=2)
j<-round((test$x-mini)/(maxi-mini)*99)+1
SUM<-sum((C$y[j]-test$y)^2)
print("bandwidth : ")
print(bandw)
print(SUM)
legend(locator(n=1),legend=" ")

plot(training$x*10^7,training$y,ylim=c(1.2,2.8),xlim=c(0*10^6,3.5*10^7),lwd=1.5)
points(test$x*10^7,test$y,col="red",lwd=1.5)
lines(B$x*10^7,B$y,col="blue",lwd=2)
C<-ksmooth(training[,1],training[,2],"normal",bandwidth=0.1,range.x = range(Data[,1]))
lines(C$x*10^7,C$y,col="cyan",lwd=2)
j<-round((test$x-mini)/(maxi-mini)*99)+1
SUM<-sum((C$y[j]-test$y)^2)
print("0.1")
print(SUM)
legend(locator(n=1),legend=" ")

plot(training$x*10^7,training$y,ylim=c(1.2,2.8),xlim=c(0*10^6,3.5*10^7),lwd=1.5)
points(test$x*10^7,test$y,col="red",lwd=1.5)
lines(B$x*10^7,B$y,col="blue",lwd=2)
C<-ksmooth(training[,1],training[,2],"normal",bandwidth=3,range.x = range(Data[,1]))
lines(C$x*10^7,C$y,col="cyan",lwd=2)
j<-round((test$x-mini)/(maxi-mini)*99)+1
SUM<-sum((C$y[j]-test$y)^2)
print("3")
print(SUM)
return(bandw)
}

#Bandwidth(pooled$weight)
#Bsmooth(pooled)

plot(pooled$popsize,pooled$weight,ylim=c(1.2,2.83),xlim=c(0*10^6,4*10^7),col="black",lwd=2)
T<-ksmooth(pooled$popsize/10^7,pooled$weight,"normal",bandwidth=0.87,n.points=100)
lines(T$x*10^7,T$y,col="blue",lwd=2)
PLUS<-T$y[3:100]
MOINS<-T$y[1:98]
B<-T$y[2:99]
D<-PLUS-B
DS<-PLUS+MOINS-2*B
lines(T$x[2:99]*10**7,D*0.3*10**2+2,col="red",lwd=2)
lines(c(-4*10**8,4*10**8),c(2,2),col="black")
lines(T$x[2:99]*10**7,DS*8*10**2+2,col="green",lwd=2)


