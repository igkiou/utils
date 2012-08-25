function val = meanlog(X)

val = exp(mean(log(X + eps)));
