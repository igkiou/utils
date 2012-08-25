function Rsq = multcorr(Y, X)

c = diag(corr(X, Y));
RXX = corr(X);
Rsq = c' * (RXX \ c);
