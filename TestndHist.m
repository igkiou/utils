mRand = rand(100,3);
ve1 = linspace(0,1,257);
ve2 = linspace(0,1,257);
ve3 = linspace(0,1,257);

tic
mndHistc = ndHistc(mRand, ve1, ve2, ve3);
b = toc

tic
%mndHist = ndhist(mRand, ve1, ve2, ve3, ve4, ve5);
a = toc
%all(mndHist(:) == mndHistc(:))

a / b
