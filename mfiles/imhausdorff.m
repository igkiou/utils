function [hausdist forhausdist revhausdist] = imhausdorff(varargin)
%IMHAUSDORFF Correlation of intensity images.    
%   HAUSDIST = IMHAUSDORFF(IMAGE1,IMAGE2) returns HAUSDIST, a scalar value 
%   equal to the hausdorff distance between two intensity images IMAGE1 and
%   IMAGE2.  
%
%	[HAUSDIST FORHAUSDIST REVHAUSDIST] = IMHAUSDORFF(IMAGE1,IMAGE2) also
%	returns the forward and reverse hausdorff distance.
%
%   HAUSDIST = IMHAUSDORFF(IMAGE1,IMAGE2,OPTION1,VALUE1,...) returns different 
%   quantities, depending on the specified options.
%
%   - Possible options
%
%       'definition'	Specify whether to calculate the distance between
%						the grayscale images, or the black-white images
%						that result by thresholding the two input images
%						using Otsu's method.
%						Possible values: 'flatgray' (default), 'truegray',
%						'bw'. 
%
%       'type'			Specifies whether to calculate the forward distance
%						h(IMAGE1,IMAGE2), the reverse distance
%						h(IMAGE2,IMAGE1), or the maximum of the two
%						H(IMAGE1,IMAGE2) = max(h(IMAGE1,IMAGE2),
%						h(IMAGE2,IMAGE1)). 
%						Possible values: 'forward', 'reverse', 'max'
%						(default). 
%
%       'norm'			Specifies whether to normalize the distance.
%						Possible values: 1, 0 (default).
%
%		'height'		Specifies the height of the ball used for the
%						truegray hausdorff distance. 
%						Possible values: 'diagonal', 'mean', 'min', 'max',
%						'unit' (default).
%
%	[HAUSDIST FORHAUSDIST REVHAUSDIST] = IMHAUSDORFF(IMAGE1,IMAGE2,OPTION1,VALUE1,...)
%	returns the hausdorff distance, forward and reverse hausdorff distance,
%	regardless of any 'type' option specified.
%
%   IMAGE1 and IMAGE2 must be intensity or black-white images of the same
%   dimensions. 
%  
%   Class Support
%   -------------  
%   IMAGE1 and IMAGE2 must be logical, uint8, uint16, or double, and must be
%	of the same type, real, nonempty, and nonsparse. CORR is double.
%  
%   See also BWDIST, GRAYDIST, IM2UINT8, IMHIST.
%
%	TODO: Write separate GRAYDIST to call from here.
  
[image1 image2 definition type norm height] = ParseInputs(varargin{:});

if (strcmp(definition,'flatgray'))
	image1 = im2uint8(image1);
	image2 = im2uint8(image2);
	[M N] = size(image1);
	if (strcmp(type,'max') || (nargout > 1))
		distcell{256} = zeros(M,N);
		hmatrix = zeros(M,N);
		nonzerobins = find(imhist(image1, 256) ~= 0);
		for index = transpose(nonzerobins),
			distcell{index} = bwdist(image2 >= (index - 1));
		end;
		for i = 1:M,
			for j = 1:N,
				hmatrix(i,j) = distcell{int32(image1(i,j)) + 1}(i,j);
			end;
		end;
		forhausdist = max(max(hmatrix));
		nonzerobins = find(imhist(image2, 256) ~= 0);
		for index = transpose(nonzerobins),
			distcell{index} = bwdist(image1 >= (index - 1));
		end;
		for i = 1:M,
			for j = 1:N,
				hmatrix(i,j) = distcell{int32(image2(i,j)) + 1}(i,j);
			end;
		end;
		revhausdist = max(max(hmatrix));
		hausdist = max(forhausdist, revhausdist);
		if (norm == 1),
			normFactor = sqrt(sum((size(image1) - 1) .^ 2));
			hausdist = hausdist / normFactor;
			forhausdist = forhausdist / normFactor;
			revhausdist = revhausdist / normFactor;
		end;
	elseif (strcmp(type,'forward'))	
		distcell2{256} = zeros(M,N);
		nonzerobins2 = find(imhist(image1, 256) ~= 0);
		for index = transpose(nonzerobins2),
			distcell2{index} = bwdist(image2 >= (index - 1));
		end;
		hmatrix = zeros(M,N);
		for i = 1:M,
			for j = 1:N,
				hmatrix(i,j) = distcell2{int32(image1(i,j)) + 1}(i,j);
			end;
		end;
		hausdist = max(max(hmatrix));
		if (norm == 1),
			normFactor = sqrt(sum((size(image1) - 1) .^ 2));
			hausdist = hausdist / normFactor;
		end;
	elseif (strcmp(type,'reverse'))
		distcell1{256} = zeros(M,N);
		nonzerobins1 = find(imhist(image2, 256) ~= 0);
		for index = transpose(nonzerobins1),
			distcell1{index} = bwdist(image1 >= (index - 1));
		end;
		hmatrix = zeros(M,N);
		for i = 1:M,
			for j = 1:N,
				hmatrix(i,j) = distcell1{int32(image2(i,j)) + 1}(i,j);
			end;
		end;
		hausdist = max(max(hmatrix));
		if (norm == 1),
			normFactor = sqrt(sum((size(image1) - 1) .^ 2));
			hausdist = hausdist / normFactor;
		end;
	end;
