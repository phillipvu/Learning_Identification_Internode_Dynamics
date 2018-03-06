
function RS = RHS(S,E,r,T,row,q_a)
[cc,pp] = blsprice(S,E,r,T,row);
d1=DD(S,E,r,T,row);
ND1=normcdf(-d1,0,1);
RS=pp-(1-exp(-0*T)*ND1)*S/q_a;
return