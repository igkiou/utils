function J = absfilt(varargin)
%ABSFILT Local mean absolute difference of intensity image.
  
[I, meanIm, h] = ParseInputs(varargin{:});

if(any(isnan(meanIm(:)))),
	meanIm = imfilter(I, h, 'symmetric', 'corr', 'same') / length(find(h));
end;
meanIm = double(meanIm);

% Capture original size before padding.
origSize = size(I);

% Pad array. 
padSize = (size(h) -1) / 2;
I = padarray(I,padSize,'symmetric','both');
meanIm = padarray(meanIm,padSize,'symmetric','both');
newSize = size(I);

% Calculate local abs using MEX-file.
J = absfiltmex(I,meanIm,newSize,h); 
    
% Append zeros to padSize so that it has the same number of dimensions as the
% padded image.
ndim = ndims(I);
padSize = [padSize zeros(1,(ndim - ndims(padSize)))];

% Extract the "middle" of the result; it should be the same size as
% the input image.
idx = cell(1, ndim);
for k = 1: ndim
  s = size(J,k) - (2*padSize(k));
  first = padSize(k) + 1;
  last = first + s - 1;
  idx{k} = first:last;
end
J = J(idx{:});

if ~isequal(size(J),origSize)
  %should never get here
  eid = sprintf('Images:%s:internalError',mfilename);
  msg = 'Internal error: J is  not the same size as original image I.';
  error(eid,'%s',msg);
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [I,MeanIm,H] = ParseInputs(varargin)

iptchecknargin(1,3,nargin,mfilename);

iptcheckinput(varargin{1},{'uint8','uint16','double','logical'},...
              {'real', 'nonempty','nonsparse'},mfilename, 'I',1);
I = varargin{1};

if nargin == 1
	MeanIm = NaN;
	H = true(9);
elseif nargin == 2
	MeanIm = varargin{2};
	H = true(9);
else
	MeanIm = varargin{2};
	H = varargin{3};
end
  
eid = sprintf('Images:%s:invalidMeanImage',mfilename);

if(~any(isnan(MeanIm(:))) && any(size(I) ~= size(MeanIm))),
	msg = 'This function expects MEANIM to have the same size as the inpupt image IM.';
	error(eid,'%s',msg);
end;
	
% Check H. 
iptcheckinput(H,{'logical','numeric'},{'nonempty','nonsparse'},mfilename, ...
			'NHOOD',2);

eid = sprintf('Images:%s:invalidNeighborhood',mfilename);

% H must contain zeros and or ones.
bad_elements = (H ~= 0) & (H ~= 1);
if any(bad_elements(:))
	msg = 'This function expects NHOOD to contain only zeros and/or ones.';
	error(eid,'%s',msg);
end

% H's size must be odd (a factor of 2n-1).
sizeH = size(H);
if any(floor(sizeH/2) == (sizeH/2))
	msg1 = 'This function expects NHOOD to have a size that ';
	msg2 = 'is odd in each dimension.';
	msg = sprintf('%s\n%s',msg1,msg2);
	error(eid,'%s',msg);
end

% Convert H to a logical array.
if ~islogical(H)
	H = H ~= 0;
end
  
