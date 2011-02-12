function saliencyMap = fix2map(fixVector, M, N, fixWeights)

if (nargin == 3),
	fixWeights = ones(1, size(fixVector, 1));
end;
saliencyMap = zeros([M N]);
Gsize = round(min([M N] / 6));
Gsigma = 0.3 * Gsize;
G = fspecial('gaussian', Gsize, Gsigma); 
numFix = size(fixVector, 1);
for iter = 1:numFix,
	saliencyMap(fixVector(iter, 1), fixVector(iter, 2)) = fixWeights(iter);
end;
saliencyMap = imfilter(saliencyMap, G, 'conv', 'same');
saliencyMap = im2uint8(imnorm(saliencyMap));