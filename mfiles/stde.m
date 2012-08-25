function [se sea interval] = stde(X)

m = mean(X);
s = std(X);
N = size(X, 1);
se = s / sqrt(N);
sea = 2.58 * se;
lb = m - sea;
ub = m + sea;
interval = [lb ub];
