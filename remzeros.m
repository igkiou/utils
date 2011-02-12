%REMZEROS.M  Remove Zeros from Signal 
%
%         In cases when positive values are needed, remzeros removes possibly zero values 
%         and replaces them with smaller image value near zero.
%         (e.g For dividing two vectors or matrices, zeros in the denominator will
%         lead to Inf result. Remzeros fixes that)
%
%         Attention: It is supposed that the signal does not take negative values!

%30/05/04 NTUA CVSP G.E.

function C=remzeros(I);

% if ~isempty(find(I<0))
%     disp(' ');
%     disp('Signal Has Negative Values');
%     disp(' ');
%     return;
% else
z=find(I==0);
if ~isempty(z)
    sortI=sort(I(:));
    I(z)=sortI(length(z)+1);
end;
%end;
C=I;
