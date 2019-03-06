library(VGAM)
B=3000
P=c(NA,B)

for (i in seq(1:B)){
x=rlaplace(40,0,1/sqrt(2))
P[i]<-shapiro.test(x)$p

}
ks.test(P, "punif")

M=c(NA,B)
M[i]<-shapiro.test(x)$statistic
plot(density(P,kernel="gaussian",bw="sj"))
plot(density(M,kernel="gaussian",bw="sj"))