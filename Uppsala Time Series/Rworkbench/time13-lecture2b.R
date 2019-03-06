

####Remind Lake Huron ####
############# Example 1.3.5 ##############
data(LakeHuron)
help(LakeHuron)
plot(LakeHuron)
#str(LakeHuron)
y<-LakeHuron
year<-seq(1875,1972,1)
length(year)
length(y)
plot(year,y,"p",lwd=3, main="Lake Huron")
M1<-lm(y~year)
summary(M1)
abline(M1,col=2,lwd=2)
lines(year,y)#### Figure 1-9 ####
str(M1)
#### autocorrelation #####
### acf Lake Huron ####
#help(acf)
x11()
plot.ts(M1$resid,main="Detrended Lake Huron Series")
acf(M1$resid)## Figur 1:15
acf(M1$resid,type="covariance",main="Residuals Lake Huron data")



##### 1.4.2 model for Lake Huron #####
y<-LakeHuron
str(y)
yn<-as.numeric(y)
str(yn)
z<-rep(0,97)
for (j in 2:98){z[j-1]<-yn[j]}
yyn<-yn[1:97]
plot(z,yyn, pch=21,lwd=2,ylab="y(t)",xlab="y(t-1)",main="Lake Huron")
M2<-lm(yyn~z)
abline(M2,col=3,lwd=2)## Figure 1-16 ###
##################
# AR(1)with the residuals ar better??????? 




####
summary(M2)
phi<-M2$coefficient[[2]] ## estimate of theta###
phi
## compare the acf ###
acf(M1$resid)
gamma2.ar<-rep(1,21)
for(j in 2:21){gamma2.ar[j]<-(phi)^{j+1}}
points(seq(0,20,1),gamma2.ar,"p",col=2,lwd=3,pch=19)


