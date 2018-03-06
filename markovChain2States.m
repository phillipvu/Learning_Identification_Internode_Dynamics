function [channel] = markovChain2States(P,lengthChain)
channel = zeros(1,lengthChain);
% 2-state Markov chain (output vector)
channel(1) = randint(1,1,[1 2]);
% Step a)
for i = 2:lengthChain
event = randint(1,1,[1 100])/100;
if channel(1,i-1) == 1
if event <= P(1,2)
channel(1,i) = 2;
else
channel(1,i) = 1;
end
elseif channel(1,i-1) == 2
if event <= P(2,1)
channel(1,i) = 1;
else
channel(1,i) = 2;
end; end; end
