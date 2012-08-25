% 2D Directional Hilbert Tranform (Havlicek et. al.)
% Z is the analytic image of I, i.e real(Z) = I;  

% see also hilbert_havl get_hilbert

function Z = hilbert2(I)  

[N,M] = size(I);

H(N,M) = 0;    
H((1:(N/2-1)) + 1,:)      = -j;
H(((N/2+1):(N-1)) + 1,:)  =  j;
H(1,(1:(M/2-1))+1)        = -j;
H(N/2+1,(1:(M/2-1))+1)    = -j;
H(1,((M/2+1):(M-1))+1)    =  j;
H(N/2+1,((M/2+1):(M-1))+1)=  j;

F_t  = fft2(I);
G_t = H.*F_t;
Z = ifft2(F_t+ j*G_t);
