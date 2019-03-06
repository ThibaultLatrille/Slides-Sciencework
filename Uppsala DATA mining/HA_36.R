A<-c(48,36,20,29,42,42,20,42,22,41,45,14,6,0,33,28,34,4,32,24,47,41,24,26,30,41)
B<-c(42,33,16,39,38,36,15,33,20,43,34,22,7,15,34,29,41,13,38,25,27,41,28,14,28,40)
n<-length(A)
Replicate<-30
Nlambda<-5
NORMA=array(rnorm(Replicate*Nlambda*n,0,5),c(Replicate,Nlambda,n))
NORMB=array(rnorm(Replicate*Nlambda*n,0,5),c(Replicate,Nlambda,n))

SIMEX<-function(A,B,Replicate,Nlambda,NORMA,NORMB){
b_estimate1<-array(NA,c(Replicate,Nlambda))
b_estimate2<-array(NA,c(Replicate,Nlambda))
LAMBDA<-rep(seq(Nlambda),rep(Replicate,Nlambda))
for (lambda in seq(Nlambda)){
for ( i in seq(Replicate)){

BS<-B+sqrt(lambda)*NORMA[i,lambda,]
model<-lm(A~BS)
b_estimate1[i,lambda]<-coef(model)[2]

AS<-A+sqrt(lambda)*NORMB[i,lambda,]
model<-lm(B~AS)
b_estimate2[i,lambda]<-1/(coef(model)[2])
	}
}
model1<-lm(c(b_estimate1)~LAMBDA)
model2<-lm(c(b_estimate2)~LAMBDA)
c1=coef(model1)
c2=coef(model2)
plot(LAMBDA,c(b_estimate1),xlim=c(-2,5),ylim=c(0.2,4.5))
points(LAMBDA,c(b_estimate2),col=3)
abline(model1)
abline(model2,col=3)
return(((c2[1]-c1[1])/(c1[2]-c2[2]))*c2[2]+c2[1])}

SIMEX(A,B,Replicate,Nlambda,NORMA,NORMB)


