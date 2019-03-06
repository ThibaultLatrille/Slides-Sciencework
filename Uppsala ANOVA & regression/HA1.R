ech=read.table("exo1.dat", col.names=c("A1","A2","A3"),fill = TRUE)
ech[,c(1,2)]=ech[,c(2,1)]
ech=stack(ech)
names(ech)=c("time","arrangement")
model=aov(time~arrangement,ech)
anova(model)
library(car)
leveneTest(model)
shapiro.test(residuals(model))
plot(model$fit, model$res, ylab="Residuals", xlab="Fitted values")
tukey=TukeyHSD(model,"arrangement")
tukey
#plot(tukey)
qqnorm(residuals(model));qqline(residuals(model))
