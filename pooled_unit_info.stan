// input data
data {
  int<lower=0> N; // number of observations
  int<lower=0> K; // number of regressors
  vector[N] log_y; // vector of dependent variable
  matrix[N, K] X; // matrix of all the regressors
  matrix[K, K] inv_XtX;
}


// define the parameters of the model
parameters {
  vector[K] beta;
  real<lower=0> sigma2;
}


// define transformed parameters
transformed parameters{
  real<lower=0> sigma;
  sigma = sqrt(sigma2);
}

model {

  // define the model specification
  log_y ~ normal(X*beta, sigma);
 
  // define the priors for the parameters
  {
    //assign local variables
    matrix[K, K] Omega;
    vector[K] mu_0; 
    mu_0 = rep_vector(0, K);
    Omega = N*sigma2*inv_XtX;
    
    beta ~ multi_normal(mu_0, Omega);
  }
  
  sigma2 ~ inv_gamma(0.01, 0.01);
}

generated quantities{
  vector[N] log_y_hat; //return fitted values
  vector[N]log_lik; // return log likelihood
  
  for (i in 1:N){
    log_lik[i] = normal_lpdf(log_y[i]|X[i]*beta, sigma);
  }
  
  for (i in 1:N){
    log_y_hat[i] = normal_rng(X[i]*beta, sigma);
  }
}

