############################# SPACE STATE Modells ###############
##### simulate a random walk plus noise ##########
x1<-rep(0,100)
y1<-rep(0,101)
for (i in 1:100){y1[i]<-x1[i]+rnorm(1);x1[i+1]<-x1[i]+rnorm(1)}
y1t<-ts(y1)
plot(y1t, main="Random walk plus noise",ylab="Observations")
acf(y1t)
pacf(y1t)
spectrum(y1t,span=c(4,4))
cpgram(y1t)
str(y1t)
#######################
############### Kalman filter #########
help(StructTS)
Sy<-StructTS(y1t,"level")
Sy
str(Sy)
tsdiag(Sy)
str(Sy)
rest1<-Sy$resid
cpgram(rest1)

help(tsSmooth)
tsSmooth(Sy)
plot(y1t, main="random walk plus noise",lwd=2)
lines(tsSmooth(Sy),lwd=2,col=2)
legend(locator(n=1),legend=c("observations","tsSmooth"),col=1:2,lty=1,lwd=2)


## Example treering from the help file ###
help(treering)
fit <- StructTS(trees, type = "level")
plot(trees)
lines(fitted(fit), col = "green")
tsdiag(fit)# diagnostic of a result from StructTS##


###### structural model with trend ##############
x2<-rep(0,201)
y2<-rep(0,201)
for (i in 1:200){y2[i]<-0.025*i+x2[i]+rnorm(1);x2[i+1]<-x2[i]+rnorm(1)}
y2t<-ts(y2)
plot(y2t, main="Structural model", ylab="Observations")
Sy2<-StructTS(y2t,"trend")
str(Sy2)
Sy2
tsdiag(Sy2)
rest2<-Sy2$residuals
cpgram(rest2) # compare this result with tsdiag
acf(rest2)
pacf(rest2)
spectrum(rest2)
spectrum(rest2,spans=c(3,3))

SSy2<-tsSmooth(Sy2)
SSy2
plot(SSy2)

plot(Sy2$data)
lines(Sy2$resid,col=2)
plot(SSy2[,1], main="level")
plot(SSy2[,2],main="slope")
plot(y2t,lwd=2,main="Structural model", ylab="Observations" )
lines(SSy2[,1],col=2,lwd=2)
legend(locator(n=1),legend=c("observations","tsSmooth"),col=1:2,lty=1,lwd=2)



########### Example -real data set ##################
########### 
help(AirPassengers)
x11()
plot(AirPassengers)
ts<-AirPassengers
ts
str(ts)
tts<-StructTS(ts,"BSM")
tts1<-tsSmooth(tts)
tts1
lines(tts1[,1],col=2,lwd=2)
plot(tts1)
tsdiag(tts)
##############Compare with stl #########
stl(AirPassengers,"per")
plot(stl(AirPassengers,"per"))
