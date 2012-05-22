% figure;
% d = 5; a = -[-Inf -3:0.2:0];
% D = 40; x = [1:D];
% for i=1:length(a)
%     plot(sigmoid(x,a(i),d)); hold on;
%     pause;
% end;


% Sigmoid function
% returns
%   Y = 1 ./ (1 + EXP(X)) ;
%
%   Remark:: 
%     Useful properties of the vl_sigmoid are:
%
%     -  1 - SIGMOID(X) = SIGMOID(-X)
%     -  Centered sigmoid: 2 * SIGMOID(X) - 1 ;
%     -  SIGMOID(X) = (EXP(X/2) - EXP(X/2)) / (EXP(X/2) + EXP(X/2))

function y = sigmoid(x,x0,l,a)

if nargin<2, x0=0; end;
if nargin<3, l=1; end;
if nargin<4, a=1; end;

y = 1./(1+a*exp(l*(x-x0)));

% y = y./max(y);
