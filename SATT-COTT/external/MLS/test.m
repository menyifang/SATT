%%

% Reading an image:
srctext = imread('owl1-text.png');
trgtext = imread('owl2-text.png');
srcimg = imread('owl1-watercolor.png');
srcsize = size(srctext);
trgsize = size(trgtext);
maxsize = [max(srcsize(1),trgsize(1)) max(srcsize(2),trgsize(2)) 3];
fillsize = [maxsize(1)-srcsize(1) maxsize(2)-srcsize(2)];
srcimg = padarray(srcimg,fillsize,'replicate','post');
% The step size:
% step = 15;
step = min(min(srcsize(1:2)),min(trgsize(1:2)))/30;
% Requiring the pivots:
f=figure; imshow(srctext);
p = getpoints;
close(f);
% load p.mat;
% Requiring the new pivots:
f=figure; imshow(trgtext); hold on; plotpointsLabels(p,'r.');
q = getpoints;
close(f);
% load q.mat;
% Generating the grid:
[X,Y] = meshgrid(1:step:size(srcimg,2),1:step:size(srcimg,1));
gv = [X(:)';Y(:)'];

% Generating the mlsd:
mlsd = MLSD2DpointsPrecompute(p,gv,'affine');

% The warping can now be computed:
[imgo,ifXT,ifYT,fv_sub] = MLSD2DWarp(srcimg,mlsd,q,X,Y,'linear',trgtext,srctext);
fv_sub=round(fv_sub);
ifv_sub = cat(3,ifXT,ifYT);
ifv_sub=round(ifv_sub);

imgo = imgo(1:trgsize(1),1:trgsize(2),:);
% Plotting the result:
figure(1); imshow(imgo); hold on; plotpoints(q,'r.');
% %%
% ans=trgtextCur;
% ifv_sub=round(ifv_sub);
% for i=1:size(trgtextCur,1)
%    for j=1:size(trgtextCur,2)
%       if ifv_sub(i,j,1)>0&&ifv_sub(i,j,1)<=size(srcimgCur,2)&&ifv_sub(i,j,2)>0&&ifv_sub(i,j,2)<=size(srcimgCur,1)
%           ans(i,j,:)=srcimgCur(ifv_sub(i,j,2),ifv_sub(i,j,1),:);
%       end
%    end
% end
% imshow(ans);
%%

R=srctext(:,:,1);G=srctext(:,:,2);B=srctext(:,:,3);
srcmask=((B-R)>250&(B-G)>250);  % 提取绿色条件是G分量与R、B分量差值大于设定
R=trgtext(:,:,1);G=trgtext(:,:,2);B=trgtext(:,:,3);
trgmask=((B-R)>250&(B-G)>250);  % 提取绿色条件是G分量与R、B分量差值大于设定
% Avoid sample out of boundary positions
fv_sub(:,:,1) = clamp(fv_sub(:,:,1), 1, size(trgtext,2));
fv_sub(:,:,2) = clamp(fv_sub(:,:,2), 1, size(trgtext,1));
trguse=zeros(trgsize(1),trgsize(2));
for i=1:size(srctext,1)
   for j=1:size(srctext,2)
      if ~isnan(fv_sub(i,j,2))&&~isnan(fv_sub(i,j,1))&& srcmask(i,j)==1 && trgmask(fv_sub(i,j,2),fv_sub(i,j,1))==1
          if trguse(fv_sub(i,j,2),fv_sub(i,j,1),:)==0
          ans(fv_sub(i,j,2),fv_sub(i,j,1),:)=srcimg(i,j,:);
          trguse(fv_sub(i,j,2),fv_sub(i,j,1))=trguse(fv_sub(i,j,2),fv_sub(i,j,1))+1;
          end
      end
   end
end
figure(2);imshow(ans);
ans=im2double(ans);
[trgstructPyr, ~] = create_img_pyramid(ans, optS);
%%
outputpath= 'results/';

for i=1:10
   imwrite(trgstructPyr{i}, sprintf('%s\\structImage-%d.png',outputpath,i)); 
end

%% 
%The step size:
step = 15;

% Reading an image:
img = imread('cat2-watercolor.png');

% Requiring the pivots:
f=figure; imshow(img);
p = getpoints;
close(f);

% Requiring the new pivots:
f=figure; imshow(img); hold on; plotpointsLabels(p,'r.');
q = getpoints;
close(f);

% Generating the grid:
[X,Y] = meshgrid(1:step:size(img,2),1:step:size(img,1));
gv = [X(:)';Y(:)'];

% Generating the mlsd:
mlsd = MLSD2DpointsPrecompute(p,gv);

% The warping can now be computed:
imgo = MLSD2DWarp(img,mlsd,q,X,Y);

% Plotting the result:
figure; imshow(imgo); hold on; plotpoints(q,'r.');
