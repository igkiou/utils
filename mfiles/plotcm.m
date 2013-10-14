function plotcm(theta, rho, varargin)

plot(theta, rho, varargin{:});
holdSwitch = 0;
if (~ishold)
	hold on;
	holdSwitch = 1;
end;
plot(-theta, rho, varargin{:});
if (holdSwitch),
	hold off;
end;
