function [I,imageName,Ur,Vr] = imtest(im,s)

if nargin<2, s = 0.6 ;end;

switch im
    case 1
        I = imresize(double(imread('zebra_head.png')),s)./255;
        imageName = 'zebrahead';
    case 2
        I=double(imread('barb.tif'))./255; %I=double(imresize(I,s))./255;
        imageName = 'barb';
    case 3
        I = double(imread('barb_det2.tiff'))./255;
        imageName = 'barb_det2';
    case 4
        I = double(imread('barb_det1.tiff'))./255;
        imageName = 'barb_det1';
    case 5
        I=imread('barb.tif');
        I=double(imcrop(I,[365   6   87   92]))./255;
        imageName = 'barb_crop';
    case 6
        I=imresize(double(imread('goldhill.png')),s)./255;
        imageName = 'goldhill';
    case 7
        I=imresize(double(imread('fingerprint.png')),s)./255;
        imageName = 'fingerprint';
    case 8        
        I = double(imread('cheetah.gif'))./255;
        imageName = 'cheetah';
    case 9
        I = cropbounds(double(rgb2gray(imresize(imread('12084.jpg'),0.7)))./255);
        imageName = 'seaflower';    
    case 10
        I = cropbounds(double(rgb2gray(imresize(imread('106020.jpg'),s)))./255);
        imageName = 'penguin';   
    
    case 11
        brodatzSet={'D92' 'D97'}; d=2;
        I = cropbounds(double(imresize(imread([brodatzSet{d} '.gif']),0.5)),2)./255;
        imageName = ['brodatz_' brodatzSet{d}]; 
        
    case 12
        I=double(imread('C:\work\DATA\Textures\texture.tar\calfleath-1.2.6.pgm'))./255;
        I = I(129:384,129:384);
        imageName = 'calfleath';
        
    case 13  
        stp = 320;
        Freq_X = [-1*ones(1,20),(-1:1/stp:-.1),-.1*ones(1,20)]*pi/2;

        Freq_Y = zeros(size(Freq_X));
        [Freq_X,Freq_Y] = meshgrid(Freq_X,Freq_Y);

        phase = cumsum(Freq_X,2) + cumsum(Freq_Y,1);
        phase = phase - phase(stp+1,stp+1);
        r = sqrt(Freq_X.^2  + Freq_Y.^2);
        Am   = 1 +sqrt(r)/max(sqrt(r(:)));
        %Am = ones(size(r));
        I = Am.*cos(phase);
        imageName = 'chirp';

    case 14
        C = synthesize_circle;
        % ramp edge
        E = synthesize_texture(11,160); E = [E E(:,end)]; Er=[E; E(end,:)];
        % step
        E = synthesize_texture(10,160); E = [E E(:,end)]; Es=[E; E(end,:)];
        % line
        E = synthesize_texture(9,160); E = [E E(:,end)]; El=[E; E(end,:)];
        % diag edge
        E = synthesize_texture(12,160); E = [E E(:,end)]; Ed=[E; E(end,:)];

        c = [0.5 0.3 0.2];
        edgescheme = 3;
        switch edgescheme
            case 1
                Ur=(c(1)*Er + c(2)*Er');
            case 2
                Ur=(c(1)*Er + c(2)*Es');
            case 3
                Ur=(c(1)*Er + c(2)*(Ed+El')./2);
        end;
        Vr =c(3)*C;
        I = Ur + Vr;
        imageName = 'edgecircle';
    case 15
        C = synthesize_circle(2,pi/2,pi/80);
        %C = synthesize_texture(6,160); C = [C C(:,end)]; C=[C; C(end,:)];
        E = double(imread('BARS2.bmp'));
        E = imresize(E(:,:,1),size(C))./255;

        c = [0.8 0.5 0.2];
        edgescheme = 2;
        switch edgescheme
            case 1
                Ur = c(1)*E;
            case 2
                Er = synthesize_texture(11,160); Er=(cropbounds(Er,[0, 40]));
                Er = [Er fliplr(Er)]; Er = [Er Er(:,end)]; Er=[Er; Er(end,:)];
                Ur = c(2)*E + 0.15*(Er+Er');
        end;
        Vr = c(3)*C;
        %Ur = [Ur(:,81:161) Ur(:,1:80)];
        Ur = [Ur(:,97:161) Ur(:,1:96)];
        I = Ur + Vr;
        imageName = 'barscircle';
    
        
    case 16
        I = cropbounds(double(imresize(imread('C:\work\DATA\Textures\periodic\138032.jpg'),s))./255);
        imageName = 'rope';   

    case 17
        I = cropbounds(imresize(double(imread('mandrill.pgm')),s,'bicubic'),2)./255;
        imageName = 'mandrill';
    case 18
        I = cropbounds(double(rgb2gray(imread('C:\work\DATA\Textures\periodic\basket1.jpg'))),2)./255;
        imageName = 'basket';
    case 19
        I = double(imresize(rgb2gray(imread('Zebras.jpg')),s))./255;
        imageName = 'zebras';
    case 20
        I = double(imresize(imread('lena.png'),0.5))/255;
        imageName = 'lena';

    case 21
        load DSC_0004_s_0.16_detail.mat
        %I = double(imresize(rgb2gray(imread('DSC_0004.JPG')),s))./255;
        imageName = 'thira';
     
    case 22
        I = double(imresize(rgb2gray(imread('DSC_0038.JPG')),s))./255;
        imageName = 'DSC_0038';  
        
    case 23
        I = cropbounds(double(rgb2gray(imresize(imread('134052.jpg'),0.8)))./255);
        imageName = 'leopard';  
        I = imcrop(I,[0 45 335 194]);
        
    case 24 %MRI
        I = double(imread('oe_xx_01.png'))./255;
        imageName = 'oe_xx_01';  
    case 25 
        I = cropbounds(double(rgb2gray(imread('castleculzean50.tif')))./255);
        imageName = 'castle'; 
    case 26
        I = double(imresize(rgb2gray(imread('memorial_durand02.png')),s))./255;
        imageName = 'memorial';
    case 27
        I = double(imresize(imread('memorial_durand02.png'),s))./255;
        imageName = 'memorial_color';
    case 28
        I = double(imresize(rgb2gray(imread('D:\work\DATA\Color\image1.png')),s))./255;
        imageName = 'parrots';
    case 29
        I = double(imresize(rgb2gray(imread('parrot1.png')),s))./255;
        imageName = 'parrot';
    case 30
        I = double(imresize(rgb2gray(imread('parrot2.png')),s))./255;
        imageName = 'parrot_red';
    case 31
        I = double(imread('toys.bmp'))./255;
        imageName = 'toys';
    case 32
        I = imresize(double(imread('boat.png')),s,'bicubic')./255;
        imageName = 'boat';
    case 33
        I = imresize(double(imread('D:\work\DATA\art\VanGogh_starrynight.tif'))./255,0.2,'bicubic');
        I = rgb2gray(I);
        imageName = 'vangogh';
    case 34
        I = imresize(double(imread('D:\work\DATA\art\Klimt_kiss_cropped.tif'))./255,0.6,'bicubic');
        I = rgb2gray(I);
        imageName = 'klimt';    
    case 35
        I = cropbounds(double(rgb2gray(imread('zebra3.jpg')))./255);
        imageName = 'zebra';
    case 36
        I = double(imresize(rgb2gray(imread('zebra.png')),0.8,'bicubic'))./255;
        imageName = 'zebra';

    case 37
        I = double(rgb2gray(imread('cats_bk1042.jpg')))./255;
        I = I(33:end,111:710);
        I = imresize(I,0.5,'bicubic');
        imageName = 'cats';
      
end;



if ((im<14)||(im>15)) && (nargout>2)
    G = gaus2D(size(I)*0.0278);
    Ur = mean(I(:))+ double(imfilter(single(I),G,'symmetric','same'));
    % Ur = mean(I(:))+gabor2Dfiltersum(I,GbFilters(end),'symmetric');
    Vr=I-Ur;
end;


% cform = makecform('srgb2lab');
% I_he = applycform(I,cform);
% ab = double(I_he(:,:,2:3));
