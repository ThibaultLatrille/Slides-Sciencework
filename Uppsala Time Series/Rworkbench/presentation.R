# TODO: Add comment
# 
# Author: Thibault
###############################################################################


eng_fiction=read.table(file="C:/Users/Thibault/Desktop/talk/Reng_fiction.txt", header=FALSE)

eng_us=read.table(file="C:/Users/Thibault/Desktop/talk/Reng_us.txt", header=FALSE)

eng_gb=read.table(file="C:/Users/Thibault/Desktop/talk/Reng_gb.txt", header=FALSE)

fre=read.table(file="C:/Users/Thibault/Desktop/talk/Rfre.txt", header=FALSE)

ita=read.table(file="C:/Users/Thibault/Desktop/talk/Rita.txt", header=FALSE)

#eng_fiction$V1<-filter(eng_fiction$V1,rep(1/5,5))
#eng_us$V1<-filter(eng_us$V1,rep(1/5,5))
#eng_gb$V1<-filter(eng_gb$V1,rep(1/5,5))
#fre$V1<-filter(fre$V1,rep(1/5,5))
#ita$V1<-filter(ita$V1,rep(1/5,5))

mts=ts(matrix(c(eng_us$V1,eng_gb$V1,fre$V1,ita$V1),length(fre$V1),4),start=1800,end=2009)

plot(mts,plot.type="single",col=1:4)
acf(mts)
spectrum(mts,span=c(20,20))
SBC=rep(0,6)
for (j in 1:10){
	SBC[j]=mAr.est(mts,j)$SBC
}
plot(SBC,type = "h", lwd = 2)
W=mAr.est(mts,2)
str(W)
W2<-mAr.est(mts,2)$resid
acf(W2)
