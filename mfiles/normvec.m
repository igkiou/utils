function Y = normvec(X)

normX = norm(vec(X), 'fro');
if (normX == 0),
	Y = X;
else
	Y = X / normX;
end;
