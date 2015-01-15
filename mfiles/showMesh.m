function s = showMesh(depth)

s = surf(-depth);
axis image; 
axis off; 
set(s, 'facecolor', [.5 .5 .5], 'edgecolor', 'none'); 
l = camlight; 
rotate3d on;