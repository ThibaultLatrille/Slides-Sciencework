# Example 1 #################
########## Simulation of a simple sinusoidal model ############
n<-100
z<-rnorm(n)
T<-1:n
X<-2*cos(2*pi/3*T)+z
TS<-ts(X)
plot(TS)
############ periodogram ##############
help(spec.pgram)
spec.pgram(TS)### raw peridogram ####
spec.pgram(TS,span=c(5,5))### Daniell smoother ###
spec.pgram(TS,span=c(3,3))
str(spec.pgram(TS))
spectrum(TS) ### alternative command ###
str(spectrum(TS)) 
spectrum(TS)
######## one picture ###########
spec1<-spectrum(TS)
spec2<-spectrum(TS,span=c(3,3))
spec3<-spectrum(TS,span=c(5,5))
x11()
f1<-as.numeric(spec1$freq)
s1<-as.numeric(spec1$spec)
plot(f1,s1,"l",lwd=2,main="Estimation of the spectral density",xlab="frequency",ylab="spectrum")
f2<-as.numeric(spec2$freq)
s2<-as.numeric(spec2$spec)
lines(f2,s2,col=2,lwd=2)
f3<-as.numeric(spec3$freq)
s3<-as.numeric(spec3$spec)
lines(f3,s3,col=3,lwd=2)
legend(locator(n=1),legend=c("raw","c(3,3)","c(5,5)"),col=1:3,lty=1,lwd=2)
####################### cumultative periodogram ######################
help(cpgram)
cpgram(TS)
#####################################
#######

########## Simulation of a simple sinusoidal model ############
n<-100
z<-rnorm(n)
T<-1:n
X<-2*cos(2*pi/3*T)+5*cos(1*pi/2*T)+z
TS2<-ts(X)
plot(TS2)
spectrum(TS2)
spectrum(TS2,span=c(5,5))


cpgram(TS2)

#######
########
### Example 2 ######
######## Simulation of AR(1)#################
z3<-rnorm(n)
X3<-c(1:n)
X3[1]<-z3[1]
for( i in 2:100){X3[i]<-X3[i-1]/3+z3[i]}
TS3<-ts(X3)
plot(TS3)
acf(TS3)
pacf(TS3)
spectrum(TS3)
spectrum(TS3,span=c(3,3))

cpgram(TS3)
###### comparison of spectral densities ##
### smoothed peridogram #####
spec4<-spectrum(TS3,span=c(6,6))
f4<-as.numeric(spec4$freq)
s4<-as.numeric(spec4$spec)
#### true spectral density #####
omega<-seq(0,pi,0.01)
plot(omega,1/(1+1/9-2/3*cos(omega))*1/(2*pi), "l", lwd=2, main="spectral density of AR(1) with alpha=1/3")
####### Compare ! ####
# renormalize the frequency!!! in "spectrum" freq lies in (0.0.5)#####
plot(f4,1/(2*pi)*1/(1+1/9-2/3*cos(2*pi*f4)),ylim=c(0,0.7), "l",col=2, lwd=2, main="spectral density of AR(1) with alpha=1/3")
lines(f4,s4/(2*pi),lwd=2,main="spectral density of AR(1) with alpha=1/3",col=1)
legend(locator(n=1),legend=c("estimate","true"),col=1:2,lty=1,lwd=2)

### Calculate the (model) spectral density with R ####
library(TSA)### additional packet TSA is needed ####
help(ARMAspec)
ARMAspec(model=list(ar=c(1/3)),lwd=2,main="spectral density of AR(1) with alpha=1/3")
lines(f4,1/(1+1/9-2/3*cos(2*pi*f4)),lwd=2,col=2)## with out 1/2pi!!!!

