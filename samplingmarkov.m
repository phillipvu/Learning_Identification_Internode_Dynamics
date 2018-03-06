
P=[0 0.3 0.7;0.4 0 0.6;0.5 0.5 0];
lengthChain=1000;
lambda=5;
channel1=1;




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

channel_new=downsample(channel,10);

idx1=length(find(channel_new==1));
idx2=length(find(channel_new==2));
idx3=length(find(channel_new==3));





q12 = zeros(1,lengthChain/4);
for i = 1:lengthChain/4
    if (channel(1,i)==1)&(channel(1,i+1)==2)
        q12(1,i)=i;
    end
end
for i = 1:lengthChain/4
    if (q12(i)==0)
        p12=i;
    end
end
q12=p12;



q21 = zeros(1,lengthChain/4);
for i = 1:lengthChain/4
    if (channel(1,i)==2)&(channel(1,i+1)==1)
        q21(1,i)=i;
    end
end
for i = 1:lengthChain/4
    if (q21(i)==0)
        p21=i;
    end
end
q21=p21;

q31 = zeros(1,lengthChain/4);
for i = 1:lengthChain/4
    if (channel(1,i)==3)&(channel(1,i+1)==1)
        q31(1,i)=i;
    end
end
for i = 1:lengthChain/4
    if (q31(i)==0)
        p31=i;
    end
end
q31=p31;



% 
% q21 = zeros(1,lengthChain/4);
% for i = 1:lengthChain/4
%     if (channel(1,i)==2)&(channel(1,i+1)==1)
%         q21(1,i)=i;
% %     end
% % end
% % q23 = zeros(1,lengthChain/4);
% % for i = 1:lengthChain/4
% %     if (channel(1,i)==2)&(channel(1,i+1)==3)
% %         q23(1,i)=i;
% %     end
% % end
% q31 = zeros(1,lengthChain/4);
% for i = 1:lengthChain/4
%     if (channel(1,i)==3)&(channel(1,i+1)==1)
%         q31(1,i)=i;
%     end
% end
% q32 = zeros(1,lengthChain/4);
% for i = 1:lengthChain/4
%     if (channel(1,i)==3)&(channel(1,i+1)==2)
%         q32(1,i)=i;
%     end
% end

p12=q12/idx1;
% p13=length(q13)/idx1;
p21=q21/idx2;
% p23=length(q23)/idx2;
p31=q31/idx3;
% p32=length(q32)/idx3;

pi=P^2000;
pi=pi(1,:)

P_new=[0 p12 1-p12;p21 0 1-p21;p31 1-p31 0]

pi_new=[idx1/250 idx2/250 idx3/250]


% figure(1);
% plot(channel);

figure(2);
plot(channel_new);





