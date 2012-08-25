% Interpolation by median values

function I = medinterp2(I,bot,top,m);

if nargin<=2 top =-inf; end;
if nargin<=3 m=3; end;

z = find((I>=top)|(I<=bot));

if ~isempty(z);
    I_interp = medfilt2(I,[m,m]);
    I(z) = I_interp(z);
end;
