frame=data.frame(values=c(as.matrix(read.table("3_1.dat"))),car=factor(c(rep(c(1:5),5))),additive=factor(c(rep(c(1:5),rep(5,5)))))
model=aov(values ~ car + additive, data=frame)
anova(model)
par(mfrow=c(2,1))
#
tukey=TukeyHSD(model,"additive")
tukey
plot(tukey)
tukey=TukeyHSD(model,"car")
tukey
plot(tukey)
library(car)
leveneTest(model)
shapiro.test(residuals(model))
#qqnorm(residuals(model))
#qqline(residuals(model))
#interaction.plot(additive,car,values, xlab="additive", ylab="Yield")