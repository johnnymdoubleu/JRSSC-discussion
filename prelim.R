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