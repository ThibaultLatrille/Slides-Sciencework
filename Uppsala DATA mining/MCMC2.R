quan=qnorm(c(0.5,0.75,0.8,0.9,0.95,0.99,0.999,0.9999))
M=matrix(0,7,8)
for (i in 1:7) {
 for (j in 1:8) {
  n=10*(i+2)
  vector <- rnorm(n,0,1)
  t=quan[j]
  M[i,j]=length(vector[vector<t])/n
 }
}
print(M)