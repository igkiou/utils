function f=gaus1D(s,n);
%n=32;
%s=4;
if nargin==1
    n = ceil(4*max(s)); %n = 6*s; 
end;

X = -1/2:1/(n-1):1/2;
f = exp( -(X.^2)/(2*s^2) );
f = f / sum(f(:));
