function LCH = xyz2lch(XYZ, wtpoint)

if ((nargin < 2) || isempty(wtpoint)),
	wtpoint = 'D65';
end;

LAB = xyz2lab(XYZ, wtpoint);
LCH = lab2lch(LAB);
