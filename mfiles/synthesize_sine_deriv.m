function [I,derivatives,amfm,derivatives_clean] = synthesize_sine_deriv(thpp,filter_angle,N,M,sigma_x,sigma_y,am,fm,ndB,cros_int,gb_filters,fil_ind);

if nargin == 3 N=M; end;
if nargin == 4 sigma_x=0; sigma_y=0; am=0; fm=0; end;
if nargin < 7 am = 0; end;
if nargin < 8 fm = 0; end;
if nargin <= 10 cros_int= 0; end;

[n,m] = meshgrid([1:N],[1:M]);


R = thpp*pi;
th = filter_angle;

U = R*sin(th)*M;
V = R*cos(th)*N;

non_center = 0;

if non_center
   U = U + (-sigma_y);
   V = V + (-sigma_x);
end;

% Wm = 2*pi*U/M;
% Wn = 2*pi*V/N;

Wm = U/M;
Wn = V/N;


% Flag for AM modulation (fixed or not)
if am==1
    % Exponential decaying amplitude parameters;
    a=1; b=.005;%.05;
    Am = a*(exp(-b*n));
    derivative_AM_y = 0;
    derivative_AM_x = -b*a*exp(-b*n);
    derivative_AM_yy = 0;
    derivative_AM_xy = 0;
    derivative_AM_xx = b*b*a*exp(-b*n);
elseif am==2

    % Gaussian envelope centered at half the dimensions
    a = 3*sigma_x; b = 3*sigma_y;
    [y,x] = meshgrid([-0.5:1/(M-1):0.5],[-0.5:1/(N-1):0.5]);
    y=y*M; x=x*N;

    k = 1;%1/(2*pi*a*b);
    Am = k*exp(-(x.^2/(2*a^2)+y.^2/(2*b^2)));
    
    derivative_AM_x = -(x./(a^2)).*Am;
    derivative_AM_y = -(y./(b^2)).*Am;
    derivative_AM_xx = Am.*((x/a)^2-1)./a^2;
    derivative_AM_yy = Am.*((y/b)^2-1)./b^2;
    derivative_AM_xy = (x./(a^2)).*(y./(b^2)).*Am;

elseif am==3

    % Sin envelope centered at half the dimensions
    k = 0.5;
    a1 = pi/30;
    a2 = pi/50;
    c=0.5;
    cosAM = cos(a1*m+a2*n);
    sinAM = sin(a1*m+a2*n);

    Am=k*(1+c*sinAM);
    derivative_AM_x = -k*c*a2*cosAM;
    derivative_AM_y = -k*c*a1*cosAM;
    derivative_AM_xx = -(k*c*a2)^2*(sinAM);
    derivative_AM_yy = -(k*c*a1)^2*(sinAM);
    derivative_AM_xy = -(a1*a2)*(k*c)^2*(sinAM);

% elseif am==4
% 
%     % Gaussian envelope centered at half the dimensions
%     a = 2.5*sigma_x; b = 2.5*sigma_y;
%     [y,x] = meshgrid([-0.5:1/(M-1):0.5],[-0.5:1/(N-1):0.5]);
%     y=y*M; x=x*N;
% 
%     k = 1;%1/(2*pi*a*b);
%     c = 0.5;
%     g = k*exp(-(x.^2/(2*a^2)+y.^2/(2*b^2)));
%     Am = c*(1+g);
%     
%     
%     derivative_AM_x = -c*(x./(a^2)).*g;
%     derivative_AM_y = -c*(y./(b^2)).*g;
%     derivative_AM_xx = c*g.*((x/a)^2-1)./a^2;
%     derivative_AM_yy = c*g.*((y/b)^2-1)./b^2;
%     derivative_AM_xy = c*(x./(a^2)).*(y./(b^2)).*g;    

else
    Am = ones(M,N);
    derivative_AM_x = 0;
    derivative_AM_y = 0;
    derivative_AM_xx = 0;
    derivative_AM_xy = 0;
    derivative_AM_yy = 0;
end;


% Flag for FM modulation (fixed or not)

if fm==1;
    fmi1 = 1; fmi2 = 2;
    wf1 = pi/30; wf2 = pi/50;
    phofs=0; theta=pi*phofs;
    FM = fmi1*sin(wf1*m+theta)+fmi2*sin(wf2*n+theta);
    FM_derivative_y = fmi1*wf1*cos(wf1*m+theta);
    FM_derivative_x = fmi2*wf2*cos(wf2*n+theta);
    FM_derivative_yy = - fmi1*wf1*wf1*sin(wf1*m+theta);
    FM_derivative_xy = 0;
    FM_derivative_xx = - fmi2*wf2*wf2*sin(wf2*n+theta);

