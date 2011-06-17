function Y = posterize(X, N, bounds)
%
% POSTERIZE   Reduces number of colors in an image.
%
%    Y = POSTERIZE(X,N) creates the image Y by reduncing the number
%    of different colors of X to N. The N color values of Y are evenly
%    spaced in the same range as the values of X, however Y has only N 
%    different values. The values of X are rounded to the closet allowed
%    values of Y.
%    
%    Y = POSTERIZE(X,N,[MIN MAX]) scales the N allowed values of Y so 
%    that they have the new [MIN MAX] range.
%
%    Y = POSTERIZE(X,N,'noint') allows non integer values on Y. By default,
%    the allowed values of Y are rounded to the closest integer so that they
%    are evenly spaced. If using the 'noint' parameter this rounding is not
%    performed.
%
%    Y = POSTERIZE(X,N,'img') uses [MIN MAX] = [0 255], do not allow non
%    integer values on Y and returns Y as UINT8.
%
%    Y = POSTERIZE(x) uses N=64 and the 'img' parameter.
%

if (nargin < 2),
	N = 10;
end;

mX = min(X(:));
MX = max(X(:));

step = (MX - mX) / (N - 1);

Y = floor((X - mX) / step) * step + mX;
% Y = floor((X - mX) / step);

if ((nargin > 2) && (~isempty(bounds))),
	Y = imnorm(Y, bounds);
end;
