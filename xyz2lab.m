function LAB = xyz2lab(XYZ, wtpoint)

if ((nargin < 2) || isempty(wtpoint)),
	wtpoint = 'D65';
end;

WXYZ = whitepoint(wtpoint);
Xn = WXYZ(1);
Yn = WXYZ(2);
Zn = WXYZ(3);

LAB(:, :, 1) = 116 * f(XYZ(:, :, 2) / Yn) - 16;
LAB(:, :, 2) = 500 * (f(XYZ(:, :, 1) / Xn) - f(XYZ(:, :, 2) / Yn));
LAB(:, :, 3) = 200 * (f(XYZ(:, :, 2) / Yn) - f(XYZ(:, :, 3) / Zn));

end

function ft = f(t)

inds = t > (6 / 29) ^ 3;
ft = zeros(size(t));
ft(inds) = t(inds) .^ (1 / 3);
ft(~inds) = 1 / 3 * (29 / 6) ^ 2 * t(~inds) + 4 / 29;

end
