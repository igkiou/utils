function [Image,Amfm] = synthesize_texture(image_counter,L,extras);
randn('seed',0);
rand('seed',0);
Amfm=[];
% extras(1): noise variance;
% extras(2): scale
% extras(3): orientation
noise_str =1;
scale = 3;
orientation  = 0;
offset = 0;
if nargin>2
    noise_str = extras(1);
    scale = extras(2);
    orientation = extras(3);
    if length(extras)>3,
        offset = extras(4);
    end
else
    extras(1)=  noise_str;
    extras(2)=  scale;
    extras(3)= orientation;
    extras(4) = offset;
end
if nargin<2
L =100;
end;
c_1 = 4;
[n,m]=meshgrid(1:1:L);

Lo =101;
c_1 = 4;
[no,mo]=meshgrid(1:1:Lo);

switch image_counter
    case 1
        % simple steerable sinusoid
        Ampl = 1/2;
        m = m/scale; n = n/scale;
        phase = 2*pi*m*cos(orientation) + 2*pi*n*sin(orientation)  +offset;
        Image=  Ampl.*(cos(phase));
        Image = Image + noise_str*(filter2(ones(3)/9,randn(size(Image))));
    case 2,
        im_1 = synthesize_texture(1,extras);
        extras(3) = extras(3) + pi/2;
        im_2 = synthesize_texture(1,extras);
        mask = imresize(checkerboard(50,2,2)>0,size(im_1));
        Image = (mask>0).*im_1 + (mask<=0).*im_2;
    case 3
        Image  = two_am_fm(100);
    case 4
        %chirp signal
        speed = linspace(0,1,100);
        speed_cum = (cumsum(speed,2));
        speed_cum = speed_cum.*(10*pi/speed_cum(end));
        phase = (ones(100,1))*speed_cum/scale + offset;
        Image = 1/2*cos(phase-pi/4) + 1/2;

    case 5
        m_0 = m/scale; n_0 = n/scale;
        m = m_0*cos(orientation) + n_0*sin(orientation);
        n =  -m_0*sin(orientation)  + n_0*cos(orientation);
        % superposition of orthogonal sinusoids
        Ampl=0.5*(1+0.25*cos(pi*m/30+pi*n/50)+0.25*cos(-pi*m/30+pi*n/50));
        Freq_Y=(pi/3+pi/15*cos(pi/30*m)+pi/10*cos(pi/10*m))/pi;
        Freq_X=(pi/5+pi/50*cos(pi/50*n+pi/2))/pi;
        Ampl = .5*(1+.5*cos(2*pi*m/8));
        phase = 2*pi*n/4 + offset;
        Image=Ampl.*cos(phase);
    case 6
        scale = 30;
        m_0 = m/scale; n_0 = n/scale; 
        m_cen = m_0(round(end/2),1); n_cen = n_0(1,round(end/2));
        m = (m_0 - m_cen)*cos(orientation)  - (n_0 -n_cen)*sin(orientation) + m_cen;
        n = (m_0 - m_cen)*sin(orientation)  + (n_0 -n_cen)*cos(orientation) + n_cen;
        
        Freq_Y=(pi/3+pi/15*cos(pi/10*m)+pi/10*cos(pi/10*m))/pi;
        Freq_X=(pi/5+pi/50*cos(pi/20*n+pi/2))/pi;
        Freq_X = 0.4388*ones(size(m))  + m/40;
        %Freq_Y = .0*ones(size(m)) + m/20; 
        Freq_Y = 0*ones(size(n)) + 3*n/10; 
        Ampl=0.5*(1+0.6*cos(pi*m/20+pi*n/10)); %+0.25*cos(-pi*m/30+pi*n/50));
        %Ampl = 1;
        %Ampl = 1;
        phase = cumsum(Freq_Y,1) + cumsum(Freq_X,2);
        phase_cen = phase(round(end/2),round(end/2)); phase = phase-phase_cen;
        Image = Ampl.*cos(phase);
    case 7,
        coord_1 = reshape(mo,1,prod(size(mo)));
        coord_2 = reshape(no,1,prod(size(no)));
        gauss_filt1 = gauss_nd([coord_1;coord_2],[Lo/2;Lo/2],[Lo/2,0;0,3*Lo]);
        gauss_filt1 = reshape(gauss_filt1,[Lo,Lo]);

        Image  = gauss_filt1;
        Image  = Image/max(Image(:));
    case 8,
        % sinusoid-through-glass-of-water
        Ampl=0.5*(1+0.15*cos(pi*m/70+pi*n/70)); %+0.25*cos(-pi*m/30+pi*n/50));
        [s_m,s_n]= size(n);
        ratio =scale* [ones(s_m,s_n/2),1.3*ones(s_m,s_n/2)];
        diffs = filter1([-1,1,0],n,2,2)./ratio;
        n = cumsum(diffs,2);
        diffs = filter1([-1,1,0],m,1,2)./ratio';
        m = cumsum(diffs,1);
        Freq_X = n;
        Freq_Y = m;
        Image=Ampl.*(sin(Freq_X + Freq_Y));
    case 9,
        % a perfect line edge
        n_cen = n - mean(mean(n));
        Ampl  = (abs(n_cen)<scale);
        Image = Ampl;
    case 10,
        % a perfect step edge
        Image = [ones(L,L/2), zeros(L,L/2)];
    case 11, 
        % ramp edge;
        k=32;
        L=L-mod(L,k);        
        I = ones(L,(k-2)*L/(2*k));
        Z = zeros(L,(k-2)*L/(2*k));
        R = cumsum(ones(L,2*L/k),2); R=R./max(R(:));
        Image = [Z, R, I];       
       
    case 12,
        % diagonal line edge 
        Image=triu(ones(L,L));
       
    case 21
        % two gaussians of different scale
        pre_process = 1;
        coord_1 = reshape(m(:,1:L/2),1,prod(size(m(:,1:L/2))));
        coord_2 = reshape(n(:,1:L/2),1,prod(size(n(:,1:L/2))));
        gauss_filt1 = gauss_nd([coord_1;coord_2],[L/2;L/4],c_1*eye(2));
        gauss_filt1 = reshape(gauss_filt1,[L,L/2]);
        gauss_filt1 = gauss_filt1- gauss_filt1(1,1);
        gauss_filt1 = gauss_filt1./gauss_filt1(L/2,L/4);

        coord_1  = reshape(m(:,(L/2+1):L),1,prod(size(m(:,(L/2+1):L))));
        coord_2  = reshape(n(:,(L/2+1):L),1,prod(size(n(:,(L/2+1):L))));
        gauss_filt2 = gauss_nd([coord_1;coord_2],[L/2;L/2+L/4],c_1*2*eye(2));
            gauss_filt2 = reshape(gauss_filt2,[L,L/2]);
        gauss_filt2 = gauss_filt2- gauss_filt2(1,1);
        gauss_filt2 = gauss_filt2./gauss_filt2(L/2,L/4);

        Ampl = [gauss_filt1, gauss_filt2];
        Image=Ampl.*(cos(pi*m/scale));

    case 22,
        m_0 = m/scale; n_0 = n/scale;
        m = m_0*cos(orientation) + n_0*sin(orientation);
        n =  -m_0*sin(orientation)  + n_0*cos(orientation);
        % superposition of orthogonal sinusoids
        Ampl=0.5*(1+0.25*cos(pi*m/30+pi*n/50)+0.25*cos(-pi*m/30+pi*n/50));
        Freq_Y=(pi/3+pi/15*cos(pi/30*m)+pi/10*cos(pi/10*m))/pi;
        Freq_X=(pi/5+pi/50*cos(pi/50*n+pi/2))/pi;
        Ampl = .5*(1+.5*cos(2*pi*m/8));
        phase = 2*pi*n/4 + offset;
        Image=Ampl.*cos(phase);

end
try
    Wx = Freq_X; Wy = Freq_Y; Am = Ampl;
    fields_wt = {'Am','phase','Wx','Wy'};
    compress_structure;
    Amfm = structure;
catch
end
%     case 7
%         %one sinusoid and a tilted one above it
%         Ampl=0.5*(1+0.25*cos(pi*m/30+pi*n/50)+0.25*cos(-pi*m/30+pi*n/50));
%         Freq_Y=(pi/3+pi/15*cos(pi/30*m)+pi/10*cos(pi/10*m))/pi;
%         Freq_X=(pi/5+pi/50*cos(pi/50*n+pi/2))/pi;
%         Ampl  = .5*(1+.5*cos(pi*m/10+pi*n/20));
%         Image=Ampl.*(sin(pi/7*m));
