% Whiten the data so that it has zero mean and unit variance

function [FEATURES, meanVec, stdVec] = whiten(FEATURES)

% create zero mean by subtracting the mean
meanVec=mean(FEATURES, 1);
FEATURES=FEATURES-repmat(meanVec, [size(FEATURES, 1), 1]);

% create unit variance by dividing by the standard deviation
% stdVec=std(FEATURES);
stdVec = sqrt(sum(FEATURES .^ 2) / (size(FEATURES, 1) - 1));
stdVec(stdVec == 0) = 1;
FEATURES = FEATURES ./ repmat(stdVec, [size(FEATURES, 1), 1]);

