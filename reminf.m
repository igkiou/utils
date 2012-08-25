%REMINF    Remove Infinite (Inf) Values from Signal
%
% The function applied on the Input NxM Signal (Image) removes the Inf
% values and replaces them with the maximum existing real value or the local median value. 

%10/10/03 G.E. NTUA
%27/07/05 add median choise

function J=reminf(I,option);
if nargin==1
    option='max';
end;
i=find((I==Inf)|(I==-Inf));
switch option
    case 'max'
        %i=isinf(I);
        I(i)=min(I(:));
        I(i)=max(I(:));
    case 'med'
        interp = medfilt2(I,[5,5]);
        I(i) = interp(i);
    otherwise 
        J=I; error('wrong choise, choose "max" or "med"');
        return;
end;
J=I;
