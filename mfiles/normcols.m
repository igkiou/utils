function [y normfactors] = normcols(x)
%NORMCOLS Normalize matrix columns.
%  Y = NORMCOLS(X) normalizes the columns of X to unit length, returning
%  the result as Y.
%

normfactors = sqrt(sum(x.*x));
y = x*spdiag(safeReciprocal(normfactors, 1));
