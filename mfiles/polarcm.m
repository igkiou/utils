function polarcm(theta, rho, varargin)

x = rho .* cos(theta);
y = rho .* sin(theta);
plot(x, y, varargin{:});
holdSwitch = 0;
if (~ishold)
	hold on;
	holdSwitch = 1;
end;
plot(x, -y, varargin{:});
if (holdSwitch),
	hold off;
end;
axis equal
