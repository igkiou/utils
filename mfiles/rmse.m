function error = rmse(I, J)

N = numel(I);
error = sqrt(mean((I(:) - J(:)) .^ 2));