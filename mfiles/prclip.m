function im = prclip(im, bounds)
% This assumes bounds are in the [0 1] range

lowBound = prctile(im(:), bounds(1) * 100);
highBound = prctile(im(:), bounds(2) * 100);
im(im < lowBound) = lowBound;
im(im > highBound) = highBound;