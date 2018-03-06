%% set up parameters
% prior stuff for synthetic data
N = 4;
T = 400;
obs_dim = 2;
durparams = [20,50,70,0.9];
dur_hypparams = {2,3};
obs_hypparams = {zeros(obs_dim,1),eye(obs_dim),obs_dim+3,10};
alpha = 6;
gamma = 6;
rho = 6;

% inference
Nmax = 4; % weak limit approximation parameter
Niter = 30;
plot_results = 1;
plot_results_every = Niter;

%% create truth model
for state=1:N
    truth_obs_distns{state} = observations.gaussian(obs_hypparams{:});
    truth_dur_distns{state} = durations.poisson(dur_hypparams{:},durparams(state));
end

truthmodel = hsmm(T,truth_obs_distns,truth_dur_distns,alpha,gamma,rho);
parameter = truthmodel.states.dur_distns{1,1}.lmbda;
learned_parameter = zeros(1,Niter+1);
%% generate data from truth model
[data, labels] = truthmodel.generate();

if plot_results
    fig = figure();
    truthmodel.plot(data,fig);
    title('TRUTH');
end

%% create posterior model
for state=1:Nmax
    obs_distns{state} = observations.gaussian(obs_hypparams{:});
    dur_distns{state} = durations.poisson(dur_hypparams{:});
end

posteriormodel = hsmm(T,obs_distns,dur_distns,alpha,gamma,rho);
learned_parameter(1) = posteriormodel.states.dur_distns{1,1}.lmbda;
%% do posterior inference
if plot_results
    fig = figure();
end

for iter=1:Niter
    posteriormodel.resample(data);
    learned_parameter(iter+1) = posteriormodel.states.dur_distns{1,1}.lmbda;
    util.print_dot(iter,Niter);

   if plot_results && (mod(iter,plot_results_every) == 0)
       posteriormodel.plot(data,fig);
       title(sprintf('SAMPLED at iteration %d',iter));
       drawnow
   end
end
compare_plots

figure(4)
plot(1:Niter+1, parameter*ones(1,Niter+1),1:Niter+1,learned_parameter)


