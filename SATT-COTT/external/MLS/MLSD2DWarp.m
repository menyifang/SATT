function [imgo,ifXT,ifYT,fv_sub] = MLSD2DWarp(img,mlsd,q,X,Y,mode,trgtext,srctext)
% MLSD2DWARP  Transforming an image warping a grid of points.
%
% function [imgo,ifv,fv] = MLSD2DWarp(img,mlsd,q,X,Y,mode)
%
%  This function transform an image warping a grid of points at a certain
% step size. An MLSD is required.
%
%  Parameters
%  ----------
% IN:
%  img  = The image to be warped.
%  mlsd = An mlsd.
%  q    = The moved handles (2|3xN points or 4xN segments).
%  X    = The X grid (obtained with meshgrid).
%  Y    = The Y grid (obtained with meshgrid).
%  mode = The interpolation mode: {'cubic','linear','nearest'}. (default='linear')
% OUT:
%  imgo = The warped image.
%  ifv  = The inverse warping.
%  fv   = The warped image points.

% Parsing parameters:
% [img,mlsd,q,X,Y,mode,trgtext] = ParseParams(varargin{:});

% Image info:
[h,w,c] = size(img);
[ht,wt,c] = size(trgtext);
% Generating the grid:
v = [X(:)';Y(:)'];

% Generating the complete grid:
[TX,TY] = meshgrid(1:w,1:h);

% Computing the warp:
sfv = MLSD2DTransform(mlsd,q);

% Computing the displacements:
dxy = v-sfv;
dxT = interp2(X,Y,reshape(dxy(1,:),size(X)),TX,TY);
dyT = interp2(X,Y,reshape(dxy(2,:),size(X)),TX,TY);

% Computing the new (inverse) points:
ifXT = TX+dxT;
ifYT = TY+dyT;
ifXT = ifXT(1:ht,1:wt);
ifYT = ifYT(1:ht,1:wt);
ifv = [ifXT(:),ifYT(:)]';
ifv2 = cat(3,ifXT,ifYT);

% If required computing the direct points:
if nargout>2
    %Moving in the other direction:
    fXT = TX-dxT;
    fYT = TY-dyT;
    fv_ind = [fXT(:),fYT(:)]';
    fv_sub=cat(3,fXT,fYT);
end

% Warping:
tmap = cat(3,ifXT,ifYT);
resamp = makeresampler(mode,'fill');
imgo = tformarray(img,[],resamp,[2 1],[1 2],[],tmap,0);

% ------------------------ LOCAL FUNCTIONS ------------------------

% Parsing of parameters:
function [img,mlsd,q,X,Y,mode] = ParseParams(varargin)

% Number of parameters:
if nargin<5 error('Too few parameters'); end
if nargin>6 error('Too many parameters'); end

% Set up variables:
varnames = {'img','mlsd','q','X','Y','mode'};
for ind=1:nargin
    eval([varnames{ind} ' = varargin{ind} ;']);
end

% Default values:
if nargin<6 mode='linear'; end
