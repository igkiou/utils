function Icell = break_image(I, maxradius, maxdim)

% Capture original size before padding.
% origSize = size(I);
h1 = true(maxradius * 2 + 1);
paddedI = padarray(I, (size(h1) -1) / 2, 'symmetric', 'both');
padSize = size(paddedI);

numBlocksPerDim = ceil(size(I) / maxdim);
% numBlocks = prod(numBlocksPerDim);
Icell = cell(numBlocksPerDim);
% Dimcell = cell(numBlocksPerDim);

for iterx = 1:numBlocksPerDim(1),
	for itery = 1:numBlocksPerDim(2),
		maxendx = min(iterx * maxdim + 2 * maxradius, padSize(1));
		maxendy = min(itery * maxdim + 2 * maxradius, padSize(2));
		Icell{iterx,itery} = paddedI(((iterx - 1) * maxdim + 1):maxendx, ((itery - 1) * maxdim + 1):maxendy);
	end;
end;