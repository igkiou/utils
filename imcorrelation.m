function [corval supldata] = imcorrelation(varargin)
%IMCORRELATION Correlation of intensity images.    
%   CORVAL = IMCORRELATION(IMAGE1,IMAGE2) returns CORVAL, a scalar value 
%   equal to the correlation between two intensity images IMAGE1 and IMAGE2. 
%
%   [CORVAL SUPLDATA] = IMCORRELATION(IMAGE1,IMAGE2) also returns the p-value 
%	for testing the hypothesis of no correlation against the alternative 
%   that there is a non-zero correlation. 
%
%   CORVAL = IMCORRELATION(IMAGE1,IMAGE2,OPTION) performs different calculations 
%	depending on OPTION.
%
%	- Possible options
%
%       'normal'     Returns the correlation between the two intensity
%					 images, as described above (default).
%
%       'patch'		 For each pixel, calculates the correlation between the
%					 corresponding neighborhoods around the pixel in the
%					 two images. It returns the average of all such values.
%					 Uses TRUE(9) as the default neighborhood.
%
%		'bw'		 Returns the correlation between the two black-white
%					 images that result by thresholding the two input
%					 images using Otsu's method.
%
%		'morph'		 Returns the morphological correlation between the two
%					 intensity images.
%
%   [CORVAL IMAGE] = IMCORRELATION(IMAGE1,IMAGE2,'patch') also returns the
%   image with the correlation values per pixel.
%
%   CORVAL = IMCORRELATION(IMAGE1,IMAGE2,'patch',NHOOD) uses the NHOOD
%   neighborhood for the calculations.
%
%   [CORVAL SUPLDATA] = IMCORRELATION(IMAGE1,IMAGE2,'bw') also returns the 
%	p-value for testing the hypothesis of no correlation against the alternative 
%   that there is a non-zero correlation between the black-white images. 
%
%   IMAGE1 and IMAGE2 can be multidimensional images of the same dimensions.
%   If they have more than two dimensions, they are treated as multidimensional 
%	intensity images and not as RGB images. IMAGE1 and IMAGE2 must be of the 
%	same size in every dimension
%  
%   Class Support
%   -------------  
%   IMAGE1 and IMAGE2 must be logical, uint8, uint16, or double, and must be
%	of the same type, real, nonempty, and nonsparse. CORR is double.
%  
%   See also CORR, MORPHCORR, RESHAPE.
%
%	TODO: Check morphological correlation normalization.
  
[image1 image2 mode nhood] = ParseInputs(varargin{:});

if (mode == 0)
	numEl = numel(image1);
	vector1 = reshape(im2double(image1),numEl,1);
	vector2 = reshape(im2double(image2),numEl,1);
	[corval supldata] = corr(vector1,vector2);
elseif (mode == 1)
	supldata = imcorrelationmex(image1,image2,[size(image1,1) size(image1,2)],nhood); 
	supldata(isnan(supldata)) = 0;
	corval = mean(mean(supldata));
elseif (mode == 2)
	level1 = graythresh(image1);
	image1 = im2bw(image1, level1);
	level2 = graythresh(image2);
	image2 = im2bw(image2, level2);
	numEl = numel(image1);
	vector1 = reshape(im2double(image1),numEl,1);
	vector2 = reshape(im2double(image2),numEl,1);
	[corval supldata] = corr(vector1,vector2);
elseif (mode == 3)
	level1 = graythresh(image1);
	image1 = im2bw(image1, level1);
	level2 = graythresh(image2);
	image2 = im2bw(image2, level2);
	numEl = numel(image1);
	vector1 = reshape(im2double(image1),numEl,1);
	vector2 = reshape(im2double(image2),numEl,1);
	corval = morphcorr(vector1,vector2);

end;
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Image1 Image2 Mode Nhood] = ParseInputs(varargin)

iptchecknargin(2,4,nargin,mfilename);

iptcheckinput(varargin{1},{'uint8','uint16', 'double', 'logical'},...
              {'real', 'nonempty', 'nonsparse'},mfilename, 'IMAGE1',1);

iptcheckinput(varargin{2},{'uint8','uint16', 'double', 'logical'},...
              {'real', 'nonempty', 'nonsparse'},mfilename, 'IMAGE2',2);

Image1 = varargin{1};
Image2 = varargin{2};
Mode = 0;
Nhood = true(9);

eid = sprintf('%s:invalidImages',mfilename);

if (~isempty(find(size(Image1) ~= size(Image2), 1))),
	msg = 'This function expects IMAGE1 and IMAGE2 to be of the same size.';
	error(eid,'%s',msg);
end;

if (~strcmp(class(Image1),class(Image2))),
	msg = 'This function expects IMAGE1 and IMAGE2 to be of the same class.';
	error(eid,'%s',msg);
end;

eid = sprintf('%s:invalidMode',mfilename);

if (nargin > 2)
	if ((~ischar(varargin{3})) || ((~strcmp(varargin{3},'normal'))...
		&& (~strcmp(varargin{3},'patch')) && (~strcmp(varargin{3},'bw'))...
		&& (~strcmp(varargin{3},'morph'))))	
		msg = 'Invalid MODE option.';
		error(eid,'%s',msg);
	elseif (strcmp(varargin{3},'normal'))
		Mode = 0;
	elseif (strcmp(varargin{3},'patch'))
		Mode = 1;
	elseif (strcmp(varargin{3},'bw'))
		Mode = 2;
	elseif (strcmp(varargin{3},'morph'))
		Mode = 3;
	end;
end;

eid = sprintf('%s:invalidNhood',mfilename);

if (nargin > 3)
	if (Mode == 0)
		msg = 'NHOOD argument may only be used with ''patch'' for OPTION.';
		error(eid,'%s',msg);
	else
		Nhood = varargin{4};
		iptcheckinput(Nhood,{'logical','numeric'},{'nonempty','nonsparse'},mfilename, ...
                'NHOOD',2);
		bad_elements = (Nhood ~= 0) & (Nhood ~= 1);
		if any(bad_elements(:))
			msg = 'This function expects NHOOD to contain only zeros and/or ones.';
			error(eid,'%s',msg);
		end;
		sizeNhood = size(Nhood);
		if any(floor(sizeNhood/2) == (sizeNhood/2))
			msg1 = 'This function expects NHOOD to have a size that ';
			msg2 = 'is odd in each dimension.';
			msg = sprintf('%s\n%s',msg1,msg2);
			error(eid,'%s',msg);
		end;
		if ~islogical(Nhood)
			Nhood = Nhood ~= 0;
		end;
	end;
end;