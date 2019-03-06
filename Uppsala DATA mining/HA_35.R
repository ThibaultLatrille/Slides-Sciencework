A<-c(48,36,20,29,42,42,20,42,22,41,45,14,6,0,33,28,34,4,32,24,47,41,24,26,30,41)
B<-c(42,33,16,39,38,36,15,33,20,43,34,22,7,15,34,29,41,13,38,25,27,41,28,14,28,40)

SIMEX<-function(A,B){

R<-30
l<-5
L<-rep(NA,R*l)
C<-rep(NA,R*l)
IC<-rep(NA,R*l)

for (lambda in seq(l)){
for ( i in seq(R)){
L[i+(lambda-1)*R]<-lambda

BS<-B+sqrt(lambda)*rnorm(length(B),0,6)
model<-lm(A~BS)
C[i+(lambda-1)*R]<-coef(model)[2]

AS<-A+sqrt(lambda)*rnorm(length(A),0,6)
model<-lm(B~AS)
IC[i+(lambda-1)*R]<-1/(coef(model)[2])
	}
}
model1<-lm(C~L)
model2<-lm(IC~L)
c1=coef(model1)
c2=coef(model2)
return(((c2[1]-c1[1])/(c1[2]-c2[2]))*c2[2]+c2[1])}

SIMEX(A,B)

bootsample<-rep(NA,100)
for( i in 1:100){
replicate<-sample(1:26, replace=TRUE)
As=A[replicate]
Bs=B[replicate]
bootsample[i]<-SIMEX(As,Bs)}
hist(bootsample, xlab="b*", main="Histogram of the bootstrap replicate estimation of b")
L1=sort(bootsample)[2]
U1=sort(bootsample)[97]

plot(L,C,xlim=c(-3,5),ylim=c(0.2,4.5))
points(L,IC,col=3)
abline(model1)
abline(model2,col=3)
