% LoG and Morphological Edge Detection

function [BWL,BWM]=imedge(I,s,c);

%Gaussian & LoG
%s=1;
N=ceil(3*s)*2+1;
g = fspecial('gaussian',N,s);
h = fspecial('log',N,s);


% LoG 
L=conv2(I,h,'same');


% Morph
B=strel('diamond',1);   %structuring element
F=conv2(I,g,'same'); %gaussian filtering
M=imdilate(F,B)+imerode(F,B)-2*F;


% 1.4
%c=0.001;
th=c*max(I(:));  %0.005 < c < 0.02 
B=strel('diamond',1);
[BWL]=edgestim(L,B,th);
[BWM]=edgestim(M,B,th);

function Edge_Image=edgestim(L,B,theta);
% Compute Image Edges by Boundaries of Binary Images 
% L     :the approximate Laplacian 
% B     :structuring element for morhpological erosion & dilation
% theta :threshold for low laplacian rejection  
X=L>=0;                          %Binary Sign Image 
Y=imdilate(X,B) - imerode(X,B);  %~grad(X)  Boundary of Binary Image
[gx,gy]=gradient(L);             %gradient of Laplacian
m=sqrt((gx.^2) + (gy.^2));
Edge_Image=Y;
Edge_Image(find(m<theta))=0;     %Reject edges with low Laplacian gradient amplitude 


