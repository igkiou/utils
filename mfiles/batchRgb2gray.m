function grayData = dataRgb2gray(RGBData)

[numSamples dimDimColor] = size(RGBData);
dim = sqrt(dimDimColor / 3);

T = inv([1.0 0.956 0.621; 1.0 -0.272 -0.647; 1.0 -1.106 1.703]);
coef = T(1,:)';

Ik = reshape(RGBData, [numSamples dim * dim 3]);
Jk = permute(Ik, [3 2 1]);
Kk = reshape(Jk, [3 dim ^ 2 * numSamples]);
Lk = coef' * double(Kk);
grayData = reshape(Lk, [dim ^ 2 numSamples])';
