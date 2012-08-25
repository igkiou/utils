function E = detectEdges(I,method)

I = im2double(I);
if(nargin == 1 || strcmp(method, 'true'))
	[Dx Dy] = gradient(I);
    E = sqrt(Dx .^ 2 + Dy .^ 2);
elseif(strcmp(method, 'morphological'))
    E = imdilate(I, strel('disk',1))-imerode(I, strel('disk',1));
else 
	error('Error in "method" input argument.');
end;