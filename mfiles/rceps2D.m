function [xhat, yhat] = rceps2D(x,k)
%RCEPS2D Real 2D cepstrum.
%   RCEPS2D(X) returns the 2D real cepstrum of the real matrix X.
%
%   [XHAT, YHAT] = RCEPS2D(X) returns both the real cepstrum XHAT and 
%   a smoothed reconstructed version YHAT of the input sequence, keeping
%   only K cepstrum components.
%
%   See also RCEPS, FFT2.

%07/06/05
% G.E. after modification of RCEPS

[m,n] = size(x);

xhat = real(ifft2(log(abs(fft2(x,m,n))))); %2D cepstrum

if nargout > 1
   odd_m = fix(rem(n,2));
   odd_n = fix(rem(m,2));
%    [wm,wn] = meshgrid([1; 2*ones((n+odd_m)/2-1,1) ; ones(1-rem(m,2),1); zeros((n+odd_m)/2-1,1)],...
%        [1; 2*ones((n+odd_n)/2-1,1) ; ones(1-rem(n,2),1); zeros((n+odd_n)/2-1,1)]);
   % [wm,wn] = meshgrid([zeros((m+odd_m)/2-1,1);  ones(1-rem(m,2),1);2*ones((m+odd_m)/2-1,1) ;1],...
   %     [zeros((n+odd_n)/2-1,1);  ones(1-rem(n,2),1);2*ones((n+odd_n)/2-1,1) ;1]);
   
   %wn = [1; 2*ones((n+odd)/2-1,1) ; ones(1-rem(n,2),1); zeros((n+odd)/2-1,1)];     
   
   %keep only k first components;
   % k = 20;
   
   wn = [ones(k,1); zeros(m-k,1)];
   w=conv2(wn,wn');   
   %k=20;     
   %wm= zeros(size(xhat));
   %wm(0.5*(m-2*k):0.5*(m+2*k)-1,0.5*(n-2*k):0.5*(n+2*k)-1) = ones(2*k,2*k);
   
   yhat = zeros(size(x));
    
   % return to smoothed Fourier 
   yhat = real(exp(ifft2(w.*xhat)));
   % shift to center
   yhat = ifftshift(yhat);

end

