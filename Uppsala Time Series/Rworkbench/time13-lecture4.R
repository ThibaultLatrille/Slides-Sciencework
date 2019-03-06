### Lecture 4 #####
## save data ####
### Example taken from www.ma.slu.se ### Vindbro #########
###### Remove first line, replace commas by points ##############

tmpA <- read.table(file="C:/Users/Silvelyn/Documents/texarbeiten/Vorlesungen/Timeseries/time-13/vindbroA.txt", header=FALSE)
str(tmpA)
#help(read.table)
temp<-tmpA$V9
#help(ts)
t.temp<-ts(temp, start=1991,end=2012, frequency=12)
plot(t.temp,main="Vinbro, Temperature in Celsius",lwd=2,col=4)
str(t.temp)

#help(write)
write(t.temp,file="C:/Users/Silvelyn/Documents/texarbeiten/Vorlesungen/Timeseries/time-13/vind.dat")
vind<-scan(t.temp,file="C:/Users/Silvelyn/Documents/texarbeiten/Vorlesungen/Timeseries/time-13/vind.dat")
str(vind)


f<-c(1/24,1/12,1/12,1/12,1/12,1/12,1/12,1/12,1/12,1/12,1/12,1/12,1/24)
sum(f)
m<-filter(t.temp,f)
lines(m,col=2,lwd=2)
detrend<-t.temp-m
str(detrend)
plot(detrend, main="vindbro - detrended",lwd=2)
#### Deseasonalize  with Method 2 ########
T1<-t.temp
TT2<-T1-lag(T1,12)
plot(TT2)
help(lag)
#### stl - Loess Method #########
help(stl)
x11()
plot(stl(T1,"per"))## periodic the same season every year##
plot(stl(T1,s.window=5,t.window=20))## local polynomial, windows###
x11()
plot(stl(T1,"per",t.window=30))
x11()
plot(stl(T1,"per",t.window=50))

Temp<-stl(T1,"per",t.window=30)
str(Temp)
Temp.trend<-Temp$time.series[,2] #### trend #####
Temp.trend
plot.ts(Temp.trend, main="Trend for vindbro temperature data",lwd=2)
########## test of the residuals ###########
rest<-as.numeric(Temp$time.series[,3])
plot(rest)
plot.ts(rest)
acf(rest)
hist(rest)
shapiro.test(rest)
qqnorm(rest)
hist(rest)
mean(rest)
median(rest)
ks.test(rest,"pnorm")
## autoregressiv ? #####
n<-length(rest)
z<-rep(0,n-1)
for (j in 1:n-1){z[j]<-rest[j+1]}
rest1<-rest[1:n-1]
plot(z,rest1, pch=21,lwd=2)
M2<-lm(rest1~z)
lines(z,M2$fitted,col=2,lwd=2) 
summary(M2) ###### no autoregressive relation #####
### analyse the trend ####
Temp.trend
length(Temp.trend)
tt<-seq(1,253,1)
tt
length(tt)
Tn<-as.numeric(Temp.trend)
length(Tn)
plot(tt,Tn,"l", main="Estimated trend of vindbro temperature data")
M3<-lm(Tn~tt)
abline(M3,col=2,lwd=2)
summary(M3)
#### 

