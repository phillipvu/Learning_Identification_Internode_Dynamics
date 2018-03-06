function [mu, lmbda] = sample_niw(mu_0,lmbda_0,nu_0,kappa_0)
   lmbda = iwishrnd(lmbda_0,nu_0);
   mu = cholcov(lmbda/kappa_0)*(randn(size(lmbda_0,1),1))+mu_0;