

####trend estimation by linear regression ######################

############# Example 1.3.5 ##############
data(LakeHuron)
help(LakeHuron)
plot(LakeHuron)
str(LakeHuron)
y<-LakeHuron
year<-seq(1875,1972,1)
length(year)
length(y)
plot(year,y,"p",lwd=3, main="Lake Huron")
M1<-lm(y~year)
summary(M1)
abline(M1,col=2,lwd=2)
lines(year,y)#### Figure 1-9 ####
#######
str(M1)
M1$resid
x11()
plot(year,M1$resid,"l", ylab="residuals", lwd=1)
points(year,M1$resid, pch=19, lwd=3)
lines(c(1875,1972),c(0,0),lwd=2)  ### Figure 1-10 ####
#### Example 1.3.6 Accidental death- harmonic regression #######
data(USAccDeaths) 
help(USAccDeaths)
plot(USAccDeaths)
str(USAccDeaths)
dea<-as.numeric(USAccDeaths)
t<-1:72
plot(t,dea)
lines(t,dea)
### harmonic regression, Figure 1-11 ####
x1<-cos(6*2*pi/72*t)
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




