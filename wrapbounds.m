%WRAPBOUNDS.M  Wrap Boundaries in Image (for filtering)
%
%      Image boundaries are patched by considering circular image periodicity. Input image values outside the bounds 
%      of the array are computed by implicitly assuming the input image is periodic.Consider an image wrapping 
%      a cylinder horizontally and vertically. Output image is of size as the input one plus the extra added boundaries
%     
%
%      WrappedIm=wrapbounds(Image,[m n]) 
%
%      Image : Input Image
%      [m n] : The required number of m lines and n columns to be added and given 
%      the values of the opposite boundaries instead (default value is [1 1]).
%
%      Usefull for convolution with filters. e.g.
%            
%            h=fspecial('average',[31 31])
%            p=length(h)-1;
%            Im=double(imread('cameraman.tif'))./255;
%            F=cropbounds(conv2(wrapbounds(Im,p),h,'valid'),p/2);
%
%      See also REPEATBOUNDS, CROPBOUNDS, IMPAD, PATCHBOUNDS

%17/06/04 G.E.
%CVSP NTUA

function PatchedIm=wrapbounds(Im,MN);

if (nargin == 0)
 disp(' ');
 disp('No input arguments');
 disp(' ');
 return;
elseif (nargin == 1)   %default value
 MN=[1 1];
end;

if min(size(MN))==max(size(MN))
    m=MN; n=MN;
else
m=MN(1); n=MN(2);
end;

CIm=[Im(:,end-n:1:end) Im Im(:,1:1:n-1)];
PatchedIm=[CIm(end-n:1:end,:); CIm; CIm(1:1:m-1,:)]; 





