function y = dilation2(x,g,gcen,bval)
%DILATION2 2D fixed-support dilation of signal matrix by SE matrix.
% Y=DILATION2(X,G,GCEN,BVAL) is the fixed-support dilation
% of 2D signal array X by the 2D SE array G. Size(Y)=Size(X).
% GCEN is 2-pt vector with indexes of desired center of G.
% BVAL is the desired value for all needed signal boundaries.
% No checking of validity of values/dimensions of X or G.
% The supports of X and G are assumed non-empty.

% P. Maragos -- 22 Jan. 1997 (rename it "dilation": 9 dec 1999)
%--------------------------------------------------------
if nargin ~= 4, error('Needs 4 input arguments'), end
gcen_r = gcen(1);
gcen_c = gcen(2);
[r,c] = find(~isnan(g));
gcard = length(r);
if all(all(g == 0 | isnan(g)))	% Flat SE
   for n=1:gcard
      h = c(n)-gcen_c;	% right horiz (=pos col) shift
      v = gcen_r-r(n);	% down vert (=pos row) shift
      if n == 1
         y=shift2(x,h,v,bval);
      else
         y=max(y,shift2(x,h,v,bval));
      end
   end
else				% Non-Flat SE
   for n=1:gcard
      h = c(n)-gcen_c;	% right horiz (=pos col) shift
      v = gcen_r-r(n);	% down vert (=pos row) shift
      if n == 1
         y=shift2(x,h,v,bval)+g(r(n),c(n));
      else
         y=max(y,shift2(x,h,v,bval)+g(r(n),c(n)));
      end
   end
end

function y = shift2(x,h,v,bval)
%SHIFT2 Shifts a 2D signal matrix by a vector in Cartesian plane.
% Y=SHIFT2(X,H,V,BVAL) is the shifted version 
% of the 2D array X along the plane vector (H,V).
% H is right positive shift. V is upward positive shift.
% Y(m,n)=X(m-H,n-V). SIZE(Y)=SIZE(X).
% All coordinates are Cartesian. Hence, to shift 
% in Matrix coordinates we need a shift by (H,-V).
% BVAL is boundary value replacing the shifted-out samples.

%	P. Maragos -- 22 Jan. 1997
%------------------------------------------------
if h == 0 &&  v == 0		% No shift
	y = x;
	return
end
[xr,xc] = size(x);
ah = abs(h);		% abs horizontal shift
av = abs(v);       	% abs vertical shift
A = ones(xr+av,xc+ah)*bval;	% Extended working array		
if (h >= 0 && v >= 0)
			A(1:xr,1+ah:xc+ah) = x;
			y =  A(1+av:xr+av,1:xc);
			return
end
if (h < 0 && v >= 0)
			A(1:xr,1:xc) = x;
			y = A(1+av:xr+av,1+ah:xc+ah);
			return
end
if (h >= 0 && v < 0)
			A(1+av:xr+av,1+ah:xc+ah) = x;
			y = A(1:xr,1:xc);
			return
end
if (h < 0 && v < 0)
			A(1+av:xr+av,1:xc) = x;
			y = A(1:xr,1+ah:xc+ah);
			return
end


