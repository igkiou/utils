% Probability ditributions

% 31/10/07

function [P,dataBins] = probDist(dataSamples,nBins)

if nargin==1, nBins=10; end;

[dataDist,dataBins]=hist(dataSamples,nBins); 

% % remove zero probabilities 
% zeroProbs = find(dataDist < eps);
% if ~isempty(zeroProbs),
%     dataDist(zeroProbs) = [];
% end

P = dataDist./numel(dataSamples);
