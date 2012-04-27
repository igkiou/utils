function LCH = rgb2lch(RGB, wtpoint)

if ((nargin < 2) || isempty(wtpoint)),
	wtpoint = 'D65';
end;

LAB = rgb2lab(RGB, wtpoint);
LCH = lab2lch(LAB);
