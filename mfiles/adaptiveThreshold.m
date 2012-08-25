function J = adaptiveThreshold(varargin)
[I, nhood, maxscale, window] = Parse_Inputs(varargin{:});

I = im2double(I);

% Pad I
[M, N] = size(I);
padSize = (nhood - 1) / 2;
paddedI = padarray(I, padSize, 'symmetric', 'both');

% Find out what output type to make.
rows = 0:(nhood(1)-1); 
cols = 0:(nhood(2)-1);
J = zeros(size(I,1),size(I,2),maxscale - window + 1);
    
% Apply m-file to each neighborhood of a
for i=1:M,
  for j=1:N,
    x = paddedI(i+rows,j+cols);
	localThresh = (max(x(:)) + min(x(:))) / 2;
	localVariance = (max(x(:)) - min(x(:))) / min(x(:)) * 100;
	if (localVariance < 10)
		J(i,j,:) = 0;
	else
		J(i,j,:) = I(i,j) > localThresh;
	end;
  end;
end;

%%%
%%% Function parse_inputs
%%%
function [I, nhood, maxscale, window] = Parse_Inputs(varargin)

iptchecknargin(1,7,nargin,mfilename);

iptcheckinput(varargin{1},{'uint8','uint16','double','logical'},...
              {'real', 'nonempty','nonsparse'},mfilename, 'I',1);

I = varargin{1};
nhood = [9 9];
maxscale = 5;
window = 5;

eid = sprintf('Images:%s:invalidImage',mfilename);
  
if (size(I,3) ~= 1),
	msg = 'This function expects I to be a two-dimensional intensity image.';
	error(eid,'%s',msg);
end

eid = sprintf('%s:invalidInputArguments',mfilename);

if nargin == 2,
	if ((~isnumeric(varargin{2})) || (~(length(varargin{2}) == 2))),
		msg = 'Invalid function call.';
	    error(eid,'%s',msg);
	end;
	nhood = varargin{2};
	maxscale = 5;
	window = 5;
elseif nargin == 3,
	nhood(1) = varargin{2};
	nhood(2) = varargin{3};
	maxscale = 5;
	window = 5;
elseif nargin == 4,
	if ((~isnumeric(varargin{2})) || (~(length(varargin{2}) == 2))),
		msg = 'Invalid function call.';
	    error(eid,'%s',msg);
	end;
	nhood = varargin{2};
	if ((~strcmp(varargin{3},'window')) && (~strcmp(varargin{3},'maxscale')))
		msg = 'Invalid function call.';
	    error(eid,'%s',msg);
	end;
	eval(sprintf('%s = varargin{4};',varargin{3}));
elseif nargin == 5,
	nhood(1) = varargin{2};
	nhood(2) = varargin{3};
	if ((~strcmp(varargin{4},'window')) && (~strcmp(varargin{4},'maxscale')))
		msg = 'Invalid function call.';
	    error(eid,'%s',msg);
	end;
	eval(sprintf('%s = varargin{5};',varargin{4}));
elseif nargin == 6,
	if ((~isnumeric(varargin{2})) || (~(length(varargin{2}) == 2))),
		msg = 'Invalid function call.';
	    error(eid,'%s',msg);
	end;
	nhood = varargin{2};
	if ((~strcmp(varargin{3},'window')) && (~strcmp(varargin{3},'maxscale')))
		msg = 'Invalid function call.';
	    error(eid,'%s',msg);
	end;
	eval(sprintf('%s = varargin{4};',varargin{3}));
	if ((~strcmp(varargin{5},'window')) && (~strcmp(varargin{5},'maxscale')))
		msg = 'Invalid function call.';
	    error(eid,'%s',msg);
	end;
	eval(sprintf('%s = varargin{6};',varargin{5}));
elseif nargin == 7,
	nhood(1) = varargin{2};
	nhood(2) = varargin{3};
	if ((~strcmp(varargin{4},'window')) && (~strcmp(varargin{4},'maxscale')))
		msg = 'Invalid function call.';
	    error(eid,'%s',msg);
	end;
	eval(sprintf('%s = varargin{5};',varargin{4}));
	if ((~strcmp(varargin{6},'window')) && (~strcmp(varargin{6},'maxscale')))
		msg = 'Invalid function call.';
	    error(eid,'%s',msg);
	end;
	eval(sprintf('%s = varargin{7};',varargin{6}));
end;