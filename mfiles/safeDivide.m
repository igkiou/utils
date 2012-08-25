function quotient = safeDivide(divident, divisor, setZero)

if (nargin < 3),
	setZero = 1;
end;

quotient = divident ./ divisor;
quotient(divisor == 0) = setZero;
