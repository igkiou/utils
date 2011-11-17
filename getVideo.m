fileNames = {'October_12_2011/gsd1', 'October_12_2011/gsd2', 'October_12_2011/gsd3',...
	'October_12_2011/lawgate1', 'October_12_2011/lawgate2', 'October_12_2011/lawgate3',...
	'October_12_2011/lawgate4',...
	'October_12_2011/lawlibrary1', 'October_12_2011/lawlibrary2', 'October_12_2011/lawlibrary3',...
	'October_12_2011/lawlibrary4', 'October_12_2011/lawlibrary5', 'October_12_2011/lawlibrary6',...
	'October_12_2011/lawlibrary7', 'October_12_2011/lawlibrary8', 'October_12_2011/lawlibrary9',...
	'October_12_2011/lawlibrary10',...
	'October_12_2011/yard1', 'October_12_2011/yard2', 'October_12_2011/yard3',...
	'October_12_2011/yard4', 'October_12_2011/yard5'};
fps = 10;
wavelength = 420:10:720;

numWavelengths = length(wavelength);
numFiles = length(fileNames);
range = getrangefromclass(uint16(1));
compensationFunction = getCompensationFunction('sensitivity');

for iterFile = 1:numFiles,
	cube = getCube(fileNames{iterFile}, wavelength);
	cube = imflip(cube);
	for iter = 1:numWavelengths,
		cube(:, :, iter) = cube(:, :, iter) / compensationFunction(iter);
	end;
	cube = cube / maxv(cube);
	aviobj = avifile(sprintf('%s.avi', fileNames{iterFile}), 'fps', fps);
	for iter = 1:numWavelengths,
% 		I = imreadd(sprintf('%s_%d.tif', fileNames{iterFile}, wavelength(iter)));
		I(:, :, 1) = cube(:, :, iter);
		I(:, :, 2) = cube(:, :, iter);
		I(:, :, 3) = cube(:, :, iter);
% 		I = I / denom;
		Q = im2frame(im2uint8(I));
		aviobj = addframe(aviobj, Q);
	end;
	aviobj = close(aviobj);
end;
