% Adds in image white gaussian noise of a specified dB level
%
%     J=addimnoise(I,ndB) adds zero-mean WGN of std such that SNR=ndB is achieved. 
%
% G.E.

function J=addimnoise(I,ndB);

Irms=sqrt(sum(sum(I.*I))/prod(size(I)));

% noise standar deviation
s=Irms*(10^(-ndB/20));

% random entries, chosen from a normal distribution with mean = 0 and and std = 1.
randn('state',0);
N=s*randn(size(I));

% add white gaussian noise of mean = 0, std = s for ndB SNR 
J=I+N;


