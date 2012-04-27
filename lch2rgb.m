function RGB = lch2rgb(LCH, wtpoint)

if ((nargin < 2) || isempty(wtpoint)),
	wtpoint = 'D65';
end;

LAB = lch2lab(LCH);
RGB = lab2rgb(LAB, wtpoint);

