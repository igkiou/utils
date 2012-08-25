function polarc(theta, rho, varargin)

x = rho .* cos(theta);
y = rho .* sin(theta);
plot(x, y, varargin{:});
axis equal
