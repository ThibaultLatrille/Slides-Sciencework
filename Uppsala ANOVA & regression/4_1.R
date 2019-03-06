T <- data.frame(y1=c(68,74,65,60,63,70,58,60,57,55,69),
x1 = factor(c(1,0.5,-0.5,-1,-0.5,0.5,0,0,0,0,0)),
x2 = factor(c(0,sqrt(0.75),sqrt(0.75),0,-sqrt(0.75),-sqrt(0.75),0,0,0,0,0)) )
m1 <- lm(y1~x1 + x2 + I(x1^2) + I(x2^2) + x1*x2,T)
summary(m1)
m2 <- aov(y1~x1 + x2 + I(x1^2) + I(x2^2) + x1*x2,T)
summary(m2)

a <- m1$coeff
b <- rbind(a[2],a[3])
B <- cbind(c(a[4],a[6]/2),c(a[6]/2,a[5]))
xs <- -1/2*solve(B) %*% b

x1 <- seq(-1.2,1.2,0.1); x2 <- seq(-1.2,1.2,0.1)
model = function(x,y)
{
a[1] + a[2]*x + a[3]*y + a[4]*x^2 + a[5]*y^2 + a[6]*x*y
}
z <- outer(x1,x2,model)

par(mfrow=c(1,2))
# Perspective plot:
persp(x1,x2,z,theta=30,phi=30,ticktype="detailed") ->res
points(trans3d(xs[1],xs[2],model(xs[1],xs[2]), pmat = res), col = 2, lwd=3)
# Contour plot:
contour(x1,x2,z,nlevels=10); grid()
points(xs[1],xs[2],col=2,lwd=3)
library(rsm)
R=rsm(y1 ~ SO(x1, x2), data = T)
summary(R)

