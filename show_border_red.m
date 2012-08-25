% Jason

function res = show_border_red(res,borders,thick_ind)
if nargin<3, thick_ind = 1; end;
if size(res,3)==1,
    res =repmat(res,[1,1,3]);
end

% if nargin==3,
%     borders = bwmorph(borders,'thin');
% %else
% end

if thick_ind==1,
    borders = bwmorph(borders,'dilate');
end

res(:,:,1) = max(res(:,:,1),(borders));
res(:,:,2) = min(res(:,:,2),1-(borders));
res(:,:,3) = min(res(:,:,3),1-(borders));

