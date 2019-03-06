Y <- data.frame(y=c(23.46,23.59,23.51,23.28,23.29,23.48,23.46,23.64,23.40,23.46,23.56,23.42,23.46,23.37,23.37,23.39,23.49,23.52,23.46,23.32,23.47,23.50,23.49,23.39,23.38),
batch = factor(rep(1:5,5))
)
obj1=aov(y ~ Error(batch), data=Y)
summary(obj1)
SS.batch <- sum(residuals(obj1$batch)^2)
df.batch <- (obj1$batch)$df.residual
MS.batch <- SS.batch/df.batch
SS.error <- sum(residuals(obj1$Within)^2)
df.error <- (obj1$Within)$df.residual
MS.error <- SS.error/df.error
F.statistic <- MS.batch/MS.error
p.value <- 1-pf(F.statistic, df.batch, df.error)
printTable<-function()
{
cat("Source\tSS\tdf\tMS\tF\tp-value\n")
cat("Batch", round(SS.batch,2), df.batch, round(MS.batch,2), round(F.statistic,2),
p.value, "\n", sep="\t")
cat("Error", round(SS.error,2), df.error, round(MS.error,2), "\n", sep="\t")
}
par(mfrow=c(1,1))
printTable()
sigma=(MS.batch-MS.error)/5
sigma
sigma/(sigma+MS.error)
library(car)
leveneTest(obj1)
shapiro.test(residuals(obj1))
library(nlme)
m1 <- lme(fixed = y ~1, random = ~1|batch, data=Y)
summary(m1)
leveneTest(m1)
shapiro.test(residuals(m1))
plot(m1$fit, m1$res, ylab="Residuals", xlab="Fitted values")
L=(MS.batch/(MS.error*3.51)-1)/5
U=(MS.batch*8.56/MS.error-1)/5
l=L/(1+L)
l
u=U/(1+U)
u
