function Xr = xyz2rgb(X)
% Rec. ITU-R BT.709-3 xyz2rgb
Y = [
    3.24479 -1.537150 -0.498535
    -0.969256 1.875992 0.041556
    0.055648 -0.204043 1.057311];

Xr = reshape((Y*[reshape(X(:,:,1),1,size(X,1)*size(X,2));reshape(X(:,:,2),1,size(X,1)* ...
                                                  size(X,2));reshape(X(:,:,3),1, ...
                                                  size(X,1)*size(X,2))])',size(X));
