function rgb = getrgb(img)
  
  l = load('-ascii','cmf.txt');
  v = load('-ascii','calib.txt'); v = v(:);
  l = l([13:2:73],[2:4]); %color matching
  l = l./repmat(v,[1 3]); 
  l = l / max(l(:));
  xyz1 = zeros(size(img,1),size(img,2),3);
  
  for i = 1:3
    for j = 1:size(l,1)
      xyz1(:,:,i) = xyz1(:,:,i) + l(j,i)*img(:,:,j);
    end;
  end;
  rgb = xyz2rgb(xyz1);
  if (any(rgb(:) < 0)),
	  rgb = rgb - min(rgb(:));
  end;
  rgb = rgb .^ (1 / 4);

function Xr = xyz2rgb(X)
Y = [
    3.40479 -1.537150 -0.498535
    -0.969256 1.875992 0.041556
    0.055648 -0.204043 1.057311];

Xr = reshape((Y*[reshape(X(:,:,1),1,size(X,1)*size(X,2));reshape(X(:,:,2),1,size(X,1)* ...
                                                  size(X,2));reshape(X(:,:,3),1, ...
                                                  size(X,1)*size(X,2))])',size(X));
