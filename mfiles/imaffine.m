function [J XData YData T] = imaffine(I,varargin)

rotangle = 0;
scale = 1;
xtrans = 0;
ytrans = 0;

for argCount = 1:2:length(varargin)
	eval(sprintf('%s = varargin{argCount + 1};',varargin{argCount}));
end;

sc = scale * cos(rotangle);
ss = scale * sin(rotangle);

A = [ sc -ss; ss  sc; xtrans  ytrans];

T = maketform('affine', A);
[J XData YData] = imtransform(I, T);