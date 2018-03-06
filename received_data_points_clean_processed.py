%%% read in data points from USRP traces
Fs = 1e6; % USRP sampling frequency
M = 500; % downsampling factor
infile = 'three_user_interference12'; % name of USRP trace file to be read in
data = read_complex_binary(infile)';    % reads in trace binary data
%data = data(1.5e6:end);                 % truncate to remove USRP turn-on
                                        % transient
data = downsample(data,M);              

T = length(data);   % length of data set
Fs1 = Fs/M;         % sampling frequency after downsampling
Ts1 = 1/Fs1;        % sampling period after downsampling

% NOTE: THE I/Q DATA IS NORMALIZED PER COMPONENT!!!!
data_abs = abs(data); % get magnitude of each complex data point in trace
data = [real(data)/max(real(data));imag(data)/max(imag(data))];
    % store the I (real part) & Q (imaginary part) signals in different rows

%% set up maximal number of possible states and the number of iterations
Nmax = 4; % weak limit approximation parameter 
Niter = 75; % number of iterations for first stage
plot_results = 1;   % allow plotting 
plot_results_every = Niter;    % only plot results after last iteration

%% set up parameters and hyperparameters for state durations and observations

    % creates an output file to save the final results in text format
file_name = strcat(infile,'_unreduced_model.dat');
outfile = fopen(file_name,'w');


T = length(data);   % data set length 
obs_dim = 2; % dimension of observations

%%% THE REMAINDER OF THIS CELL NEEDS TO BE MODIFIED ANYTIME YOU WANT TO 
%%% ASSIGN DIFFERENT INITIAL DRAW HYPERPARAMETERS AMONGST THE DIFFERENT 
%%% STATES!!!!!
num_hypparam_types = 4; % # of different classes of states,
                        % each with different hyperparameters

% variable used to  denote what states belong to each class (not used in computations,
% just for record keeping)
% Ex.: Suppose Nmax = 3. If the priors for the first two states are the same but
% different for the third state, hypparam_map = [1, 1, 2] with each entry denoting
% "class membership".
hypparam_map = 1:4;
if length(hypparam_map) ~= Nmax
    error('The hyperparameter assignment mapping is not equal to the max. number of states.');
end

% dur_hypparams ~ Poisson{k,theta}
% obs_hypparams ~ NIW(mu_0,sigma_0,nu_0,kappa_0)

dur_hypparams1 = {100,5};
dur_hypparams2 = {20,9};
dur_hypparams3 = {17,10};
dur_hypparams4 = {50,9}; 
obs_hypparams1 = {zeros(obs_dim,1),eye(obs_dim),obs_dim+3,10}; 
obs_hypparams2 = {0.03*ones(obs_dim,1),eye(obs_dim),obs_dim+6,5}; 
obs_hypparams3 = {0.035*ones(obs_dim,1),eye(obs_dim),obs_dim+9,5}; 
obs_hypparams4 = {0.01*ones(obs_dim,1),eye(obs_dim),obs_dim+15,7}; 


dirichlet_hypparams = [3,3,3]; % [alpha, gamma, rho]

    % used to aid printout of hyperparameters to summary text file
for i = 1:num_hypparam_types
    vstring = strcat('dur_hypparams',int2str(i));
    posterior_hyperparameters{1,i} = eval(vstring);
    vstring = strcat('obs_hypparams',int2str(i));
    posterior_hyperparameters{2,i} = eval(vstring);
end
posterior_hyperparameters{3,1} = dirichlet_hypparams;
clear vstring
posterior_header_printout(outfile,infile,Fs,Fs1,Ts1,T,obs_dim,posterior_hyperparameters,hypparam_map,Nmax,Niter);

%% create posterior model
for state = 1:Nmax
    dur_distns{state} = durations.poisson(posterior_hyperparameters{1,hypparam_map(state)}{:});
    obs_distns{state} = observations.gaussian(posterior_hyperparameters{2,hypparam_map(state)}{:}); 
end

posteriormodel = hsmm(T,obs_distns,dur_distns,dirichlet_hypparams,T+1); 
initial_draw_printout(outfile,posteriormodel,Nmax,obs_dim);

%% do posterior inference (resample the data at each iteration)
if plot_results
    fig1 = figure(1);
end

for iter=1:Niter
    posteriormodel.resample(data); % hsmm.resample()
    util.print_dot(iter,Niter);

   if plot_results && (mod(iter,plot_results_every) == 0)
       posteriormodel.plot(data,data_abs,fig1); % hsmm.plot()
       title(sprintf('SAMPLED at iteration %d',iter));
       drawnow
   end
end

states_printout(outfile,posteriormodel,obs_dim);
%% post-processing of results
    
    % remove all states with duration mean parameter less than dur_limit;
    % get new transition matrices and state sequences accordingly
dur_limit = 5;
[transition_matrix,full_transition_matrix,new_stateseq,new_stateseq_norep,new_durs] = remove_states(posteriormodel, data, dur_limit);
posteriormodel.states.stateseq = new_stateseq;
posteriormodel.states.stateseq_norep = new_stateseq_norep;
posteriormodel.states.durations = new_durs;
posteriormodel.plot(data,data_abs,fig1); % hsmm.plot()
title(sprintf('SAMPLED at iteration %d',iter));
drawnow

    % identify the idle state through power calculations from the labeling
posterior_idle_state = identify_idle_state(posteriormodel,data_abs);

fprintf(outfile,'State %d is the Idle State\n\n',posterior_idle_state);

L = size(transition_matrix,1);

new_state_idx = unique(posteriormodel.states.stateseq_norep);
fprintf(outfile,'Reduced State Transition Matrix\n');
for i = 1:L
    fprintf(outfile,'State %d\t\t',new_state_idx(i));
    for j = 1:L
        fprintf(outfile,'%f\t', transition_matrix(i,j));
    end
    fprintf(outfile,'\n');
end
fclose(outfile);
%% save results to MATLAB workspace and continue to second stage
unreduced_save_file = strcat(infile,'_unreduced.mat');
save(unreduced_save_file)
reduced_model_inference