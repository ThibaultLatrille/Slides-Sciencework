### Rejection sampling ###
### Instrument = Normal, Goal = sin ###
### Compare the calculations above ###
equation <- function(x,sigma) (x-pi/4)*tan(2*x)+2*sigma^2
dsin <- function(x){
if (x>0 & x<pi/2) return(sin(2*x))
else return(0)
}
cdf <- function(x) (1-cos(2*x))/2

Sigma <- 0.2
xmin <- uniroot(equation, c(0, pi/4-.Machine$double.eps), tol = 0.00001, sigma = Sigma)
M=dsin(xmin$root)/dnorm(xmin$root,pi/4,Sigma)

equation <- function(x,sigma) (x-pi/4)*tan(2*x)+2*sigma^2

xx <- seq(0,pi/2,0.01)
plot(xx,equation(xx,Sigma),"l",ylab="density",
ylim=c(-100,M), col=2,lty=1, lwd=3,
main="Goal and instrumental distribution")

F <- TRUE
while (F){
Sigma<-Sigma+0.001
xmin <- uniroot(equation, c(0, pi/4-.Machine$double.eps), tol = 0.00001, sigma = Sigma)
newM=dsin(xmin$root)/dnorm(xmin$root,pi/4,Sigma)
if (newM>M) {
F=FALSE
Sigma=Sigma-0.001}
else M=newM
}
print(Sigma)

acceptreject <- function(N,M,sigma)
{
rand<-rep(NA,N);
for(i in 1:N){
L<-TRUE;
while(L){
rand[i] <- rnorm(1,pi/4,sigma);
r <- dsin(rand[i])/(M*dnorm(rand[i],pi/4,sigma));
if(runif(1)<r){
L<-FALSE}
}}; return(rand)
}

xx <- seq(0,pi/2,0.01)
plot(xx,sin(2*xx),"l",ylab="density",
ylim=c(0,M), col=2,lty=1, lwd=3,
main="Goal and instrumental distribution")
lines(xx,M*dnorm(xx,pi/4,Sigma),"l",col=3,lwd=3)
legend(locator(n=1),legend=c("N(0,1)","1.52*Cauchy(0,1)"),
lwd=2,col=2:3)

### Rejection sampling###

R<-acceptreject(10000,M,Sigma)
hist(R)
ks.test(R,"cdf")