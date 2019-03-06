############# First steps in R ###############
### very first steps ########
x<-1
y<-pi
y
x+y
x*y
######### produce regular sequences ###########
T1<-1:100
T1
T2<-rep(3,100)
T2
T3<-seq(0,10,0.01)
str(T3) #structure
T3[4]
length(T3)
min(T3)
max(T3)
help(max)
############### generating random variables #############
z1<-rnorm(100,3,2)
help(rnorm)
z1
z2<-rexp(10,rate=2)
help(rexp)
mean(z1)
var(z1)
sum(z1)
median(z1)
sd(z1)
x11()
hist(z1)
help(hist)
str(hist(z1))
hist(z1)$counts
################## plot ################
x11()
plot(z1)
x11()
plot.ts(z1, main="White Noise",ylab="",xlab="time",lwd=2, col=3,lty=2)
T1<-1:100
T2<-rep(3,100)
lines(T1,T2,col=2,lwd=3)
legend(locator(n=1),legend=c("mean","N(3,2)"),lwd=2,col=2:3,lty=1:2)
points(50,5,pch=20,lwd=4)
text(60,4,"Text")
help(plot)
x11()
plot(rnorm(1000),rnorm(1000),col=4,lwd=2,main="Normal Cloud")
################################# white noise ###########
x1<-rnorm(200)
str(x1)
help(ts)
xt<-ts(x1,start=1800,end=1999)
str(xt)
plot(xt,main="White Noise",xlab="year")
############################ 


