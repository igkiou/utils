function R = resolvent(X, lambda)

R = invc(lambda * eye(size(X)) - X);
