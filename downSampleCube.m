function cube_down = downSampleCube(cube, samplingFactor)

[largeM largeN O] = size(cube);
M = largeM / 2 ^ samplingFactor;
N = largeN / 2 ^ samplingFactor;
cube_down = zeros(M, N, O);
for iter = 1:O,
	temp = gauss_pyramid(cube(:,:,iter), samplingFactor + 1);
	cube_down(:,:,iter) = temp{end};
end;
