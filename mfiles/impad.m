%IMPAD.M Pad Image with predefined values.
%
%  PaddedImage = IMPAD(Image,[m n],PVal)
%  
%  Pads Image circularly along 2*m lines and 2*n columns by the specified
%  value in PVal. 
%
%  Image      : Input Image of size [M N]
%  PaddedImage: Output Image of size [M+2*m N+2*n]
%  [m n]      : Number of lines and columns to be added
%  PVal       : e.g. O, Inf , -Inf , mean(Image(:)), max(Image(:)) e.t.c.
%
%  Default values are [m n]=[1 1], PVal=0.
%
%  PadImage = IMPAD(Image) pads the Image with zeros along a single pixel
%  line-column region. Creates a zero border. 
  
% 09/05/04 G.E.
%CVSP NTUA

function PadIm=impad(Im,MN,p_value);

if (nargin == 0)
 disp(' ');
 disp('No input arguments');
 disp(' ');
 return;
elseif (nargin == 1)   %default values
 MN=[1 1];
 p_value=0;
elseif (nargin == 2)   %default values
 p_value=0; 
end;

[mROW nCOL]=size(Im);
m=MN(1); n=MN(2);

PadIm=[p_value*ones(m,nCOL+2*n); p_value*ones(mROW,n) Im ...
        p_value*ones(mROW,n) ;p_value*ones(m,nCOL+2*n)];