else
    FM=0;
    FM_derivative_x = 0;
    FM_derivative_y = 0;
    FM_derivative_yy = 0;
    FM_derivative_xy = 0;
    FM_derivative_xx = 0;

end;

cosI = cos(Wm*m+Wn*n+FM);
derivative_x_cosI  = - (Wn + FM_derivative_x).*sin(Wm*m + Wn*n + FM);
derivative_y_cosI  = - (Wm + FM_derivative_y).*sin(Wm*m + Wn*n + FM);

derivative_xx_cosI = - (FM_derivative_xx).*sin(Wm*m + Wn*n + FM) -...
    (Wn + FM_derivative_x).^2.*cos(Wm*m + Wn*n + FM);

derivative_xy_cosI = - (FM_derivative_xy).*sin(Wm*m + Wn*n + FM) -... %bug fixed, second sign
    (Wn + FM_derivative_x).*(Wm + FM_derivative_y)...
    .*cos(Wm*m + Wn*n + FM);

derivative_yy_cosI =  - (FM_derivative_yy).*sin(Wm*m + Wn*n + FM) -...
    (Wm + FM_derivative_y).^2.*cos(Wm*m + Wn*n + FM);


I = Am.*cosI;
Ix = derivative_AM_x.*cosI + Am.*derivative_x_cosI;
Iy = derivative_AM_y.*cosI + Am.*derivative_y_cosI;

Ixx  = derivative_AM_xx.*cosI + derivative_AM_x.*derivative_x_cosI + ...
    derivative_AM_x.*derivative_x_cosI + Am.*derivative_xx_cosI;

Iyy  = derivative_AM_yy.*cosI + derivative_AM_y.*derivative_y_cosI + ...
    derivative_AM_y.*derivative_y_cosI + Am.*derivative_yy_cosI;

Ixy  = derivative_AM_xy.*cosI + derivative_AM_x.*derivative_y_cosI + ...
    Am.*derivative_xy_cosI + derivative_AM_y.*derivative_x_cosI;


% crosscomponent interference 
%cros_in = 1

if cros_int
    
    fil_ind = fil_ind - 1;     % 10*(sc-1) + or;
%     fil_ind = fil_ind -10;
%     fil_ind = fil_ind +1;
%     fil_ind = fil_ind -1;
    structure = gb_filters{fil_ind}; expand_structure;
    [J,der] = synthesize_sine_deriv(thpp,filter_angle,N,M,sigma_x,sigma_y,am,fm);
    
    I = I + der.I; 
    Ix = Ix + der.Ix; 
    Iy = Iy + der.Iy; 
    Ixx = Ixx + der.Ixx; 
    Iyy = Iyy + der.Iyy; 
    Ixy = Ixy + der.Ixy;
    
end;


derivatives_clean = [];
% Add noise 
if nargin>=9
    fields_wt = {'I','Ix','Iy','Ixx','Iyy','Ixy'};
    compress_structure; derivatives_clean = structure;
    % noise standar deviation
    s = sqrt(sum(sum(I.*I))/prod(size(I)))*(10^(-ndB/20));
    randn('state',0); 
    W = s*randn(size(I));
    %W = I-imnoise(I,'localvar',I,s^2);
    % add white gaussian noise of mean = 0, std = s for ndB SNR
    I = I + W;
    Ix = Ix + deriv_x_cen(W); Iy = Iy + deriv_y_cen(W);
    Ixx = Ixx + laplacian_x(W); Iyy = Iyy + laplacian_y(W); Ix = Ixy + deriv_x_cen(deriv_y_cen(W));
end;

fields_wt = {'I','Ix','Iy','Ixx','Iyy','Ixy'};
compress_structure;
derivatives = structure;


% change ge
Wy = Wm*ones(N,M)+ FM_derivative_y;
Wx = Wn*ones(N,M)+ FM_derivative_x;
phase = cumsum(Wx,2) + cumsum(Wy,1);

Wxe = deriv_x_cen(phase);
Wye = deriv_y_cen(phase);

fields_wt = {'Am','phase','Wx','Wy','Wxe','Wye'};
compress_structure; amfm = structure;


    
