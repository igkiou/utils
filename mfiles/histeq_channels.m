function J1 = histeq_channels(I1, I2, mask1, mask2, channels, isNorm, numSmoothIters, kernel)

if ((nargin < 3) || isempty(mask1)),
	mask1 = true([size(I1, 1), size(I1, 2)]);
end;

if ((nargin < 4) || isempty(mask2)),
	mask2 = true([size(I2, 1), size(I2, 2)]);
end;

if ((nargin < 5) || isempty(channels)),
	channels = 1:size(I1, 3);
end;

if ((nargin < 6) || isempty(isNorm)),
	isNorm = true;
end;

if ((nargin < 7) || isempty(numSmoothIters)),
	numSmoothIters = 0;
end;

if ((nargin < 8) || isempty(kernel)),
	kernel = [1 1 1 1 1] / 5;
end;

if (~isNorm),
	I1 = uint8(I1);
	I2 = uint8(I2);
end;
J1 = I1;
numChannels = length(channels);
for iterChan = 1:numChannels,
	I1temp = I1(:, :, channels(iterChan));
	I2temp = I2(:, :, channels(iterChan));
	J1temp = I1temp;
	J1temp(mask1) = histeq(I1temp(mask1), imhist(I2temp(mask2)));
	for iterSmooth = 1:numSmoothIters,
		temph = conv(imhist(J1temp(mask1)), kernel);
		J1temp(mask1) = histeq(J1temp(mask1), temph);
	end;
	J1(:, :, channels(iterChan)) = J1temp;
end;
if (~isNorm),
	J1 = double(J1);
end;
