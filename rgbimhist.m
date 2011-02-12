function hist = rgbimhist(varargin)
%RGBIMHIST Calculate RGB histogram of image data.
%   RGBIMHIST(I) returns a histogram for the rgb image I whose number of
%   bins per histogram dimension is 16.  
%
%   IMHIST(I,N) returns a histogram with N bins per histogram dimension for 
%   the rgb image I.
%
%   Class Support
%   -------------  
%   An input intensity image can be uint8, uint16, int16, single, double, or
%   logical. An input indexed image can be uint8, uint16, single, double, or
%   logical.  
%
%   See also HISTEQ, HIST, IMHIST.

[I, nbins] = parse_inputs(varargin{:});

if(size(I,3) ~= 3)
	messageId = 'rgbimhist:invalidParameter';
	message1 = 'image must have a third dimension of size 3.'; 
	error(messageId, '%s', message1);
elseif(nbins == 0)
	messageId = 'rgbimhist:invalidParameter';
	message1 = 'number of bins must be non-zero.'; 
	error(messageId, '%s', message1);
end

if islogical(I)
  nbins = 2;
else
  I = im2uint8(I);
  I=uint8(idivide(uint16(I)*nbins,uint16(256*ones(size(I))),'floor'));
end

hist = rgbimhistmex(I(:,:,1),I(:,:,2),I(:,:,3),nbins);

%%%
%%% Function parse_inputs
%%%
function [I, Nbins] = parse_inputs(varargin)

iptchecknargin(1,2,nargin,mfilename);
iptcheckinput(varargin{1},{'uint8','uint16','double','logical'},...
              {'real', 'nonempty','nonsparse'},mfilename, 'I',1);
I = varargin{1};

if nargin == 1
  Nbins = 16;
else
  Nbins = varargin{2};
end;