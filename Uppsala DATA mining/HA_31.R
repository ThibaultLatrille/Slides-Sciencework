k=2
alpha=3
data=k/((1-runif(11))**(1/alpha))

theta=function(x){
return((sum(x**2)/length(x)-mean(x)**2)/(k*k))} # bootstrap replications of the mean

bootsample=rep(NA,B)
for( i in 1:1000){bootsample[i]<-theta(sample(data,replace=T))}
theta.hat=theta(data)
L1=sort(bootsample)[25]
U1=sort(bootsample)[975]

ALPHA=mean(data)/(mean(data)-k) # bootstrap replications of the mean

bootsample=rep(NA,1000)
for( i in 1:1000){bootsample[i]<-theta(k/((1-runif(11))**(1/ALPHA)))}
theta.hat2=theta(data)
L2=sort(bootsample)[25]
U2=sort(bootsample)[975]

plot(c(L1,U1),c(0.5,0.5),lwd=2,pch="" ,
main="Bootstrap confidence intervals",
yaxt="n", ylim=c(0,1.5), xlim=c(0,max(U1,U2)+0.1),
ylab="",xlab="theta")
segments(L1,0.5,U1,0.5,col=2,lwd=3)
text(U1,0.5,"[")
text(L1,0.5,"]")
points(theta.hat,0.5)
segments(L2,1,U2,1,col=3,lwd=3)
text(U2,1,"[")
text(L2,1,"]")
points(theta.hat2,1)
