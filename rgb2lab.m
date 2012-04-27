function LAB = rgb2lab(RGB, wtpoint)

if ((nargin < 2) || isempty(wtpoint)),
	wtpoint = 'D65';
end;

XYZ = rgb2xyz(RGB, wtpoint);
LAB = xyz2lab(XYZ, wtpoint);
