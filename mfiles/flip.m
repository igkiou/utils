function I = flip(I, dim)

if (dim == 1),
	I = I(end:-1:1, :);
elseif (dim == 2),
	I = I(:, end:-1:1, :);
end;