function [A params] = EllipseFitCenter(XY, type)

if (nargin < 2),
	type = 'direct';
end;

if (strcmpi(type, 'direct')),
	params = EllipseDirectFit(XY);
elseif (strcmpi(type, 'taubin')),
	params = EllipseFitByTaubin(XY);
end;

% MATLAB: ax^2 + bxy + cy^2 +dx + ey + f = 0
% params = [a b c d e f]'
% Mathematica: ax^2 + 2bxy + cy^2 + 2dx + 2fy + g = 0;
a = params(1);
b = params(2) / 2;
c = params(3);
d = params(4) / 2;
f = params(5) / 2;
g = params(6);

A = zeros(2, 1);
A(1) = (c * d - b * f) / (b ^ 2 - a * c);
A(2) = (a * f - b * d) / (b ^ 2 - a * c);
