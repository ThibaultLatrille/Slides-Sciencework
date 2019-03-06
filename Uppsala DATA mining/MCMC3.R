a=2.7
b=6.3
n <- 10000
ratio <- function(rand,seed,a,b) return((rand**(a-1)*(1-rand)**(b-1))/(seed**(a-1)*(1-seed)**(b-1)))
MCMC<-function(a,seed,N){
 rand<-rep(NA,N);
 rand[1]<-seed;
 for(i in 2:N) {
  rand[i]<-runif(1);
  r<-min(1,ratio(rand[i],seed,a,b))
  print(r)
  if (runif(1)<r) {seed<-rand[i]}
  else{rand[i]<-seed}
  };
 return(rand)}
rand<-MCMC(0.1,0.1,n)
print(rand)