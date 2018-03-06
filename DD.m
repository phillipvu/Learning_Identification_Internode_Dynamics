
function [d]= DD(S,E,r,T,row)
d=(log(S/E)+(r+0.5*row*row)*T)/(row*sqrt(T));
return
