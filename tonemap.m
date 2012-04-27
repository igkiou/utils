function imOut = tonemap(imIn, percentage, gammaCorrection)
%TONEMAP Perform simple tone mapping
%
%   TONEMAP does a simple tonemapping to [0 1] by clipping intensity values
%   larger than the PERCENTAGE percentile and, if provided, doing gamma
%   correction by raising to the GAMMACORRECTION power, if it is a numeric,
%   or by calling the function specified by GAMMACORRECTION, if it is a
%   string. 
%
%   Example function to use for GAMMACORRECTON is SRGBCOMPANDING.

if ((nargin < 2) || isempty(percentage)),
	percentage = 100;
end;

if ((nargin < 3) || isempty(gammaCorrection)),
	gammaCorrection = 1;
end;

if (percentage < 100),
	val = prctile(vec(imIn), percentage);
	inds = imIn < val;
	imOut = zeros(size(imIn));
	imOut(inds) = imIn(inds);
	imOut(~inds) = val;
else
	imOut = imIn;
end;

if (ischar(gammaCorrection)),
	imOut = feval(gammaCorrection, imOut);
elseif (gammaCorrection ~= 1),
	imOut = imOut .^ gammaCorrection;
end;
