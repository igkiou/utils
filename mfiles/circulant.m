function M = circulant(x)
% Create N x N circulant matrix from N x 1 vector x.
% Author: Ioannis Gkioulekas
% MIT 6.342, Spring 2011

M = toeplitz([x(1); reverse(x(2:end))],x);

