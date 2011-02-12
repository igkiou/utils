function overlap = imoverlap(varargin)
%IMOVERLAP Calculate overlap between binary images.    
%   OVERLAP = IMOVERLAP(IMAGE1,IMAGE2) returns OVERLAP, a scalar value
%   representing the number of pixels that are simultaneously set in both
%   binary images IMAGE1 and IMAGE2, i.e. the cardinality of the
%   intersection of the two images.
%
%   I = IMOVERLAP(IMAGE1,IMAGE2,OPTION) returns different 
%   quantities, depending on the specified options.
%
%       'normal'		Returns the overlap between the two binary images,
%						as defined above (default).
%
%       'normalized'	Returns the normalized overlap between the two
%						binary images, defined as
%						card(intersection(IMAGE1,IMAGE2)) / 
%						card(union(IMAGE1,IMAGE2)).
%
%       'error'			Returns the normalized error between the two
%						binary images, defined as 1 - normalized overlap.
%
%   IMAGE1 and IMAGE2 must be two dimensional images of the same size.
%  
%   Class Support
%   -------------  
%   IMAGE1 and IMAGE2 must be logical, uint8, uint16, or double, and must be
%	of the same type, real, nonempty, and nonsparse. All images are
%	converted to logical. OVERLAP is double. 
%  
%   See also FIND, LENGTH.

[image1 image2 option] = ParseInputs(varargin{:});

image1 = logical(image1);
image2 = logical(image2);
intersectionImage = image1 .* image2;

if (strcmp(option,'normal')) 
	overlap = length(find(intersectionImage));
elseif (strcmp(option,'normalized')) 
	unionImage = image1 + image2;
	overlap = double(length(find(intersectionImage))) /...
				double(length(find(unionImage)));
elseif (strcmp(option,'error')) 
	unionImage = image1 + image2;
	overlap = 1 - double(length(find(intersectionImage))) /...
					double(length(find(unionImage)));
end;
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Image1 Image2 Option] = ParseInputs(varargin)

iptchecknargin(2,3,nargin,mfilename);

iptcheckinput(varargin{1},{'uint8','uint16', 'double', 'logical'},...
              {'real', 'nonempty', 'nonsparse'},mfilename, 'IMAGE1',1);

iptcheckinput(varargin{2},{'uint8','uint16', 'double', 'logical'},...
              {'real', 'nonempty', 'nonsparse'},mfilename, 'IMAGE2',2);

Image1 = varargin{1};
Image2 = varargin{2};
if (nargin == 2),
	Option = 'normal';
else
	Option = varargin{3};
end;

eid = sprintf('%s:invalidImages',mfilename);

if (~isempty(find(size(Image1) ~= size(Image2), 1))),
	msg = 'This function expects IMAGE1 and IMAGE2 to be of the same size.';
	error(eid,'%s',msg);
end;

if (~strcmp(class(Image1),class(Image2))),
	msg = 'This function expects IMAGE1 and IMAGE2 to be of the same class.';
	error(eid,'%s',msg);
end;

if (size(Image1,3) ~= 1),
	msg = 'This function expects IMAGE1 and IMAGE2 to be two dimensional.';
	error(eid,'%s',msg);
end;

eid = sprintf('%s:invalidOption',mfilename);

	if((~strcmp(Option,'normal')) && (~strcmp(Option,'normalized'))...
			&& (~strcmp(Option,'error')))	
		msg = 'Invalid option.';
		error(eid,'%s',msg);
end;