function [SS]= find_SS(S,E,r,T,row,q_a)
SS=E/4;
LS=0;
RS=2*E;
prec=0.00001;
while (abs (LS-RS)/E)>prec    
    d1=DD(SS,E,r,T,row);
    Nd1=normcdf(-d1,0,1);
    cd = cdf('Normal',-d1,0,1);           
    b=Nd1*exp(-0*T)*(1/q_a-1)-(1+exp(-0*T)*cd/(row*sqrt(T)))/q_a;   % 1-exp(-rT)
    RS=RHS(SS,E,r,T,row,q_a);
    LS=E-SS;
	NS=(E-RS+b*SS)/(1+b);
    SS=NS;
end
return