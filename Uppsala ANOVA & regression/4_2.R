V <- data.frame(y=c(23,30,31,24,38,34,24,28,32,23,36,36,25,26,29,28,35,39,36,34,33,37,34,34,35,38,34,39,38,36,36,39,35,35,36,31,28,35,26,26,36,28,24,35,27,29,37,26,27,34,25,25,34,24),
ope = factor(c(rep(1:3,18))),
temp = factor(c(rep(c(rep(300,3),rep(350,3)),9))),
time = factor(c(rep(c(40,50,60),rep(18,3))))
)
model=aov(y~ope*temp*time,data=V)
library(car)
leveneTest(model)
shapiro.test(residuals(model))
anova(model)
mod=lm(y ~ ope + temp*time, data=V)
anova(mod)
leveneTest(mod)
shapiro.test(residuals(mod))