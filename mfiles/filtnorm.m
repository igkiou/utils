% Normalize Filter iimpulse response

function f = filtnorm(f) 

f=f-mean(f(:));     % zero-mean

f=f/sum(abs(f(:))); % unity L1 

return