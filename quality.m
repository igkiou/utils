function y = quality(b, x)

y = b(1) * logistic(b(2), x - b(3)) + b(4) * x + b(5);