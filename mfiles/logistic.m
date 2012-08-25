function y = logistic(r, x)

y = 1 / 2 - 1 ./ (1 + exp(r * x));