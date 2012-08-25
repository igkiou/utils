%PATCHBOUNDS.M  Patch Boundaries in Image (for filtering)
%      Image boundaries are repeated (inversed). Output image is of the same size as the input one, 
%      only with it's boundaries patched. Usefull for convolution with filters.  
%
%      PatcedIm=patchbounds(Image,[m n]) 
%
%      Image : Input Image
%      [m n] : The required number of extra m lines and n columns to be given 
%      inversely the values of the boundaries (default value is [1 1]).
%   
%      See also REPEATBOUNDS, CROPBOUNDS, IMPAD

%03/06/04 G.E.
%CVSP NTUA

function PatchedIm=patchbounds(Im,MN);

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

CIm=[Im(:,n:-1:1,:),Im,Im(:,end:-1:end-n+1,:)];
PatchedIm=[CIm(m:-1:1,:,:); CIm; CIm(end:-1:end-m+1,:,:)]; 

   