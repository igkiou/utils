% jkokkin

function [input_image,amfm,deriv_struct] = synthesize_circle(out,freqMax,freqMin);

if nargin ==0, out = 2; end

switch out,
    case 1
        stp = 80;
        if nargin==1, freqMax = pi/10, end;
        if nargin==2, freqMin = 0.7*freqMax, end;
        max_f  = freqMax; min_f = freqMin;
        % max_f  = pi/15; min_f = pi/20;

        stp_u = (1/(2*stp))*(max_f - min_f);
        Freq_X = [-max_f:stp_u:-min_f];
        % Freq_X = [[-max_f:stp_u:-min_f],[-min_f-stp_u:-stp_u:-max_f]];
        Freq_Y= 0*Freq_X;
        [Freq_X,Freq_Y] = meshgrid(Freq_X,Freq_Y); %  Freq_X = [[-max_f:stp_u/2:-min_f]];

        phase = cumsum(Freq_X,2) + cumsum(Freq_Y,1);
        phase = phase - phase(stp+1,stp+1);
        r = sqrt(Freq_X.^2  + Freq_Y.^2);
        Am   = 1  +sqrt(r)/max(sqrt(r(:)));
        Am = ones(size(r));
        input_image = Am.*cos(phase);

        if nargout>=2
            Wx = Freq_X;
            Wy = Freq_Y;
            fields_wt = {'Am','phase','Wx','Wy'};
            compress_structure;
            amfm = structure;
        end;
    case 2,
        stp = 80;
        if 1==1,
            if nargin<2; freqMax = pi/2; end;
            if nargin<3; freqMin = 0; end;
            max_f = freqMax; min_f = freqMin;
            % max_f = .56; min_f = .55;
            stp_u = (1/stp)*(max_f - min_f);
            Freq_X = [[-max_f:stp_u:-min_f],[min_f+stp_u:stp_u:max_f]];
            % Freq_X = [[-max_f:stp_u:-min_f],[-min_f-stp_u:-stp_u:-max_f]];
            Freq_Y= Freq_X;

            %  Freq_X = [[-max_f:stp_u/2:-min_f]];
            %  Freq_Y = 0*Freq_X;
            %            Freq_Y = zeros(size(Freq_X));
        else
            %            max_f  = .56; min_f = .55;
            max_f = max_f*pi/2; min_f = min_f*pi/2;
            max_f  = .56; min_f = .55;
            stp_u = (1/stp)*(max_f - min_f);

            Freq_X = [[-max_f:(stp_u*2):-min_f],repmat(-min_f,[1,stp/2])];
            Freq_X = [Freq_X,fliplr(Freq_X(1:end-1))];
            %stp_u = stp_u/2;
            %Freq_X =  [min_f:stp_u:max_f];
            Freq_Y = zeros(size(Freq_X));

        end
        [Freq_X,Freq_Y] = meshgrid(Freq_X,Freq_Y);

        phase = cumsum(Freq_X,2) + cumsum(Freq_Y,1);
        phase = phase - phase(stp+1,stp+1);
        r = sqrt(Freq_X.^2  + Freq_Y.^2);
        Am   = 1  +sqrt(r)/max(sqrt(r(:)));
        Am = ones(size(r));
        input_image = Am.*cos(phase);

        if nargout>=2
            Wx = der(phase,2); %deriv_x_certainty(phase);
            Wy = der(phase); %deriv_y_certainty(phase);            
            fields_wt = {'Am','phase','Wx','Wy'};
            compress_structure;
            amfm = structure;
        end;

    case 3
        stp = 160;
        Freq_X = [-1*ones(1,20),[-1:1/stp:-.1],-.1*ones(1,20)]*pi/2;

        Freq_Y = zeros(size(Freq_X));
        [Freq_X,Freq_Y] = meshgrid(Freq_X,Freq_Y);

        phase = cumsum(Freq_X,2) + cumsum(Freq_Y,1);
        phase = phase - phase(stp+1,stp+1);
        r = sqrt(Freq_X.^2  + Freq_Y.^2);
        %Am   = 1  +sqrt(r)/max(sqrt(r(:)));
        Am = ones(size(r));
        input_image = Am.*cos(phase);
        %input_image = imresize(input_image,[161,161]);
        
        if nargout>=2
            Wx = der(phase,2); %deriv_x_certainty(phase);
            Wy = der(phase); %deriv_y_certainty(phase);
            fields_wt = {'Am','phase','Wx','Wy'};
            compress_structure;
            amfm = structure;
        end;
end

if nargout==3
    deriv_x  = -Wx.*sin(phase);
    deriv_xx = -Wx.^2.*cos(phase);
    deriv_y  = -Wy.*sin(phase);
    deriv_yy = -Wy.^2.*cos(phase);
    fields_wt = {'deriv_x','deriv_xx','deriv_y','deriv_yy'};
    compress_structure; deriv_struct= structure;
end;

%input_image = input_image + c_x/80;
%figure,surf(sqrt(abs(Freq_Y).^2  + Freq_X.^2))
%A = cos(r);
%figure,imshow(circles,[])
%figure,surf(sqrt(abs(Freq_Y).^2  + Freq_X.^2))
%A = cos(r);
%figure,imshow(circles,[])
