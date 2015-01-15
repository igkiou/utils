function placeLabels(arg1, arg2, arg3)

if (nargin == 3),
	fig = arg1;
	coords = arg2;
	labels = arg3;
elseif (nargin == 2),
	fig = gcf;
	coords = arg1;
	labels = arg2;
else
	error('Incorrect program call.');
end;

[M N] = size(labels);
if (M == 1),
	numLabels = N;
elseif (N == 1),
	numLabels = M;
else
	error('LABELS must be a vector (1xN or Mx1).');
end;

[M N] = size(coords);
if ((M == numLabels) && (N == 2)),
	coords = coords';
elseif ((N ~= numLabels) || (M ~= 2)),
	error('COORDS and LABELS must have the same length.');
end;

figure(fig);
hold on;
for iter = 1:numLabels,
	text(coords(1, iter),coords(2, iter), sprintf('%g',labels(iter)), 'FontSize', 15,'Color','k');
end;
