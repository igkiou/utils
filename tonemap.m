function imOut = tonemap(imIn, percentage, gammaCorrection)
%TONEMAP Perform simple tone mapping
%
%   TONEMAP does a simple tonemapping to [0 1] by clipping intensity values
%   larger than the PERCENTAGE percentile and, if provided, doing gamma
%   correction by raising to the GAMMACORRECTION power, if it is a numeric,
%   or by calling the function specified by GAMMACORRECTION, if it is a
%   string. 

val = prctile(vec(imIn), percentage);
inds = imIn < val;
imOut = zeros(size(imIn));
imOut(inds) = imIn(inds) / val;
imOut(~inds) = 1;
% imOut(inds) = imIn(inds);
% imOut(~inds) = val;

if (nargin > 2),
	if (ischar(gammaCorrection)),
		imOut = feval(gammaCorrection, imOut);
	else
		imOut = imOut .^ gammaCorrection;
	end;
end;
