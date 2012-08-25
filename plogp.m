function value = plogp(p)

value = size(p);
for iter = 1:numel(p)
	if p(iter) == 0
		value(iter) = 0;
	else
		value(iter) = p(iter) * log2(p(iter));
	end;
end;