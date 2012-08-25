function reciprocal = safeReciprocal(number, setZero)

if (nargin < 2),
	setZero = 1;
end;

reciprocal = 1 ./ number;
reciprocal(number == 0) = setZero;
