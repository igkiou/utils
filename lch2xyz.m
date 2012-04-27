function XYZ = lch2xyz(LCH, wtpoint)

if ((nargin < 2) || isempty(wtpoint)),
	wtpoint = 'D65';
end;

LAB = lch2lab(LCH);
XYZ = lab2xyz(LAB, wtpoint);

