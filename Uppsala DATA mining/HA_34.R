A=c(48,36,20,29,42,42,20,42,22,41,45,14,6,0,33,28,34,4,32,24,47,41,24,26,30,41)
B=c(42,33,16,39,38,36,15,33,20,43,34,22,7,15,34,29,41,13,38,25,27,41,28,14,28,40)
plot(A,B,main="Spatial data set:",xlab="A",
ylab="B")
model=lm(A~B)
plot(B,A)
abline(model)
coef(model)[2]
bootsample<-rep(NA,1000)
for( i in 1:1000){
replicate<-sample(1:26, replace=TRUE)
As=A[replicate]
Bs=B[replicate]
bootsample[i]<-coef(lm(As~Bs))[2]}
hist(bootsample, xlab="b*", main="Histogram of the bootstrap replicate estimation of b")
L1=sort(bootsample)[25]
U1=sort(bootsample)[975]
L1
U1