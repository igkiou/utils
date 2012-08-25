% 2D Binomial smoothing filter

function I = binom2(I,k);

[mROW,nCOL]=size(I);

if (k > 0)
    kern1 = [0.25,0.50,0.25];
    kern2 = convn(kern1,kern1');

    binFil = kern2;
    % else
    %     binFil = [1];
    % end;
    for i = 2:k
        binFil = conv2(kern2,binFil);
    end;
    I = conv2(I,binFil);
    I = I(1+k:mROW+k,1+k:nCOL+k);
end;
