function b=im2col(varargin)
%IM2COL Rearrange image blocks into columns.
%   B = IM2COL(A,[M N],'distinct') rearranges each distinct
%   M-by-N block in the image A into a column of B. IM2COL pads A
%   with zeros, if necessary, so its size is an integer multiple
%   of M-by-N. If A = [A11 A12; A21 A22], where each Aij is
%   M-by-N, then B = [A11(:) A12(:) A21(:) A22(:)]. For 
%   multidimensional (color) images, the operation of IM2COL is
%	equivalent to using it separately for each dimension and then
%	concatenating the outputs along the first dimension (rows).
%
%   B = IM2COL(A,[M N],'distinct',PADMETHOD) pads array A using the
%   specified PADMETHOD.  PADMETHOD can be one of these strings:
%
%       String values for PADMETHOD
%       'circular'    Pads with circular repetition of elements.
%       'replicate'   Repeats border elements of A.
%       'symmetric'   Pads array with mirror reflections of itself. 
%       X (numeric)   Pads using provided value X.
%
%   B = IM2COL(A,[M N],'sliding') converts each sliding M-by-N
%   block of A into a column of B, with no zero padding. B has
%   M*N rows and will contain as many columns as there are M-by-N
%   neighborhoods in A. If the size of A is [MM NN], then the
%   size of B is (M*N)-by-((MM-M+1)*(NN-N+1). Each column of B
%   contains the neighborhoods of A reshaped as NHOOD(:), where
%   NHOOD is a matrix containing an M-by-N neighborhood of
%   A. IM2COL orders the columns of B so that they can be
%   reshaped to form a matrix in the normal way. For example,
%   suppose you use a function, such as SUM(B), that returns a
%   scalar for each column of B. You can directly store the
%   result in a matrix of size (MM-M+1)-by-(NN-N+1) using these
%   calls: 
%
%        B = im2col(A,[M N],'sliding');
%        C = reshape(sum(B),MM-M+1,NN-N+1);
%
%   B = IM2COL(A,[M N]) uses the default block type of
%   'sliding'.
%
%   B = IM2COL(A,'indexed',...) processes A as an indexed image,
%   padding with zeros if the class of A is uint8 or uint16, or 
%   ones if the class of A is double.
%
%   Class Support
%   -------------
%   The input image A can be numeric or logical. The output matrix 
%   B is of the same class as the input image. 
%
%   Example
%   -------
%   Calculate the local mean using a [2 2] neighborhood with zero padding.
%
%       A = reshape(linspace(0,1,16),[4 4])'
%       B = im2col(A,[2 2])
%       M = mean(B)
%       newA = col2im(M,[1 1],[3 3])
%  
%   See also BLKPROC, COL2IM, COLFILT, NLFILTER.
%
%	TODO: Expand to any % overlap.

[a, block, kind, padmethod] = parse_inputs(varargin{:});

if strcmp(kind, 'distinct')
    % Pad A if size(A) is not divisible by block.
    [m,n,p] = size(a);
    mpad = rem(m,block(1)); if mpad>0, mpad = block(1)-mpad; end
    npad = rem(n,block(2)); if npad>0, npad = block(2)-npad; end

	if (isnumeric(padmethod) || islogical(padmethod)),
		aa = padarray(a, [mpad npad 0], padmethod, 'post');
	elseif strcmp(padmethod,'symmetric'),
		aa = padarray(a, [mpad npad 0], 'symmetric', 'post');
    elseif strcmp(padmethod,'circular'),
   		aa = padarray(a, [mpad npad 0], 'circular', 'post');
    elseif strcmp(padmethod,'replicate'),
		aa = padarray(a, [mpad npad 0], 'replicate', 'post');
	else
		% We should never fall into this section of code.  This problem should
		% have been caught in input parsing.
		eid = sprintf('Images:%s:internalErrorUnknownPadMethodType', mfilename);
		msg = sprintf('%s is an unknown padding method type', padmethod);
		error(eid, msg);
	end	
	
% 	aa = mkconstarray(class(a), 0, [m+mpad n+npad]);
%     aa(1:m,1:n) = a;
% 	if (isnumeric(padmethod) || islogical(padmethod)),
% 		aa(m+1:m+mpad,:) = padmethod;
% 		aa(:,n+1:n+npad) = padmethod;
% 	elseif strcmp(padmethod,'symmetric'),
%     	aa(m+1:m+mpad,:) = aa(m:-1:m-mpad+1,:);
% 		aa(:,n+1:n+npad) = aa(:,n:-1:n-npad+1);
%     elseif strcmp(padmethod,'circular'),
%     	aa(m+1:m+mpad,:) = aa(1:mpad,:);
% 		aa(:,n+1:n+npad) = aa(:,1:npad);
%     elseif strcmp(padmethod,'replicate'),
%     	aa(m+1:m+mpad,:) = repmat(aa(m,:), [1 mpad]);
% 		aa(:,n+1:n+npad) = repmat(aa(:,n), [npad 1]);
% 	else
% 		% We should never fall into this section of code.  This problem should
% 		% have been caught in input parsing.
% 		eid = sprintf('Images:%s:internalErrorUnknownPadMethodType', mfilename);
% 		msg = sprintf('%s is an unknown padding method type', pval);
% 		error(eid, msg);
% 	end
    	
    [m,n,p] = size(aa);
    mblocks = m/block(1);
    nblocks = n/block(2);
    pblock = prod(block);
	
    btemp = mkconstarray(class(a), 0, [pblock mblocks*nblocks]);
    b = mkconstarray(class(a), 0, [pblock*p mblocks*nblocks]);
    x = mkconstarray(class(a), 0, [pblock 1]);
    rows = 1:block(1); cols = 1:block(2);
	for iter = 1:p
		for i=0:mblocks-1,
			for j=0:nblocks-1,
				x(:) = aa(i*block(1)+rows,j*block(2)+cols,iter);
				btemp(:,i+j*mblocks+1) = x;
			end
		end
		lastp = (iter - 1) * pblock;
		b(lastp+1:lastp+pblock, :) = btemp;
	end
	
elseif strcmp(kind,'sliding')
    [ma,na,pa] = size(a);
    m = block(1); n = block(2);
    
    if any([ma na] < [m n]) % if neighborhood is larger than image
       b = zeros(m*n,0);
       return
    end
    
    % Create Hankel-like indexing sub matrix.
    mc = block(1); nc = ma-m+1; nn = na-n+1;
    cidx = (0:mc-1)'; ridx = 1:nc;
    t = cidx(:,ones(nc,1)) + ridx(ones(mc,1),:);    % Hankel Subscripts
    tt = zeros(mc*n,nc);
    rows = 1:mc;
    for i=0:n-1,
        tt(i*mc+rows,:) = t+ma*i;
    end
    ttt = zeros(mc*n,nc*nn);
    cols = 1:nc;
    for j=0:nn-1,
        ttt(:,j*nc+cols) = tt+ma*j;
    end
    
    % If a is a row vector, change it to a column vector. This change is
    % necessary when A is a row vector and [M N] = size(A).
	pblock = size(ttt,1);
	b = zeros(pa*pblock,size(ttt,2));
	for iter = 1:pa,
		aa = a(:,:,iter);
		if ndims(aa) == 2 && na > 1 && ma == 1
	      aa = aa(:);
		end
		lastp = (iter - 1) * pblock;
		b(lastp+1:lastp+pblock, :) = aa(ttt);
	end;
    
else
    % We should never fall into this section of code.  This problem should
    % have been caught in input parsing.
    eid = sprintf('Images:%s:internalErrorUnknownBlockType', mfilename);
    msg = sprintf('%s is an unknown block type', kind);
    error(eid, msg);
end

%%%
%%% Function parse_inputs
%%%
function [a, block, kind, padmethod] = parse_inputs(varargin)

iptchecknargin(2,4,nargin,mfilename);

switch nargin
case 2
    if (strcmp(varargin{2},'indexed'))
        eid = sprintf('Images:%s:tooFewInputs', mfilename);
        msg = sprintf('%s: Too few inputs to IM2COL.', upper(mfilename));
        error(eid, msg);
    else
        % IM2COL(A, [M N])
        a = varargin{1};
        block = varargin{2};
        kind = 'sliding';
        padmethod = 0;
    end
    
case 3
    if (strcmp(varargin{2},'indexed'))
        % IM2COL(A, 'indexed', [M N])
        a = varargin{1};
        block = varargin{3};
        kind = 'sliding';
        padmethod = 0;
    else
        % IM2COL(A, [M N], 'kind')
        a = varargin{1};
        block = varargin{2};
        kind = iptcheckstrs(varargin{3},{'sliding','distinct'},mfilename,'kind',3);
        padmethod = 0;
    end
    
case 4
	if (strcmp(varargin{2},'indexed'))
	    % IM2COL(A, 'indexed', [M N], 'kind')
        a = varargin{1};
        block = varargin{3};
        kind = iptcheckstrs(varargin{4},{'sliding','distinct'},mfilename,'kind',4);
        padmethod = 0;
    else
        % IM2COL(A, [M N], 'kind', 'padmethod')
        a = varargin{1};
        block = varargin{2};
        kind = iptcheckstrs(varargin{3},{'sliding','distinct'},mfilename,'kind',3);
		if (~isnumeric(varargin{4})) && (~islogical(varargin{4}))
	        padmethod = iptcheckstrs(varargin{4},{'circular','symmetric','replicate'},mfilename,'padmethod',4);
		end;
	end
case 5
	% IM2COL(A, 'indexed', [M N], 'kind', 'padmethod')
	a = varargin{1};
	block = varargin{3};
	kind = iptcheckstrs(varargin{4},{'sliding','distinct'},mfilename,'kind',4);
	if (~isnumeric(varargin{5})) && (~islogical(varargin{5}))
		padmethod = iptcheckstrs(varargin{5},{'circular','symmetric','replicate'},mfilename,'padmethod',5);
	end;
end

% if (isa(a,'uint8') || isa(a, 'uint16'))
%     padmethod = 0;
% end
