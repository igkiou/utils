function stdVal = stdv(X)

stdVal = sqrt(meanv(X .^ 2) - meanv(X) .^ 2);