library(gsl)
n <- 10000
q <- qrng_alloc(type="sobol", 1)
MC <- function(x) (cos(50*x)+sin(20*x))**2
average <- mean(MC(qrng_get(q,n)))
print("sobol generator")
print(average)
average <- mean(MC(runif(n,0,1)))
print("runif generator")
print(average)
print(integrate(MC,0,1))
