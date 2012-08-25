% Make data have zero variance

function [FEATURES, stdVec] = l2norm(FEATURES)

% create unit variance by dividing by the standard deviation
% stdVec=std(FEATURES);
stdVec = sqrt(sum(FEATURES .^ 2) / (size(FEATURES, 1) - 1));
stdVec(stdVec == 0) = 1;
FEATURES = FEATURES ./ repmat(stdVec, [size(FEATURES, 1), 1]);

