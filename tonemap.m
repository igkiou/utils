function r1 = tonemap(r, percentage, gammaExp)

val = prctile(vec(r), percentage);
inds = r < val;
r1 = zeros(size(r));
r1(inds) = r(inds) / val;
r1(~inds) = 1;

if (nargin > 2),
	r1 = r1 .^ gammaExp;
end;
