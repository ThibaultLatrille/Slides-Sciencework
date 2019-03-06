X=ts(read.table('C:/Users/Thibault/Desktop/Time Series/test_clear.txt'))
year<-seq(1959,2009,1)


f<-c(-3,-6,-5,3,21,46,67,74,67,46,21,3,-5,-6,-3)/320
plot(year,X,lwd=2)
FS<-filter(X,f)
lines(year,FS,col=2,lwd=2)


Fexp<-filter(0.9*X,0.1,method="recursive",init=X[1])
plot(year,X,col=2,lwd=2,main="exponential smoothing, alpha=0.9")
lines(year,Fexp,lwd=2)

res=Fexp-X
acf(res)

z<-rep(0,50)
for (j in 2:51){z[j-1]<-X[j]}
Xn<-X[1:50]
plot(z,Xn, pch=21,lwd=2,ylab="y(t)",xlab="y(t-1)")
M2<-lm(Xn~z)
abline(M2,col=3,lwd=2)## Figure 1-16 ###
##################
# AR(1)with the residuals ar better??????? 
summary(M2)
phi<-M2$coefficient[[2]] ## estimate of theta###
## compare the acf ###
acf(res)
gamma2.ar<-rep(1,21)
for(j in 2:21){gamma2.ar[j]<-(phi)^{j+1}}
points(seq(0,20,1),gamma2.ar,"p",col=2,lwd=3,pch=19)
