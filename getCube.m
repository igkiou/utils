function cube = getCube(name, wavelengthInds)

if (nargin < 2),
	wavelengthInds = 420:10:720;
end;
numWavelength = length(wavelengthInds);
I = imread(sprintf('%s_%d.tif', name, wavelengthInds(1)));
[M N K] = size(I);
cube = zeros(M, N, numWavelength);

for iter = 1:numWavelength,
	I = imread(sprintf('%s_%d.tif', name, wavelengthInds(iter)));
	I = double(I);
	cube(:, :, iter) = I(:, :, 1);
end;
