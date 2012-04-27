function RGB = lab2rgb(LAB, wtpoint)

if ((nargin < 2) || isempty(wtpoint)),
	wtpoint = 'D65';
end;

XYZ = lab2xyz(LAB, wtpoint);
RGB = xyz2rgb(XYZ, wtpoint);

