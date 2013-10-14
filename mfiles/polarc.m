function h = polarc(theta, rho, varargin)

x = rho .* cos(theta);
y = rho .* sin(theta);
h = plot(x, y, varargin{:});
axis equal
