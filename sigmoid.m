% figure;
% d = 5; a = -[-Inf -3:0.2:0];
% D = 40; x = [1:D];
% for i=1:length(a)
%     plot(sigmoid(x,a(i),d)); hold on;
%     pause;
% end;



function y = sigmoid(x,l,xo)

if nargin<3, xo=0; end;
if nargin<2, l=1; end;

y = 1./(1+exp(l*(x-xo)));

y = y./max(y);
