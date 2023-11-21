library('bayesplot', 'ggplot2')

extract.pooled.fit <- extract(pooled.fit)
extract.unit.info.pooled.fit <- extract(unit.info.pooled.fit)

set.seed(SEED)
random.indices <- sample(1:4000, 100)
pooled.fitted.density <-ppc_dens_overlay(y = df$logPrice,
                                         yrep = extract.pooled.fit$log_y_hat[random.indices,]) +
                                         ggtitle("Log-price Distribution with Pooled Model Fitted Values") +
                                         xlab("Log of Price") +
                                         ylab("probability density") +
                                         legend_move(c(0.85, 0.5)) 


unit.info.pooled.fitted.density <-ppc_dens_overlay(y = df$logPrice,
                                         yrep = extract.unit.info.pooled.fit$log_y_hat[random.indices,]) +
                                         ggtitle("Log-price Distribution with Pooled Model Fitted Values") +
                                         xlab("Log of Price") +
                                         ylab("probability density") +
                                         legend_move(c(0.85, 0.5)) 

param.names <- names(pooled.fit)[1:51]
interval.plot1 <- mcmc_intervals(pooled.fit, 
                                pars = param.names,
                                point_est = "mean",
                                prob = 0.9,
                                prob_outer = 0.95)

y.labels <- colnames(pooled.X)

interval.plot1 + scale_y_discrete(labels = y.labels)

interval.plot2 <- mcmc_intervals(unit.info.pooled.fit, 
                                 pars = param.names,
                                 point_est = "mean",
                                 prob = 0.9,
                                 prob_outer = 0.95)


extract.unit.info.pooled.fit <- extract(unit.info.pooled.fit)



ppc_dens_overlay(y = df$logPrice,
                 yrep = extract.unit.info.pooled.fit$log_y_hat[1:100,],
                 probs = 0.8)