elseif (strcmp(definition,'truegray'))
	image1 = im2uint8(image1);
	image2 = im2uint8(image2);
	image1 = double(image1);
	image2 = double(image2);
	if (strcmp(height, 'unit')),
		strelHeight = 1;
	elseif (strcmp(height, 'diagonal')),
		strelHeight = 255 / sqrt(size(image1, 1) ^ 2 + size(image1, 2) ^ 2);
	elseif (strcmp(height, 'mean')),
		strelHeight = 255 * 2 / (size(image1, 1) + size(image1, 2));
	elseif (strcmp(height, 'max')),
		strelHeight = 255 / max(size(image1, 1), size(image1, 2));
	elseif (strcmp(height, 'min')),
		strelHeight = 255 / min(size(image1, 1), size(image1, 2));
	end;
	ball = strel('ball', 1, strelHeight, 0);
	if (strcmp(type,'max') || (nargout > 1))
		forhausdist = 0;
		temp = image2;
		while(~isempty(find(temp < image1, 1))),
			forhausdist = forhausdist + 1;
			temp = imdilate(temp, ball);
		end;
		revhausdist = 0;
		temp = image1;
		while(~isempty(find(temp < image2, 1))),
			revhausdist = revhausdist + 1;
			temp = imdilate(temp, ball);
		end;
		hausdist = max(forhausdist, revhausdist);
		if (norm == 1),
			normFactor = ceil(255 / strelHeight);
			hausdist = hausdist / normFactor;
			forhausdist = forhausdist / normFactor;
			revhausdist = revhausdist / normFactor;
		end;
	elseif (strcmp(type,'forward'))	
		hausdist = 0;
		temp = image2;
		while(~isempty(find(temp < image1, 1))),
			hausdist = hausdist + 1;
			temp = imdilate(temp, ball);
		end;
		if (norm == 1),
			normFactor = ceil(255 / strelHeight);
			hausdist = hausdist / normFactor;
		end;
	elseif (strcmp(type,'reverse'))
		hausdist = 0;
		temp = image1;
		while(~isempty(find(temp < image2, 1))),
			hausdist = hausdist + 1;
			temp = imdilate(temp, ball);
		end;
		if (norm == 1),
			normFactor = ceil(255 / strelHeight);
			hausdist = hausdist / normFactor;
		end;
	end;
elseif (strcmp(definition,'bw'))
	level1 = graythresh(image1);
	image1 = im2bw(image1, level1);
	level2 = graythresh(image2);
	image2 = im2bw(image2, level2);
	if (strcmp(type,'max') || (nargout > 1))
		distance2 = bwdist(image2);
		forhausdist = max(max(double(distance2) .* double(image1)));
		distance1 = bwdist(image1);
		revhausdist = max(max(double(distance1) .* double(image2)));
		hausdist = max(forhausdist, revhausdist);
		if (norm == 1),
			normFactor = sqrt(sum((size(image1) - 1) .^ 2));
			hausdist = hausdist / normFactor;
			forhausdist = forhausdist / normFactor;
			revhausdist = revhausdist / normFactor;
		end;
	elseif (strcmp(type,'forward'))
		distance2 = bwdist(image2);
		hausdist = max(max(double(distance2) .* double(image1)));
		if (norm == 1),
			normFactor = sqrt(sum((size(image1) - 1) .^ 2));
			hausdist = hausdist / normFactor;
		end;
	elseif (strcmp(type,'reverse'))
		distance1 = bwdist(image1);
		hausdist = max(max(double(distance1) .* double(image2)));
		if (norm == 1),
			normFactor = sqrt(sum((size(image1) - 1) .^ 2));
			hausdist = hausdist / normFactor;
		end;
	end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Image1 Image2 definition type norm height] = ParseInputs(varargin)

iptchecknargin(2,8,nargin,mfilename);

iptcheckinput(varargin{1},{'uint8','uint16', 'double', 'logical'},...
              {'real', 'nonempty', 'nonsparse'},mfilename, 'IMAGE1',1);

iptcheckinput(varargin{2},{'uint8','uint16', 'double', 'logical'},...
              {'real', 'nonempty', 'nonsparse'},mfilename, 'IMAGE2',2);

Image1 = varargin{1};
Image2 = varargin{2};
definition = 'flatgray';
type = 'max';
norm = 0;
height = 'unit';

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
	msg = 'This function expects IMAGE1 and IMAGE2 to be grayscale or black-white.';
	error(eid,'%s',msg);
end

eid = sprintf('%s:invalidOptions',mfilename);

for argCount = 3:2:length(varargin)
	if((~strcmp(varargin{argCount},'type')) && (~strcmp(varargin{argCount},'definition'))...
			&& (~strcmp(varargin{argCount},'norm')) && (~strcmp(varargin{argCount},'height')))	
		msg = 'Invalid option.';
		error(eid,'%s',msg);
	end;
	eval(sprintf('%s = varargin{argCount + 1};',varargin{argCount}));
end;

eid = sprintf('%s:invalidOptionValues',mfilename);

if ((~strcmp(definition,'truegray')) && (~strcmp(definition,'bw'))...
		&& (~strcmp(definition,'flatgray')))
	msg = 'Invalid definition selection.';
	error(eid,'%s',msg);
end;

if ((~strcmp(type,'reverse')) && (~strcmp(type,'forward'))... 
		&& (~strcmp(type,'max')))
	msg = 'Invalid type selection.';
	error(eid,'%s',msg);
end;

if ((~strcmp(height,'diagonal')) && (~strcmp(height,'mean'))...
		&& (~strcmp(height,'unit')) && (~strcmp(height,'min'))...
		&& (~strcmp(height,'max')))
	msg = 'Invalid height selection.';
	error(eid,'%s',msg);
end;