function [TPRvector overlap total] = imroc(varargin)
%IMROC Calculate ROC values for binary prediction of salient regions.    
%   TPRVECTOR = IMROC(MAP,GROUNDTRUTH) produces vector TPRVECTOR of the
%   hits for FPR values of [.01 .03 .05 .10 .15 .20 .25 .30].
%
%   TPRVECTOR = IMROC(MAP,GROUNDTRUTH,FPRVECTOR) allows the user to specify
%   an FPRvector other than the default.
%
%   TPRVECTOR = IMROC(MAP,GROUNDTRUTH,FPRVECTOR,TYPE) allows the user to
%   further specify the type of TPR to be used. Possible values: max, area
%   (default).
%
%   TPRVECTOR = IMROC(MAP,GROUNDTRUTH,FPRVECTOR,TYPE,CRITERION) allows the 
%	user to further specify the validation criterion to be used. Possible
%	values: fixations, saliency (default).
%
%   MAP and GROUNDTRUTH must be two dimensional images of the same size.
%  
%   Class Support
%   -------------  
%   MAP and GROUNDTRUTH must be logical, uint8, uint16, or double, and must be
%	of the same type, real, nonempty, and nonsparse. All images are
%	converted to logical. OVERLAP is double. 
%  
%   See also SORT, LENGTH, SUM.

[map groundTruth FPRvector type criterion] = ParseInputs(varargin{:});

map = im2double(map);
groundTruth = im2double(groundTruth);

if (strcmp(criterion, 'saliency')),
	if (strcmp(type,'area')),
		numMeasurements = length(FPRvector);
		numSamples = numel(map);
		rankedValues = sort(reshape(map,[1 numSamples]), 2, 'descend');
		TPRvector = zeros(size(FPRvector));
		overlap = zeros(size(FPRvector));
		total = zeros(size(FPRvector));
		rankedGroundTruth = sort(reshape(groundTruth,[1 numSamples]), 2, 'descend');

		for iter = 1:numMeasurements,
			threshold = rankedValues(ceil(FPRvector(iter) * numSamples));
			testHypothesisRegion = map >= threshold;
			thresGroundTruth = rankedGroundTruth(ceil(FPRvector(iter) * numSamples));
			realRegion = groundTruth >= thresGroundTruth;
			overlap(iter) = imoverlap(testHypothesisRegion,realRegion);
			total(iter) = length(find(testHypothesisRegion));
			TPRvector(iter) = overlap(iter) / total(iter);
		end;
	elseif (strcmp(type,'max')),
		numMeasurements = length(FPRvector);
		maxValue = max(map(:));
		TPRvector = zeros(size(FPRvector));
		maxGroundTruth = max(groundTruth(:));
		overlap = zeros(size(FPRvector));
		total = zeros(size(FPRvector));

		for iter = 1:numMeasurements,
			threshold = (1 - FPRvector(iter)) * maxValue;
			testHypothesisRegion = map >= threshold;
			thresGroundTruth = (1 - FPRvector(iter)) * maxGroundTruth;
			realRegion = groundTruth >= thresGroundTruth;
			overlap(iter) = imoverlap(testHypothesisRegion,realRegion);
			total(iter) = length(find(testHypothesisRegion));
			TPRvector(iter) = overlap(iter) / total(iter);
		end;
	end;
elseif (strcmp(criterion, 'fixations')),
	if (strcmp(type,'area')),
		numMeasurements = length(FPRvector);
		numSamples = numel(map);
		rankedValues = sort(reshape(map,[1 numSamples]), 2, 'descend');
		TPRvector = zeros(size(FPRvector));
		overlap = zeros(size(FPRvector));
		total = length(find(groundTruth));

		for iter = 1:numMeasurements,
			threshold = rankedValues(ceil(FPRvector(iter) * numSamples));
			testHypothesisRegion = map >= threshold;
			thresGroundTruth = length(find(groundTruth(testHypothesisRegion)));
			overlap(iter) = thresGroundTruth;
			TPRvector(iter) = overlap(iter) / total;
		end;
	elseif (strcmp(type,'max')),
		numMeasurements = length(FPRvector);
		maxValue = max(map(:));
		TPRvector = zeros(size(FPRvector));
		overlap = zeros(size(FPRvector));
		total = length(find(groundTruth));

		for iter = 1:numMeasurements,
			threshold = (1 - FPRvector(iter)) * maxValue;
			testHypothesisRegion = map >= threshold;
			thresGroundTruth = length(find(groundTruth(testHypothesisRegion)));
			overlap(iter) = thresGroundTruth;
			TPRvector(iter) = overlap(iter) / total;
		end;
	end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Map GroundTruth FPRvector Type Criterion] = ParseInputs(varargin)

iptchecknargin(2,5,nargin,mfilename);

iptcheckinput(varargin{1},{'uint8','uint16', 'double', 'logical'},...
              {'real', 'nonempty', 'nonsparse'},mfilename, 'MAP',1);

iptcheckinput(varargin{2},{'uint8','uint16', 'double', 'logical'},...
              {'real', 'nonempty', 'nonsparse'},mfilename, 'GROUNDTRUTH',2);

Map = varargin{1};
GroundTruth = varargin{2};
if (nargin == 2),
	FPRvector = [.01 .03 .05 .10 .15 .20 .25 .30 .35 .40 .45 .50 .55 .60];
	Type = 'area';
	Criterion = 'saliency';
elseif (nargin == 3),
	FPRvector = varargin{3};
	Type = 'area';
	Criterion = 'saliency';
elseif (nargin == 4),
	FPRvector = varargin{3};
	Type = varargin{4};
	Criterion = 'saliency';
else
	FPRvector = varargin{3};
	Type = varargin{4};
	Criterion = varargin{5};
end;

eid = sprintf('%s:invalidImages',mfilename);

if (~isempty(find(size(Map) ~= size(GroundTruth), 1))),
	msg = 'This function expects MAP and GROUNDTRUTH to be of the same size.';
	error(eid,'%s',msg);
end;

if (~strcmp(class(Map),class(GroundTruth))),
	msg = 'This function expects MAP and GROUNDTRUTH to be of the same class.';
	error(eid,'%s',msg);
end;

if (size(Map,3) ~= 1),
	msg = 'This function expects MAP and GROUNDTRUTH to be two dimensional.';
	error(eid,'%s',msg);
end;

eid = sprintf('%s:invalidFPRvector',mfilename);

if(isempty(FPRvector))
	msg = 'FPRVECTOR argument must be one-dimensional and of non-zero length.';
	error(eid,'%s',msg);
end;

eid = sprintf('%s:invalidType',mfilename);

if((~strcmp(Type, 'area')) && (~strcmp(Type, 'max')))
	msg = 'TYPE argument must be either "area" or "max".';
	error(eid,'%s',msg);
end;

eid = sprintf('%s:invalidCriterion',mfilename);

if((~strcmp(Criterion, 'fixations')) && (~strcmp(Criterion, 'saliency')))
	msg = 'CRITERION argument must be either "saliency" or "fixations".';
	error(eid,'%s',msg);
end;