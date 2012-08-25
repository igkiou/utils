% Compute Image Edges by Boundaries of Binary Images 
% L     :the approximate Laplacian 
% B     :structuring element for morhpological erosion & dilation
% theta :threshold for low laplacian rejection 

function Edge_Image=edgestim(L,B,theta);

if nargin==1;
    B=strel('disk',1);
end;
X=L>0;                           %Binary Sign Image 
Y=imdilate(X,B) - imerode(X,B);  %~grad(X)  Boundary of Binary Image
[gx,gy]=gradient(L);             %gradient of Laplacian
m=sqrt((gx.^2) + (gy.^2));
Edge_Image=Y;

if nargin<3;
    theta=mean(m(:));
end;
Edge_Image(find(m<theta))=0;     %Reject edges with low Laplacian gradient amplitude 
