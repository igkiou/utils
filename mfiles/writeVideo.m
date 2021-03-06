function writeVideo(fileName, cube, compensation, fps, flipFlag, colorVec)

if ((nargin < 3) || (isempty(compensation))),
	compensation = ones(size(cube, 3), 1);
end;
	
if ((nargin < 4) || (isempty(fps))),
	fps = 10;
end;

if ((nargin < 5) || (isempty(flipFlag))),
	flipFlag = 0;
end;

if ((nargin < 6) || (isempty(colorVec))),
	colorVec = ones(length(compensation), 3);
end;

aviobj = avifile(fileName, 'fps', fps);
temporalSize = size(cube, 3);
if (flipFlag == 1),
	cube = imflip(cube);
end;
cube = bsxfun(@rdivide, cube, reshape(compensation, [1 1 temporalSize]));
% cube = cube / maxv(cube);
for iter = 1:temporalSize,
	I(:, :, 1) = cube(:, :, iter) * colorVec(iter, 1);
	I(:, :, 2) = cube(:, :, iter) * colorVec(iter, 2);
	I(:, :, 3) = cube(:, :, iter) * colorVec(iter, 3);
	Q = im2frame(im2uint8(I));
	aviobj = addframe(aviobj, Q);
end;
aviobj = close(aviobj);
