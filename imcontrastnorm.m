% imcontrastnorm.m Image Contrast Regularization (remove shading term) by convolving squared
%                  image with gaussian.
%
%             [J,C]=imcontrastnorm(I,N,s)
%
% J=imcontrastnorm(I), normalizes constrast of I, using a gaussian half the
% image length in spread.
%
% J=imcontrastnorm(I,N,s), uses a gaussian of size N with standard deviation s.


% 23/09/05 G.E. CVSP NTUA

function [J,C]=imcontrastnorm(I,varargin);

if nargin==1
    N=length(I)/4;
    s=(N-1+eps)/6;
elseif nargin==2
    N=varargin{1};
    s=(N-1+eps)/6;
    %N=ceil(3*s)*2+1;
elseif nargin==3
    N=varargin{1};
    s=varargin{2};
end;

g = fspecial('gaussian',N,s);

C=conv2(I.^2,g,'same');
%J=I-C;

%shading removal
J=I.*(1-(1./C));
% J=I./C;
