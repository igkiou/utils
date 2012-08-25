function corval = morphcorr(vector1, vector2)
%MORPHCORR Morphological correlation.
%   CORVAL = CORR(VECTOR1,VECTOR2) returns a scalar double containing the
%   morphological correlation coefficient between the two input vectors.
%
%	VECTOR1 and VECTOR2 must be of equal lengths and the same class.
%
%   See also CORR, CORRCOEFF, MEAN, STD

eid = sprintf('%s:invalidInput',mfilename);

if (~strcmp(class(vector1),class(vector2))),
	msg = 'This function expects VECTOR1 and VECTOR2 to be of the same class.';
	error(eid,'%s',msg);
end;

if (length(vector1) ~= length(vector2)),
	msg = 'This function expects VECTOR1 and VECTOR2 to be of the same length.';
	error(eid,'%s',msg);
end;

median1 = median(vector1);
std1 = std(vector1);
vector1 = (vector1-median1) / std1;

median2 = median(vector2);
std2 = std(vector2);
vector2 = (vector2-median2) / std2;

corval = sum(min(vector1,vector2)) / (length(vector1) - 1);
