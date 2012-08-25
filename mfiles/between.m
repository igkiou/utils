function mask = between(X, low_bound, upper_bound)

mask = (X >= low_bound) & (X < upper_bound);
