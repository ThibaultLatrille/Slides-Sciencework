


#### Example 1.3.6 Accidental death- harmonic regression #######
data(USAccDeaths) 
help(USAccDeaths)
plot(USAccDeaths)
str(USAccDeaths)
dea<-as.numeric(USAccDeaths)
t<-1:72
plot(t,dea)
lines(t,dea)
lines(12:72,dea[12:72],col=2)
### harmonic regression, Figure 1-11 ####
x1<-cos(6*2*pi/72*t)
x1
x2<-sin(6*2*pi/72*t)
x3<-cos(12*2*pi/72*t)
x4<-sin(12*2*pi/72*t)
M3<-lm(dea~x1+x2+x3+x4)
str(M3)
summary(M3)
M3$fitted
x11()
plot.ts(dea)
lines(t,M3$fitted,"l",lwd=2,col=2 )
points(t,dea)## Figure 1-11 ###
##### model with out first year #######
t<-1:72
plot(t,dea)
lines(t,dea)
lines(13:72,dea[13:72],col=2)
## truncated data set #####
t1<-13:72
dea1<-dea[13:72]
n1<-length(t1)
n1
#### harmonic regression for the truncated data #####
f1<-n1/12
f1
f2<-n1/6
f2
xx1<-cos(5*2*pi/60*t1)
xx2<-sin(5*2*pi/60*t1)
xx3<-cos(10*2*pi/60*t1)
xx4<-sin(10*2*pi/60*t1)
M4<-lm(dea1~xx1+xx2+xx3+xx4)
#str(M4)
#M4$fitted
x11()
plot.ts(dea)
lines(t1,M4$fitted,"l",lwd=2,col=2 )
points(t,dea)# ###
### picture with both model fits ##########
x11()
t<-1:72
plot(dea,main="USAccDeath",ylab="")
lines(t,dea)
lines(t1,M4$fitted,"l",lwd=2,col=2 )
lines(t,M3$fitted,"l",lwd=2,col=3 )
legend(locator(n=2),legend=c("all years","without first year"),lwd=2,col=c(3,2))







