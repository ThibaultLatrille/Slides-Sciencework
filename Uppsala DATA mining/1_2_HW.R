HW<-function(input,theta1,theta2)
{	n <- length(input)
	output <- rep("", n)
	cdfSS <- theta1^2
	cdfII <- cdfSS+theta2^2
	cdfFF <- cdfII+(1-theta1-theta2)^2
	cdfSI <- cdfFF+2*theta1*theta2
	cdfSF <- cdfSI+2*theta1*(1-theta1-theta2)
	for(i in seq(n))
	{ if (input[i]<cdfSS) {output[i]="SS"
	  } else if (cdfSS<input[i] & input[i]<cdfII) {output[i]="II"
	  } else if (cdfII<input[i] & input[i]<cdfFF) {output[i]="FF"
	  }else if (cdfFF<input[i] & input[i]<cdfSI) {output[i]="SI"
	  }else if (cdfSI<input[i] & input[i]<cdfSF) {output[i]="SF"
	  }else {output[i]="IF"
	  }
	};
	return(output)
}
chisquaredtestHW<-function(theta1,theta2,data)
{	pSS <- theta1^2
	pII <- theta2^2
	pFF <- (1-theta1-theta2)^2
	pSI <- 2*theta1*theta2
	pSF <- 2*theta1*(1-theta1-theta2)
	pIF <- 2*theta2*(1-theta1-theta2)
	nSS <- length(data[data=="SS"])
	nII <- length(data[data=="II"])
	nFF <- length(data[data=="FF"])
	nSI <- length(data[data=="SI"])
	nSF <- length(data[data=="SF"])
	nIF <- length(data[data=="IF"])
	n <- nSS+nII+nFF+nSI+nSF+nIF
	print(n)
	chiobs <- (nSS-n*pSS)^2/(n*pSS)+(nII-n*pII)^2/(n*pII)+(nFF-n*pFF)^2/(n*pFF)+(nSI-n*pSI)^2/(n*pSI)+(nSF-n*pSF)^2/(n*pSF)+(nIF-n*pIF)^2/(n*pIF)
	print(c(nSS,nII,nFF,nSI,nSF,nIF))
	print(c(n*pSS,n*pII,n*pFF,n*pSI,n*pSF,n*pIF))
	return(chiobs)
}
n <- 100
test=0
uniform=runif(n)
y <- HW(uniform,1/3,1/3)
print(y)
test <- chisquaredtestHW(1/3,1/3,y)
pvalue <- 1-pchisq(test,5)
print(pvalue)