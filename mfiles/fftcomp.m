function [amplitude, frequency] = fftcomp(data, rate);

numSamples = length(data);
nfft = 2^nextpow2(numSamples);
y = fft(data,nfft)/numSamples;
frequency = rate/2*linspace(0,1,nfft/2+1);
amplitude = 2*abs(y(1:nfft/2+1));