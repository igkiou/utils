function I = immutualinfo(varargin)
%IMMUTUALINFO Mutual information of intensity images.    
%   I = IMMUTUALINFO(IMAGE1,IMAGE2) returns I, a scalar value representing the 
%   mutual information between two intensity images. Mutual information is 
%   an information theoretic measure of the mutual dependence of the two images. 
%   Mutual information is defined as I(IMAGE1,IMAGE2) = H(IMAGE1) + H(IMAGE2)
%   - H(IMAGE1,IMAGE2), where H is the entropy of the random variables of which
%   the images' pixels are considered samples. 
%
%   I = IMMUTUALINFO(IMAGE1,IMAGE2,OPTION) returns different information  
%   theoretic quantities, depending on OPTION.
%
%   - Possible options
%
%       'normal'     Returns the mutual information I(IMAGE1,IMAGE2), 
%                    as defined above (default).
%
%       'normalized' Returns the normalized mutual information, or 
%                    redundancy R(IMAGE1,IMAGE2), which is defined as 
%					 I(IMAGE1,IMAGE2) / (H(IMAGE1) + H(IMAGE2)).
%
%       'metric'	 Returns the metric d(IMAGE1,IMAGE2) which is  
%					 defined as H(IMAGE1,IMAGE2) - I(IMAGE1,IMAGE2).
%
%       'normmetric' Returns the normalized metric D(IMAGE1,IMAGE2) which
%					  is defined as d(IMAGE1,IMAGE2) / H(IMAGE1,IMAGE2).
%  
%   IMMUTUALINFO uses 2 bins in IMHIST for logical arrays and 256 bins for
%   uint8, double or uint16 arrays.  
%
%   IMAGE1 and IMAGE2 can be multidimensional images of the same dimensions.
%   If they have more than two dimensions, they are treated as multidimensional 
%	intensity images and not as RGB images. IMAGE1 and IMAGE2 must be of the 
%	same size in every dimension
%  
%   Class Support
%   -------------  
%   IMAGE1 and IMAGE2 must be logical, uint8, uint16, or double, and must be
%	of the same type, real, nonempty, and nonsparse. I is double.
%
%   Notes
%   -----    
%   IMMUTUALINFO converts any class other than logical to uint8 for the histogram
%   count calculation so that the pixel values are discrete and directly
%   correspond to a bin value.
%  
%   See also IMHIST, IMHIST2D, ENTROPY.
%
%	TODO: Replace mutualinfo with immutualinfo in files that use the
%	former.
  
[image1 image2 option] = ParseInputs(varargin{:});

if ~islogical(image1)
  image1 = im2uint8(image1);
  image2 = im2uint8(image2);
end

% calculate histogram counts
p1 = imhist(image1(:));
p2 = imhist(image2(:));
p12 = imhist2d(image1,image2);

% remove zero entries in histograms
p1(p1==0) = [];
p2(p2==0) = [];
p12(p12==0) = [];

% normalize histograms so that they sum is one
p1 = p1 ./ numel(image1);
p2 = p2 ./ numel(image2);
p12 = p12 ./ numel(image2);

% calculate entropy
E1 = -sum(p1.*log2(p1));
E2 = -sum(p2.*log2(p2));
E12 = -sum(p12.*log2(p12));

if (strcmp(option,'normal'))	
	I = E1 + E2 - E12;
elseif (strcmp(option,'normalized'))
	I = (E1 + E2 - E12)/(E1 + E2);
elseif (strcmp(option,'metric'))
	I = 2 * E12 - E1 - E2;
elseif (strcmp(option,'normmetric'))
	I = (2 * E12 - E1 - E2) / E12;
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
if nargin == 2
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

eid = sprintf('%s:invalidOption',mfilename);

if (~strcmp(Option,'normal') && ~strcmp(Option,'normalized') &&...
		~strcmp(Option,'metric') && ~strcmp(Option,'normmetric'))
	msg = 'Invalid argument for OPTION input parameter.';
	error(eid,'%s',msg);
end;
