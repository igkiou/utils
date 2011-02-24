function res=cardinal(vec,eps)
% Computes cardinality of vec up to eps relative precision
mx=max(abs(vec));
res=sum(abs(vec)>eps*mx);