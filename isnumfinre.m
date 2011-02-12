function isnumfinre(x,label)
% Check if 1D or 2D data array X is numeric, finite and real.
% LABEL = string to label data X.

% P. Maragos - 20 April 1998
%--------------------------------------------------------------------
if nargin ~= 2, error('# of arguments must be 2'), end
if ~ischar(label), error('label must be a char array'), end
if length(size(x)) > 2, error(['M-dim ' label ', M>2']), end
if min(size(x)) == 1		% 1D data
   if any(~isnumeric(x)), error([label ' is not numeric array']), end
   if any(~isfinite(x)), error([label ' is not finite-valued']), end
   if any(~isreal(x)), error([label ' is not real-valued']), end
else							% 2D data
   if any(any(~isnumeric(x))), error([label ' is not numeric array']), end
   if any(any(~isfinite(x))), error([label ' is not finite-valued']), end
   if any(any(~isreal(x))), error([label ' is not real-valued']), end
end