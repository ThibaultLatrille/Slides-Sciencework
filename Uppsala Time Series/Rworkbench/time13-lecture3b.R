### detrending Method 1 ###
## moving average ####
#### Smoothing with a filter #############
help(filter)
## test -simple 3 point filter #####
rep(1/3,3)
y<-1:10
y
filter(y,rep(1/3,3))
## 
y2<-rnorm(100)
f1a<-filter(y2,rep(1/3,3))
f1b<-filter(y2,rep(1/7,7))

plot.ts(y2,main="Filter - Moving average",lwd=2)
lines(f1a,col=2,lwd=2)
lines(f1b,col=3,lwd=2)

### Example Lake Huron ######
data(LakeHuron)
#help(LakeHuron)
plot(LakeHuron)
#str(LakeHuron)
X<-LakeHuron
rep(1/3,3)
f2<-filter(X,rep(1/3,3))
plot(f2,main="Lake Huron",lwd=2,col=2)
lines(X,col=1,lwd=2)
f2a<-filter(X,rep(1/5,5))
f2b<-filter(X,rep(1/20,20))
lines(f2b,lwd=3,col=6)
f2c<-filter(X,rep(1/50,50))
lines(f2c,lwd=3,col=10)
lines(f2a,col=5,lwd=2)
legend(locator(n=1),legend=c("time series","three points","five points"),lwd=2,col=1:3)

#### Filter in series ######
##### 2 points ####
plot(X, main="Lake Huron trend estimated by filter in series" )
F2<-filter(X,rep(1/3,3))
F3<-filter(F2,rep(1/3,3))
F4<-filter(F3,rep(1/3,3))
lines(F2,col=2,lwd=2)
lines(F3,col=3,lwd=2)
lines(F4,col=4,lwd=2)
legend(locator(n=1),legend=c("time series","three points","first time repeated","second time repeated"),lwd=2,col=1:5)
##################################
### Spencer #####
f<-c(-3,-6,-5,3,21,46,67,74,67,46,21,3,-5,-6,-3)/320
plot(X,main="Lake Huron trend estimated by spencer" ,lwd=2)
FS<-filter(X,f)
lines(FS,col=2,lwd=2)
#####################################


Fexp<-filter(0.9*X,0.1,method="recursive",init=X[1])
help(filter)
plot(Fexp,col=2,lwd=2,main="exponential smoothing, alpha=0.9")
lines(X,lwd=2)
######
Fexp2<-filter(0.5*X,0.5,method="recursive",init=X[1])
plot(Fexp2,col=2,lwd=2,main="exponential smoothing, alpha=0.5")
lines(X,lwd=2)
