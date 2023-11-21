//input data
data {
  int<lower=0> N; // number of observations
  int<lower=0> K; // number of regressors
  vector[N] log_y; // vector of dependent variable
  matrix[N, K] X; // matrix of all the regressors
  
}

// define the parameters of the model
parameters {
  vector[K] beta;
  real<lower=0> sigma2;
  real<lower=0> lambda;
}

// define transformed parameters
transformed parameters{
  real<lower=0> sigma;
  sigma = sqrt(sigma2);
}

// define the model specification
model {
 
  // define model likelihood
  log_y ~ normal(X*beta, sigma);
 
  // define priors
  beta ~ normal(0, sigma/lambda);
  lambda ~ cauchy(0, 1);
  sigma2 ~ inv_gamma(0.01, 0.01);
}

// define other objects of interest
generated quantities {    
  vector[N] log_y_hat; //return fitted values
  vector[N]log_lik; // return log likelihood
 
  for (i in 1:N){
    log_lik[i] = normal_lpdf(log_y[i]|X[i]*beta, sigma);
  }
 
  for (i in 1:N){
    log_y_hat[i] = normal_rng(X[i]*beta, sigma);
  }
}

