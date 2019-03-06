A=c(48,36,20,29,42,42,20,42,22,41,45,14,6,0,33,28,34,4,32,24,47,41,24,26,30,41)
B=c(42,33,16,39,38,36,15,33,20,43,34,22,7,15,34,29,41,13,38,25,27,41,28,14,28,40)
plot(A,B,main="Spatial data set:",xlab="A",
ylab="B")
cor(x,u) ### sample correlation ###
### interested in E(X)/E(U) ###
### nonparametric bootstrap: sample pairs ###
F1<-function(x,y){n<-length(x);
u<-sample(1:n,replace=T);
data<-data.frame(x[u],y[u]);
return(data)}
BB1<-F1(u,x)
BB1
B1<-F1(u,x)
points(B1,col=2)
ub<-B1$x
xb<-B1$y
theta.hat<-mean(x)/mean(u)
theta.hat
### percentile confidence region ###
boot3<-function(B){theta<-rep(NA,B);
for (i in 1:B){B1<-F1(u,x);
theta[i]<-mean(B1$y)/mean(B1$x)}
return(theta)}
B3<-sort(boot3(999))
B3[25]
B3[975]
int1<-c(B3[25],B3[973])
plot(int1,c(0.5,0.5),lwd=2,pch="" ,
main="Bootstrap confidence intervals",
yaxt="n", ylim=c(0,2), xlim=c(1.1,1.45),
ylab="",xlab="theta")
segments(B3[25],0.5,B3[975],0.5,col=2,lwd=3)
text(B3[25],0.5,"[")
text(B3[975],0.5,"]")
points(theta.hat,0.5)
### basic bootstrap ###
LOW<-2*theta.hat-B3[975]
52 BOOTSTRAP
UP<-2*theta.hat-B3[25]
### sign it in the plot ###
segments(LOW,1,UP,1, col=3,lwd=3)
text(LOW,1,"[")
text(UP,1,"]")
points(theta.hat,1)
### studentized theta.hat ###
### standard error of theta.hat ###
t<-mean(x)/mean(u)
var<-mean((x-u*t)^2)/mean(u)^2
se<-sqrt(var)
#### studb= the bootstrapped t statistic ###
studb<-function(xb,ub,x,u){tb<-mean(xb)/mean(ub);
varb<-mean((xb-ub*tb)^2)/mean(ub)^2 ;
studb<-(mean(xb)/mean(ub)-mean(x)/mean(u))/sqrt(varb);
return(studb)}
### calculating the bootstrap replications, percentiles ###
bootstud<-function(B){TB<-rep(NA,B);
for (i in 1:B){B1<-F1(u,x);TB[i]<-studb(B1$y,B1$x,x,u) };
return(TB)}
TS<-sort(bootstud(999))
U<-TS[25]
L<-TS[975]