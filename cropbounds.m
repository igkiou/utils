%CROPBOUNDS Crop Image Boundaries.
%
%  C = CROPBOUNDS(I,[m n]) crops image I circularly along 2*m lines and 2*n columns. 
%
%  I: Input Image of size [M N]
%  C: Output Image of size [M-2*m N-2*n]
%  [m n]: Number of lines and columns to cropped
%
%  Default values are [m n]=[1 1]
%
%  CI = cropbounds(I) crops from I a single pixel line-column region. 
%
%  See also REPEATBOUNDS, PATCHBOUNDS, IMPAD 

% 09/05/04 G.E.
%CVSP NTUA

function CropIm=cropbounds(Im,MN);

if (nargin == 0)
    disp(' ');
    disp('No input arguments');
    disp(' ');
    return;
elseif (nargin == 1)   %default values
    MN=[1 1];
end;


switch prod(size(MN))
    case 1
        m=MN; n=MN;
    case 2
        m=MN(1); n=MN(2);
end;

% if min(size(MN))==max(size(MN))
%     m=MN; n=MN;
% else
% m=MN(1); n=MN(2);
% end;

CropIm=Im(m+1:end-m,n+1:end-n,:);
