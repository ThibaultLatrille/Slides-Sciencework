# TODO: Add comment
# 
# Author: Thibault
###############################################################################



TS<-ts(c(0.417237135,  0.050412427,  0.660055593, -0.103350366,  0.177153409,
		0.304908518,  0.118264704,  0.445371215, -0.038224426, -0.140547801,
		-0.052299421,  0.036005598, -0.467362266, -1.009575625, -1.327390327,
		-1.559274997, -1.219256441, -0.615158553,  0.087612553,  0.445062323,
		0.289568802,  0.514659320,  0.222517163,  0.480262478, -0.206720349,
		-0.763793537, -0.142111402, -0.820004009,  0.125002212, -0.138130212,
		-0.032419719, -0.501484169, -0.437107057, -0.402829016,  0.034824748,
		0.108250834 , 0.472764142 ,-0.134725689, -0.438346438, -0.711321734,
		-1.048417797, -0.695874036, -0.296481549,  0.141472150,  0.190985033,
		-0.563736846, -0.637472367, -0.442924256, -1.447824181, -1.196132176,
		-0.662735300, -0.190540769, -0.484483183,  0.233371028,  0.204604185,
		-0.047877047, -0.296798966,  0.116548377, -0.072636378,  0.223454088,
		-0.011173814,  0.485726765, -0.353836609, -0.215091918,  0.096890879,
		-0.031140625,  0.079818038, -0.070213811, -0.008683018, -0.079106322,
		-0.480422784,  0.019425818,  0.234021580,  0.135615947,  0.100048598,
		-0.507307910,  1.238549038,  1.208105372,  0.760086430, -0.054328619,
		0.096175816 , 0.002671722 , 0.303435622, -0.132072677,  0.331629014,
		0.459907726, -0.248762614, -0.820623042, -0.594473767, -0.287878420,
		-0.071335867, -0.288310797, -0.545438323, -0.387356298, -0.223667259,
		0.953319136,  0.428863921, -0.494308325, -0.333579644, -0.451299922))
library(scatterplot3d) 
M=data.frame(AR=rep(0,36),MA=rep(0,36),AIC=rep(0,36))
k<-1
for (i in 0:5){
	for (j in 0:5){
		M$AIC[k]<-arima(TS,c(i,0,j))$aic
		M$AR[k]<-i
		M$MA[k]<-j
		k<-k+1
		print(M$AIC[k-1])
		print(c(i,j))
	}
}
min<-M$AIC[which.min(M$AIC)]
for (i in 1:36){M$AIC[i]<-signif(exp((min-M$AIC[i])/2),2)}
s3d<-scatterplot3d(M$MA,M$AR,M$AIC,type = "h", lwd = 3, highlight.3d=TRUE, main="3D Scatterplot")
s3d.coords <- s3d$xyz.convert(M$MA,M$AR,M$AIC) # convert 3D coords to 2D projection
text(s3d.coords$x, s3d.coords$y,labels=M$AIC,cex=0.6, pos=3)
spec<-spectrum(TS,span=c(10,10))
ARMA<-arima(TS,c(0,0,2))
theta1<-ARMA$coef[[1]]
theta2<-ARMA$coef[[2]]
sigma2<-ARMA$sigma2
library(astsa)### additional packet astsa is needed ####
arma.spec(ma=c(theta1,theta2),var.noise=sigma2,log="no")
x<-arma.spec(ma=c(theta1,theta2),var.noise=sigma2,log="no")$freq
y<-arma.spec(ma=c(theta1,theta2),var.noise=sigma2,log="no")$spec
spectrum(TS,span=c(12,12))
spec<-spectrum(TS,plot=FALSE,span=c(12,12))
f<-as.numeric(spec$freq)
s<-as.numeric(spec$spec)
plot(f,s,"l",col=4,lwd=2,ylim=c(0,0.8), xlim=c(0,0.5))
lines(x,y,lwd=2,col=1)

spec<-spectrum(TS,plot=FALSE)
f<-as.numeric(spec$freq)
s<-as.numeric(spec$spec)
bandwidth<-c(4,8,12,16,24)
plot(f,s,"l",lwd=2,main="Estimation of the spectral density",xlab="frequency",ylab="spectrum")
col=2
for (i in bandwidth){
	print(i)
	spec1<-spectrum(TS,span=c(i,i),plot=FALSE)
	f1<-as.numeric(spec1$freq)
	s1<-as.numeric(spec1$spec)
	lines(f1,s1,col=col,lwd=2)
	col<-col+1
}
legend(locator(n=1),legend=c("raw",bandwidth),col=seq(1:(length(bandwidth)+1)),lty=1,lwd=2)
