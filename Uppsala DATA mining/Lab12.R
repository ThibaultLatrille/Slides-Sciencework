#### Some plot exercises #########
plot( 1:30,1:30,pch=1:30,col=1:30)
###
plot(1:10,1:10,"l",pch=14,ylim=c(-1,12),lty=2,main="Plot Exercises",ylab="y-variable",lwd=1)
lines(1:10,2*(1:10),lty=3,col=3,lwd=2)
points(1:10,2*(1:10),lwd=5,col="dark green",pch=12)
lines(1:10,0.5*(1:10),lty=3,lwd=2)
x<-c((1:10),(10:1))
y<-c(0.8*(1:10),0.7*(10:1))
help(polygon)
polygon( x,y,col=3,border="dark red",lwd=2)
text(4,4,"A",col=2)
text(8,4,"B",col=2)
text(10,4,expression(theta))
segments(4,4,8,4,lwd=3,lty=6,col=4)
rect(1,8,4,10,col="gray",lwd=2)##new###

### plot games II ###########new###
rnorm(100,5,3)
plot(rnorm(100),rnorm(100),asp=1)
plot(rnorm(100),rnorm(100), xlab="",ylab="", main="Plot Exercises II")
plot(rnorm(100),rnorm(100), xlab="",ylab="", main="Plot Exercises II",axes=F)
plot(rnorm(100),rnorm(100),"l", xlab="",ylab="", main="Plot Exercises II",axes=F)
plot(sort(rnorm(100)),rnorm(100),"l", xlab="",ylab="", main="Plot Exercises II")

plot(rnorm(100),rnorm(100),asp=1, xlab="",ylab="", main="Plot Exercises II")
plot(rnorm(100),rnorm(100),asp=1, xlab="",ylab="", main="Plot Exercises II",ylim=c(-3,3),xlim=c(-3,3))

##############################################################
##############################################################
##############################################################



### linear congruential generator ################
random<-function(seed,n,M,a,b)
{
	rand<-rep(NA,n);
	rand[1]<-seed;
	for(i in 2:n)
	{
	rand[i]<-(rand[i-1]*a+b)%%M
	};
	return(rand/M)
}
###########################################
UU<-random(2,100,128,113,1)
plot(1:100,UU,"l")
ks.test(UU,"punif")
hist(UU)
plot(UU[1:99],UU[2:100])
######### Nice picture with Box Muller #############

picture<-function(seed1,seed2,n,N,M,a,b)
{
	u1<-random(seed1,N,M,a,b)
	u2<-random(seed2,N,M,a,b)
	x1<-sqrt(-2*log(u1))*cos(2*pi*u2)
	x2<-sqrt(-2*log(u1))*sin(2*pi*u2)
	plot(x1[n:N],x2[n:N],"p",pch=21,asp=1,col=2, main="Nice Picture Using a Linear Congruentional Generator",axes=F,ylab="",xlab="",ylim=c(-3,3),xlim=c(-3,3))
}
################# Examples #####################
x11()
picture(0,1,20,600,541,5,1)
x11()
picture(0,1,20,600,31218,5,1)
x11()
picture(0,1,20,600,128,113,1)
x11()
picture(0,2,1000,10000,2048,129,1)### Rosette####
x11()
picture(0,1,200,10000,2048,65,1)#### Ripley ####new#

###
picture1<-function(seed1,seed2,n,N,M,a,b)
{
	u1<-random(seed1,N,M,a,b)
	u2<-random(seed2,N,M,a,b)
	x1<-sqrt(-2*log(u1))*cos(2*pi*u2)
	x2<-sqrt(-2*log(u1))*sin(2*pi*u2);
	return(x1[n:N])
}
ts.plot(picture1(0,2,200,1000,2048,129,1))
shapiro.test(picture1(0,2,200,1000,2048,129,1))
#####################################


