function [V L] = safeEig(M, noiseFlag)

if (nargin < 2)
	noiseFlag = 0;
end;

% find eigendecomposition
if (nargout == 1)
	lvec = eig(M);
else
	[V L] = eig(M);
	lvec = diag(L);
end;

% order eigenvalues and eigenvectors
[lvec indexes] = sort(lvec, 1, 'descend');

% remove very small eigenvalues
if (noiseFlag == 1),
	n = max(size(M));
	tol = n * eps(max(abs(lvec)));
	lvec(abs(lvec) < tol) = 0;
end;

if (nargout == 1)
	V = lvec;
else
	V = V(:,indexes);
	L = diag(lvec);
end
