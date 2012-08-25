function trackingData = openTrackingData(imageSelection, scale, normalize)

% TODO: Change functions that use trackingData so that they treat is as a
% struct, and change isnan to isstruct in scripts that check if tracking
% data exists.

if (nargin < 2), scale = 1; end;
if (nargin < 3), normalize = 1; end;

[imageData imageName] = selectImage(imageSelection);
if ((imageSelection < 119) && (exist(sprintf('images/%s/moyennefiltre2.jpg',imageName),'file') == 2))
	trackingData.origImage = imageData;
	eval(sprintf('trackingData.imageName = ''%s'';',imageName));
	eval(sprintf('trackingData.data = imread(''images/%s/moyennefiltre2.jpg'');',imageName));
	trackingData.scale = 1;
	if (scale ~= 1)
		trackingData.data = imresize(trackingData.data, ...
			[idivide(size(trackingData.data,1),int32(scale)) idivide(size(trackingData.data,2),int32(scale))]);		
		trackingData.scale = scale;
	end;
	if (normalize)
		trackingData.data = imnorm(double(rgb2gray(trackingData.data)));
		trackingData.normalized = 1;
	else
		trackingData.normalized = 0;
	end;
elseif(exist(sprintf('MITdatabase/saliencyMaps/%s.saliencyMap.jpeg',imageName),'file') == 2)
	trackingData.origImage = imageData;
	eval(sprintf('trackingData.imageName = ''%s'';',imageName));
	eval(sprintf('trackingData.data = imread(''MITdatabase/saliencyMaps/%s.saliencyMap.jpeg'');',imageName));
	trackingData.scale = 1;
	if (scale ~= 1)
		trackingData.data = imresize(trackingData.data, ...
			[idivide(size(trackingData.data,1),int32(scale)) idivide(size(trackingData.data,2),int32(scale))]);		
		trackingData.scale = scale;
	end;
	if (normalize)
		trackingData.data = imnorm(double(trackingData.data));
		trackingData.normalized = 1;
	else
		trackingData.normalized = 0;
	end;
elseif(exist(sprintf('eyetrackingdata/fixdens/density_maps/d%s.jpg',imageName),'file') == 2)
	trackingData.origImage = imageData;
	eval(sprintf('trackingData.imageName = ''%s'';',imageName));
	eval(sprintf('trackingData.data = imread(''eyetrackingdata/fixdens/density_maps/d%s.jpg'');',imageName));
	trackingData.scale = 1;
	if (scale ~= 1)
		trackingData.data = imresize(trackingData.data, ...
			[idivide(size(trackingData.data,1),int32(scale)) idivide(size(trackingData.data,2),int32(scale))]);		
		trackingData.scale = scale;
	end;
	if (normalize)
		trackingData.data = imnorm(double(trackingData.data));
		trackingData.normalized = 1;
	else
		trackingData.normalized = 0;
	end;
else
	trackingData = NaN;
	disp('No data available yet');
end;