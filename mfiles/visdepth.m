% img = visdepth(map,valid)
%
% map = depth / scene map (assumed to be b/w 0 and 100)
% valid = (option) regions where map is valid
%
% Output: RGB image
%
%-- Ayan Chakrabarti <ayanc@ttic.edu>
function img = visdepth(d,vld)

img = dtoc(d,100);
if nargin == 2
  img = bsxfun(@times,img,double(vld == 1));
end;

function I = dtoc(D,max_disp)

mp = jet((max_disp+1)*64);

% Color primaries
CMX = ['f26521'; '01a14b'; '7f3f98'];

C = zeros(3,3);
for i = 1:3
  for j = 1:3
    C(i,j) = hex2dec(CMX(i,2*j-1:2*j))/255;
  end;
end;
mp = mp*C; 

for i = 1:3
  mp(:,i) = mp(:,i)/max(mp(:,i));
end;

I = max(0,min(max_disp,D)); I = 1+max_disp-D;
I = round(64*I);
I = ind2rgb(I,mp);

G = mod(min(D/max_disp,1),1/25)*25; G = max(G,1-G);
G = (2*G-1).^0.25; G = G*0.1+0.9;

I = bsxfun(@times,G,I);
