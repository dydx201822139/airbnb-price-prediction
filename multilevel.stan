// input data
data {
  int<lower=0> N; // number of observations
  int<lower=0> K_1; // number of level 1 explanatory variables
  int<lower=0> H; // number of groups in host-level/level 2  

  vector[N] log_y; // vector of dependent variable
  matrix[N, K_1] X; // matrix of the level 1 explanatory variables

  int<lower=1, upper=H> host[N]; // index by host/level 2 group

}

// define the parameters of the model
parameters {
  // level 1 parameters
  vector[K_1] Beta_std[H]; // 2d array of coefficeints to be transformed
  real<lower=0, upper=pi()/2> sigma_unif;

  // level 2 parameters
  vector[K_1] mu_1;
  vector<lower=0, upper=pi()/2>[K_1] omega_unif;
}

transformed parameters{
  real<lower=0> sigma; // level 1 standard deviation
  vector[K_1] Beta[H]; // 2d array of coefficients grouped by level 2 groups
  vector<lower=0>[K_1] omega; // level 2 standard deviation
 
 
  //reparameterisations
  sigma = tan(sigma_unif);  
  omega = tan(omega_unif);

  for (i in 1:H){
    for (j in 1:K_1){
      Beta[i][j] = mu_1[j] + omega[j] * Beta_std[i][j];
    }
  }

}


// define the model specification
model {  
 
  //define likelihood/level 1 specification
  {
    vector[N] X_Beta; //local variable
    for (i in 1:N){
      X_Beta[i] = X[i] * Beta[host[i]];
      }
    log_y ~ normal(X_Beta, sigma);
  }

 
  // define host/level 2 specification
 
 
  for (i in 1:H){
    for (j in 1:K_1){
      Beta_std[i][j] ~ std_normal();
    }
  }
 
  // define priors
 
 
  //sigma_unif is implicitly uniform[0, pi/2]
  //hence sigma is half-cauchy(0, 5) post-transformation
 
  //after transformation mu_1 is normal(0, 10)
  mu_1 ~ normal(0, 10);

  //omega_unif is implicitly uniform[0, pi/2]
  //hence omega is half-cauchy(0, 5) post-transformation

 
}

// define other objects of interest
generated quantities{
  vector[N] log_lik;  // return log likelihood
  vector[N] log_y_hat;  //return fitted values

  for (i in 1:N){
    log_lik[i] = normal_lpdf(log_y[i] | X[i] * Beta[host[i]], sigma);
  }
 
  for (i in 1:N){
    log_y_hat[i] = normal_rng(X[i] * Beta[host[i]], sigma);
  }
}



