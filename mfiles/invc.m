function invX = invc(X)

invX = eye(size(X));
invX = X \ invX;
