convolveSlow <- function(x, y) {  
nx <- length(x); ny <- length(y)  
xy <- numeric(nx + ny - 1)  
for(i in seq(length = nx)) {  
 xi <- x[[i]]  
        for(j in seq(length = ny)) {  
            ij <- i+j-1  
            xy[[ij]] <- xy[[ij]] + xi * y[[j]]  
        }  
    }  
    xy  
}  

convolveFast <- function(x, y) {
nx <- length(x); ny <- length(y)  
xy <- numeric(nx + ny - 1)  
for(k in seq(length = nx)) {  
 r[k]=
}

convolveveryFast <- function(x, y) {
xy <- convolve(x,y)
xy
}

measure.time <- function(fun1, fun2, ...){
    ptm <- proc.time()
    x1 <- fun1(...)
    time1 <- proc.time() - ptm

    ptm <- proc.time()
    x2 <- fun2(...)
    time2 <- proc.time() - ptm

    #ident <- all(x1==x2)

    cat("Function 1\n")
    cat(time1)
    cat("\n\nFunction 2\n")
    cat(time2)
    #if(ident) cat("\n\nFunctions return identical results")

}

x <- runif(1000)
y <- runif(1000)
measure.time(convolveSlow, convolveveryFast, x, y)


