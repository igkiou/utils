function [U,S,V]=wsvd(D,W,K)
%Programmed by: Ben Marlin, marlin[at]cs[dot]toronto[dot]edu
%Description:   Weighted SVD EM algorithm implmentation from 
%               'Weighted Low-Rank Approximations' by Nathan 
%               Srebro and Tommi Jaakola, MIT.
%
%Inputs:        D - nxm data matrix
%               W - nxm weight matrix with 0<=Wij<=1
%               K - rank of approximation
%
%Outputs:       U,S,V such that D~USV'

X=zeros(size(D));
Xold=inf*ones(size(D));
Err=inf;

while(Err>eps)
  Xold=X;
  [U,S,V]=svd(W.*D + (1-W).*X);
  S(K+1:end,K+1:end)=0; 
  X=U*S*V';
  Err=sum(sum((X-Xold).^2));
end
