
#### Basic Calculations with R #####
4+5
4*5
10%%3 #mod(3)#
4*5%%3
(4*5)%%3

##### objects: list, column vector, matrix #############
A<-matrix(,nr=2,nc=3)
A
A[1,1]<-1
A[1,2]<-3
A[1,3]<-0.5
A[2,1]<-4
A[2,2]<-5
A[2,3]<-10
A
A[,1] # first column #
A[1,] #first row #
n<-10
x<-rep(1,n)
y<-c(1,3,4)
z<-seq(-5,5,0.1)
help(seq)
1:n
n:1
####### random numbers #############
#####rnorm, rexp, rgamma, rpois, rweibull, rcauchy ###
#### rbeta, rt, rchisq, rbinom, rgeom, rlnnorm #####
### rnbin, runif, rwilcox ####
help(rnorm)
x1<-rnorm(100)
x1
sd(x1)
mean(x1)
help(mean)
hist(x1)
x2<-rnorm(100)
x1<-rnorm(100)
x11()
plot(x1,x2)
ts.plot(x1)

### pictures of densities #####
#help(rweibull)
xx<-seq(0,4,0.01)
plot(xx,dweibull(xx,5,1),"l",main="Weibull distribution",xlab="x",ylab="",col=1,lwd=3)
lines(xx,dweibull(xx,0.5,1),lwd=2,col=2)
legend(locator(n=1),legend=c("shape=5,scale=1","shape=0.5,scale=1"),lwd=2,col=1:2)

#help(plot)
#help(legend)


############ own generator ################
## the single steps ######
n<-10
rand<-rep(NA,n) ### reserve the space for the new sample #####
a<-1
b<-2
M<-13
seed<-2
rand[1]<-seed
rand[2]<- (a*rand[1]+b)%%M
rand 
#### introduce a loop #####
for(i in 3:n)
{
	rand[i]<-(rand[i-1]*a+b)%%M
}
rand
rand/M

################ define a function #######################
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
U<-random(2,10,13,1,2)
U
x11()# new window#
U2<-random(2,100,13,1,2)
plot.ts(U2)
hist(U2)
plot(U2[1:99],U2[2:100])

########## usual tests ####################
#help(ks.test)
ks.test(U2,"punif")
#help(chisq.test)
hist(U2)
str(hist(U2))

chisq.test(hist(U2,plot=F)$counts)


#help(shapiro.test)
Z<-rnorm(100)
Z

shapiro.test(Z)
#help(ks.test)
ks.test(Z,"pnorm")
########## chisquare test goodness of fit ##################
help(hist)
x50<-rnorm(50,3,sqrt(2))
H1<-hist(x50,freq=F,xlim=c(-3,8))
H1
#str(hist(x50))

b<-hist(x50,plot=F)$breaks
p<-rep(1,length(b)-1)
l<-length(b)
for (i in 1:(l-1))
	{
	p[i]<-pnorm(b[i+1],3,sqrt(2))-pnorm(b[i],3,sqrt(2))
	}
length(p)
sum(p)
p1<-p/sum(p)
points(hist(x50,freq=F,plot=F)$mids,p1,"h",col=2,lwd=4)
chisq.test(hist(x50,plot=F)$counts,p=p1)
xxx<-seq(-3,8,0.001)
lines(xxx,dnorm(xxx,3,sqrt(2)),lwd=2,col=3)



