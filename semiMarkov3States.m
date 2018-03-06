
%% An example showing a generation of 3 states semi Markov process
%% PHUOC VU
function [channel,timeState] = semiMarkov3States(lengthChain,P,lambda,channel1)
channel = zeros(1,lengthChain); % 3-state Markov chain (output vector).
timeState = zeros(1,lengthChain); % Vector of time in each state
timeState1= zeros(1,lengthChain); % Auxiliary vector of time
channel(1,1) = channel1; % First sample of the process
P1 = cumsum(P,2); % P’3chan

for i = 2:lengthChain
eventP = randint(1,1,[1 100])/100;%Event to decide the switch

if channel(1,i-1) == 1
%If former sample was channel 1
    if eventP < P1(1,2)
        channel(1,i) = 2;%Switch to channel 2
    else
        channel(1,i) = 3;%Switch to channel 3
    end
    
    elseif channel(1,i-1) == 2%If former sample was channel 2
        if eventP < P1(2,1)
            channel(1,i) = 1;%Switch to channel 1
        else
            channel(1,i) = 3;%Switch to channel 3
        end

    elseif channel(1,i-1) == 3
        if eventP < P1(3,1)
            channel(1,i) = 1;
        else
            channel(1,i) = 2;
    end; end; end
%If former sample was channel 3
%Switch to channel 1
%Switch to channel 2
% Sojourn time


for i = 1:lengthChain
%eventW = randint(1,1,[1 100])/100;
%Event to decide the sojourn time
if channel(i) == 1
timeState1(1,i) = poissrnd(lambda) ;
%Sojourn time when Channel 1 appears
elseif channel(i) == 2
timeState1(1,i) = poissrnd(lambda) ;
%Sojourn time when Channel 2 appears
else
timeState1(1,i) = poissrnd(lambda) ;
%Sojourn time when Channel 3 appears
end; end
timeState = cumsum(timeState1);
%Sojourn time for each element of the created chain
timeState1;




