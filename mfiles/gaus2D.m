% Create a 2D gauss function
%
% 22/02/06 G.E. NTUA

function F = gaus2D(s,n)

%***%an older script-function*****
% %n=32; %s=4;
% x = -1/2:1/(n-1):1/2;
% [Y,X] = meshgrid(x,x);
% f = exp( -(X.^2+Y.^2)/(2*s^2) );
% f = f / sum(f(:));
%*********************************

if nargin==1
    n = ceil(4*max(s)); %n = 6*s; 
end;

if numel(n)==1
    M = n; N = n;
else M = n(1); N = n(2);
end;

if numel(s)==1
    sx = s; sy = s;
else sy = s(1); sx = s(2);
end;

%[y,x] = meshgrid([-0.5:1/(M-1):0.5-1/(M-1)],[-0.5:1/(N-1):0.5-1/(N-1)]);
[y,x] = meshgrid((-0.5:1/(M-1):0.5),(-0.5:1/(N-1):0.5));
Y = y*M; X = x*N;
F = exp(-(X.^2/(2*sx^2)+Y.^2/(2*sy^2)));

F(F<eps*max(F(:))) = 0;

% Normalize for unity energy function

sumF = sum(F(:));          % unity L1 norm  
%sumF = sqrt(sum(F(:).^2)); % unity L2 norm
if sumF ~= 0,
  F  = F/sumF;
end;




