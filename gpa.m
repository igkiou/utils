function [meanShape lossVal Z] = gpa(Y, orthFlag)

if ((nargin < 2) || isempty(orthFlag))
	orthFlag = 1;
end;

numLMarks = size(Y, 1);
numConfigs = size(Y, 2) / 2;
if (mod(numConfigs, 1) ~= 0),
	error('Second dimension of matrix Y must be a multiple of 2');
end;
Yc = zeros(numLMarks, numConfigs);
for iterConfig = 1:numConfigs
	Yc(:, iterConfig) = complex(Y(:, 2 * iterConfig - 1), Y(:,2 * iterConfig));
end;

Ym = Yc' * ones(numLMarks, 1) / numLMarks;
Yc = bsxfun(@minus, Yc, Ym');
Yc = bsxfun(@rdivide, Yc, sqrt(sum(abs(Yc) .^ 2)));
S = Yc * Yc';
[U , V] = svd(S);
meanShapec = U(:, 1);
meanShape = [real(meanShapec) imag(meanShapec)];
if (orthFlag == 1),
	Q = PCA(meanShape);
	meanShape = meanShape * Q;
end;

lossVal = numConfigs - V(1, 1);

if (nargout > 2),
	scales = Yc' * meanShapec;
	Yc = bsxfun(@times, Yc, scales.');
	Z = zeros(numLMarks, 2 * numConfigs);
	for iterConfig = 1:numConfigs
		Z(:, 2 * iterConfig - 1) = real(Yc(:, iterConfig));
		Z(:, 2 * iterConfig) = imag(Yc(:, iterConfig));
		if (orthFlag == 1),
			Z(:, [2 * iterConfig - 1, 2 * iterConfig]) = ...
				Z(:, [2 * iterConfig - 1, 2 * iterConfig]) * Q;
		end;
	end;
end;
