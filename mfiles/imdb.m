% Image/Signal  Signal to Noise Ratio (SNR) in dB's

% I signal (clean) 
% N noisy signal (e.g. N=I-In, In: noisy signal);

function d=imdb(I,N)

Ps = sum(sum((I - mean(I(:))).^2)); % signal power (no DC)
%Pn = sum(sum(N.^2)); % noise power (assuming no DC)
Pn = sum(sum((N - mean(N(:))).^2));
Pn(Pn==0)=10^-5;
d=10*log10(Ps./Pn);
