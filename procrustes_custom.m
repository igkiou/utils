function [d, Z, transform] = procrustes_custom(X, Y, varargin)

[d, Z, transform] = procrustes(X, Y, varargin{:});
d = sqrt(d);
