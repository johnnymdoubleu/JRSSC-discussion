## FIT SUM-PARETO BROWN-RESNICK PROCESS

require(mvPot)



set.seed(1)

n <- 1000



# define semivariogram, locations (x), and simulate data (y)

svar <- function(x1_x2, theta = c(0.2, 1.8))
  
  (norm(x1_x2, type = "2") / theta[1])^theta[2]

x <- expand.grid(1:5, 1:2)

K <- dim(x)[1]

y <- simulPareto(n, x, svar)

sums <- sapply(y, sum)

exceedances <- y[sums > quantile(sums, 0.9)]



# negative log-likelihood

nllh <- function(theta) {
  
  aux <- function(x1_x2)
    
    svar(x1_x2, theta)
  
  # impose parametric constraints via penalization
  
  ifelse(theta[1] > 0 & theta[2] > 0 & theta[2] < 2,
         
         spectralLikelihood(exceedances, x, aux)[1],
         
         10^10)
  
}



optim(c(.5, .5), nllh, method = "BFGS")$par


# recall the true values are (0.2, 1.8)




missing.data <- y
n.locs = nrow(x)
for(i in 1:length(missing.data)){
  
  missing.data[[i]][1:8]=missing.data[[i]][1:8]*(rbinom(n.locs-2,1,prob=0.75))
  missing.data[[i]][missing.data[[i]]==0]=NA
}

means <- sapply(missing.data, mean,na.rm=T)

missing.exceedances <- missing.data[means > quantile(means, 0.9)]



nllh <- function(y,x,theta) {
  
  aux <- function(x1_x2)
    
    svar(x1_x2, theta)
  
  # impose parametric constraints via penalization
  
  ifelse(theta[1] > 0 & theta[2] > 0 & theta[2] < 2,
         
         spectralLikelihood(y, x, aux)[1],
         
         1e10)
  
}

theta0 = c(0.2, 1.8)

library(cubature)
library(Pareto)
Q=function(theta, theta.star, missing.exceedances, x){
  
  n.exceed=length(missing.exceedances)
  if(theta[1] <= 0 | theta[2] <= 0 | theta[2] >= 2) return(1e30)
  if(theta.star[1] <= 0 | theta.star[2] <= 0 | theta.star[2] >= 2) return(1e30)
  
  Q.out <-0
  
  sample=matrix(rPareto(8*5e2,1,1),ncol=8)-1
  for(i in 1:n.exceed){
    ind.miss=which(is.na(missing.exceedances[[i]]))
    obs.x=x[-ind.miss,]
   obs.y=missing.exceedances[[i]][-ind.miss]
    if(length(ind.miss)==0){
      Q.out=Q.out-nllh(list(missing.exceedances[[i]]),x,theta)
      print(i)
      print(-nllh(list(missing.exceedances[[i]]),x,theta))
    }else{
      
      
      integrand=function(input){
        y=missing.exceedances[[i]]
        y[ind.miss]=input
        out = -nllh(list(y),x,theta)*(exp(-nllh(list(y),x,theta.star)))
        if(any(input<=0)) return(0)
        return(out)
      }
     # integral = cubature::cubintegrate(integrand, lower=rep(0,length(ind.miss)), upper = rep(Inf,length(ind.miss)))$integral
    integral = mean(apply(as.matrix(sample[,1:length(ind.miss)]),1,integrand)/apply( as.matrix(sample[,1:length(ind.miss)]^{-2}-1),1,prod))

      
      Q.out = Q.out + (integral/exp(-nllh(list(obs.y),obs.x,theta.star)))
      print(i)
      print("missing")
      print((integral/exp(-nllh(list(obs.y),obs.x,theta.star))))
    
    }
  }

  return(-Q.out)
}

Q(theta0,theta.star,missing.exceedances,x)
theta.star=theta0
opt=optim(theta0,Q,theta.star=theta.star,missing.exceedances=missing.exceedances,x=x, method = "BFGS")
# theta.star=opt$par
# opt=optim(theta0,Q,theta.star=theta.star,missing.exceedances=missing.exceedances,x=x)



