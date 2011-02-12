function newIndScaleMatrix = transformIndicesScale(indScaleMatrix, T, XData, YData)

scale = sqrt(det(T.tdata.T));
ind1 = indScaleMatrix(1,:)';
ind2 = indScaleMatrix(2,:)';
x = ind2;
x = x + XData(1) - 1;
y = ind1;
y = y + YData(1) - 1;
[u v] = tforminv(T,x,y);
newind2 = u;
newind1 = v;
newIndScaleMatrix(1,:) = newind1'; 
newIndScaleMatrix(2,:) = newind2';
newIndScaleMatrix(3,:) = indScaleMatrix(3,:)/scale;