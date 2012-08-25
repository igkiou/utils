% PEAKDET2D Detect peaks (local minima and maxima) in a 2D matrix.
%
%     [MAXTAB, MINTAB] = PEAKDET2D(I, DELTA) finds the local
%     maxima and minima ("peaks") in matrix I. A point is considered 
%     a maximum peak if it has the maximal value, and was preceded 
%     (to the left and above) by a value lower than DELTA. 
%     MAXTAB and MINTAB consists of two columns. Column 1
%     contains indices in I, and column 2 the found values. The search 
%     for peaks is based on PEAKDET, searching rows and columns.
%
%
%  Example (Fourier peak-picking):
%   I = rgb2gray(cropbounds(imresize(double(imread('autumn.tif'))./256,0.7,'bicubic')));
%   F = 10*log(abs(fftshift(fft2(I))+eps));
%   [maxtab mintab] = peakdet2D(F,30);
%   figure; imshow(F,[]); colormap(jet); hold on;
%   plot(maxtab(:,2),maxtab(:,1),'ro'); hold on;
%   plot(mintab(:,2),mintab(:,1),'bo'); hold on;
%   title('Fourier Magnitude Peaks, local max (red) and min (blue)');
%
%
%
% 28/07/06 G.E. NTUA (based on peakdet)

function [maxtab mintab] = peakdet2D(v,delta)

[m,n]=size(v);

[maxROW, maxROWval, minROW, minROWval]= peakdetROW(v,delta);
[maxCOL, maxCOLval, minCOL, minCOLval]= peakdetROW(v',delta);


[maxI,maxJ]=ind2sub([m n],find(maxROW&maxCOL'));

maxtab=[];
for i=1:length(maxI)
    maxtab = [maxtab; maxI(i) maxJ(i) maxROWval(maxI(i),maxJ(i))];
end;

[minI,minJ]=ind2sub([m n],find(minROW&minCOL'));
mintab=[];
for i=1:length(minI)
    mintab = [mintab; minI(i) minJ(i) minROWval(minI(i),minJ(i))];
end;


function [maxROW, maxROWval, minROW, minROWval]= peakdetROW(v,delta);

maxtab = [];
mintab = [];

mn = Inf; mx = -Inf;
mnpos = NaN; mxpos = NaN;

[m,n]=size(v);

lookformax = 1;

maxROW=[]; maxROWval=[];
minROW=[]; minROWval=[];
for i=1:m
    maxtabROW = zeros(1,n); maxtabROWval = zeros(1,n);
    [maxtab, mintab]=peakdet(v(i,:), delta);
    if ~isempty(maxtab)
        maxtabROW(maxtab(:,1))=1;
        maxtabROWval(maxtab(:,1))=maxtab(:,2);
    end;
    maxROW = [maxROW; maxtabROW];
    maxROWval = [maxROWval; maxtabROWval];

    mintabROW = zeros(1,n); mintabROWval = zeros(1,n);
    if ~isempty(mintab)
        mintabROW(mintab(:,1))=1;
        mintabROWval(mintab(:,1))=mintab(:,2);
    end;
    minROW = [minROW; mintabROW];
    minROWval = [minROWval; mintabROWval];
end;

%*******************************************************************

function [maxtab, mintab]=peakdet(v, delta)
% PEAKDET Detect peaks in a vector
%        [MAXTAB, MINTAB] = PEAKDET(V, DELTA) finds the local
%        maxima and minima ("peaks") in the vector V.
%        A point is considered a maximum peak if it has the maximal
%        value, and was preceded (to the left) by a value lower by
%        DELTA. MAXTAB and MINTAB consists of two columns. Column 1
%        contains indices in V, and column 2 the found values.
%
% Eli Billauer, 3.4.05 (Explicitly not copyrighted).
% This function is released to the public domain; Any use is allowed.

maxtab = [];
mintab = [];

v = v(:); % Just in case this wasn't a proper vector

if (length(delta(:)))>1
    error('Input argument DELTA must be a scalar');
end

if delta <= 0
    error('Input argument DELTA must be positive');
end

mn = Inf; mx = -Inf;
mnpos = NaN; mxpos = NaN;

lookformax = 1;

for i=1:length(v)
    this = v(i);
    if this > mx, mx = this; mxpos = i; end
    if this < mn, mn = this; mnpos = i; end

    if lookformax
        if this < mx-delta
            maxtab = [maxtab ; mxpos mx];
            mn = this; mnpos = i;
            lookformax = 0;
        end
    else
        if this > mn+delta
            mintab = [mintab ; mnpos mn];
            mx = this; mxpos = i;
            lookformax = 1;
        end
    end
end