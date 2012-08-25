% IMBLOCKS  Image from Blocks 
%
%    IMBLOCKS(M,N,m,n) creates a(n) matrix (image) of size M x N from a grid of indexed blocks
%    of size m x n. Block indexes are from 1 to (M*N)/(m*n).
%
% 30/09/2004 G.E. CVSP NTUA

function X=imblocks(M,N,m,n);

X=zeros(M,N);
G=[1:1:(N*M)/(n*m)];
t=1;
for i=1:m:M
    for j=1:n:N
        X(i:i+m-1,j:j+n-1)=G(t)*ones(m,n); 
        t=t+1;
    end
end;