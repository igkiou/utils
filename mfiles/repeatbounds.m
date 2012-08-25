%REPEATBOUNDS.M  Repeat Boundaries in Image
%
%          Image is peeled by m lines and n columns and the boundaries are repeated. Output image is of the 
%          same size as the input one, only with it's boundaries repeated.  
%
%          RepIm=repeatbounds(Image,[m n]) 
%
%         Image : Input Image
%         [m n] : The required number of m lines and n columns to be removed and given 
%         the values of the remaining boundaries instead(default value is [1 1]).
%
%         See also PATCHBOUNDS, IMPAD
%

%09/05/04 G.E.
%CVSP NTUA

function RepIm=repeatbounds(Im,MN);

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

PeelIm=Im(m+1:end-m,n+1:end-n);
for i=1:n
    PeelIm=[PeelIm(:,1) PeelIm PeelIm(:,end)];
end;
    RepIm=PeelIm; clear PeelIm;    
for i=1:m        
    RepIm=[RepIm(1,:); RepIm; RepIm(end,:)]; 
end;