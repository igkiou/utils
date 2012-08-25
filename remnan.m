%REMNAN.M  Remove Not A Number (NaN) Values from Signal
%
%      Applied on an Input NxM Signal (Image) removes the NaN
%      values and replaces them with a local mean value. 
%
%      See also NANMEAN, REMINF

%10/10/03 G.E. NTUA

function J=remnan(I)

[m,n]=size(I);
[i,j]=find(isnan(I)==1);

if ~isempty(i)
    Ip=[zeros(1,n+2); zeros(m,1) I zeros(m,1) ;zeros(1,n+2)];
    I(i,j)=nanmean(nanmean(Ip(i:i+2,j:j+2)));
end;
J=I;