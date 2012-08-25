function [Dx, Dy] = gaussgradient(I, sigma, winsize)
% Filter image with derivative of Gaussian.
%
%	Inputs:
%		I			input image
%		sigma		standard deviation of Gaussian kernel (optiona, default
%					is 1.25)
%		winsize		length of window (optional, default is 5 * sigma)
%
%	Outputs:
%		Dx			horizontal derivative
%		Dy			vertical derivative
%

if (nargin <= 1)
	sigma = 1.25;
end;
if (nargin <= 2)
	winsize = 2 * floor(ceil(7 * sigma) / 2) + 1;
end;
[xx, yy] = meshgrid( - ( winsize - 1) / 2 : (winsize - 1) / 2,...
			- ( winsize - 1) / 2 : (winsize - 1) / 2);

Gx= - xx .* (1 / (sigma ^ 3)) .* exp(- (xx .^ 2 + yy .^ 2) / (2 * sigma ^ 2));
Gy= - yy .* (1 / (sigma ^ 3)) .* exp(- (xx .^ 2 + yy .^ 2) / (2 * sigma ^ 2));

Dx = conv2(I, Gx, 'same');
Dy = conv2(I, Gy, 'same');