function F = DFTmatrix(N)
% Create DFT matrix of order N.
% Author: Ioannis Gkioulekas
% MIT 6.342, Spring 2011

WN = exp(- 1i * 2 * pi / N);

WNvec = WN .^ (0:(N-1));
F = vander(WNvec);
F = F(:, end:-1:1);
