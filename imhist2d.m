function hist = imhist2d(varargin)
%RGBIMHIST Calculate RGB histogram of image data.
%   IMHIST2D(IMAGE1,IMAGE2) returns a JOINT histogram for the intensity images 
%   IMAGE1, IMAGE2, whose number of bins per histogram dimension is 256.  
%
%   IMHIST(IMAGE1,IMAGE2,N) returns a joint histogram with N bins per histogram 
%   dimension for the intensity images IMAGE1, IMAGE2.
%  
%   Class Support
%   -------------  
%   IMAGE1 and IMAGE2 must be logical, uint8, uint16, or double, and must be
%	of the same type, real, nonempty, and nonsparse.
%
%   See also IMHIST, RGBIMHIST.

[image1, image2, nbins] = parse_inputs(varargin{:});

if islogical(image1)
  nbins = 2;
else
  image1 = im2uint8(image1);
  image1 = uint8(idivide(uint16(image1)*nbins,uint16(256*ones(size(image1))),'floor'));
  image2 = im2uint8(image2);
  image2 = uint8(idivide(uint16(image2)*nbins,uint16(256*ones(size(image2))),'floor'));
end

hist = imhist2dmex(image1,image2,nbins);

%%%
%%% Function parse_inputs
%%%
function [Image1, Image2, Nbins] = parse_inputs(varargin)

iptchecknargin(2,3,nargin,mfilename);

iptcheckinput(varargin{1},{'uint8','uint16', 'double', 'logical'},...
              {'real', 'nonempty', 'nonsparse'},mfilename, 'IMAGE1',1);

iptcheckinput(varargin{2},{'uint8','uint16', 'double', 'logical'},...
              {'real', 'nonempty', 'nonsparse'},mfilename, 'IMAGE2',2);

Image1 = varargin{1};
Image2 = varargin{2};
if nargin == 2
  Nbins = 256;
else
  Nbins = varargin{3};
end

eid = sprintf('%s:invalidImages',mfilename);

if (~isempty(find(size(Image1) ~= size(Image2), 1))),
	msg = 'This function expects IMAGE1 and IMAGE2 to be of the same size.';
	error(eid,'%s',msg);
end

if (~isempty(find(class(Image1) ~= class(Image2), 1))),
	msg = 'This function expects IMAGE1 and IMAGE2 to be of the same class.';
	error(eid,'%s',msg);
end;

eid = sprintf('%s:invalidNumBins',mfilename);

if (Nbins == 0),
	msg = 'This function expects N to be non-zero.';
	error(eid,'%s',msg);
end