%IMNORM    Normalize Gray Scale Image
%
%	IMNORM(I) shifts and scales the input gray image I so that its gray
%	levels are covering the range [0,1]. 
%
%	IMNORM(I,[MIN,MAX]) shifts and scales the input gray image I so that its gray levels
%	are covering the range [MIN,MAX]. 
%
%	imshow(I,[])  is the same with J=imnorm(I); imshow(J) 

% 10/10/03 G.E. NTUA

function J = mapcols(I, bounds)

if (nargin < 1),
	error('Not enough input arguments.');
elseif (nargin == 1),
	mi=min(I, [], 1);
	ma=max(I, [], 1);
	J = zeros(size(I));
	inds = ((ma == mi) & (mi ~= 0));
	J(:, inds) = 1;
	inds = ~inds;
	J(:, inds) = (I(:, inds) - repmat(mi(inds), [size(I, 1), 1])) ./ repmat(ma(inds) - mi(inds), [size(I, 1), 1]);
elseif (nargin == 2),
	if (length(bounds) ~= 2),
		error('BOUNDS must be a vector of length 2');
	end;
	mi=min(I, [], 1);
	ma=max(I, [], 1);
	J = zeros(size(I));
	inds = ((ma == mi) & (mi ~= 0));
	J(:, inds) = bounds(2);
	inds = ~inds;
	J(:, inds) = (bounds(2) - bounds(1)) * I(:, inds) ./ repmat(ma(inds) - mi(inds), [size(I, 1), 1])...
		+ repmat(bounds(1) * ma(inds) - bounds(2) * mi(inds), [size(I, 1), 1]) ./ repmat(ma(inds) - mi(inds), [size(I, 1), 1]);
end;
