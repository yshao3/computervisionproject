% function [offset, p, s, Ind]= findlocation(patch, psize, t, step, n)
%     s = MatchingSimilarPatches(patch,psize,t,step);
%     [sortedX,sortingIndices] = sort(s(:,1,3),'descend');
%     for i=1:n
%         Ind(i) = sortingIndices(i);
%         offset(i,:) = s(Ind(i),:,1);
%         p(i,:) = s(Ind(i),:,2);
%     end
%     [val,Ind] = max(s(:,1,3));
%     offset = s(Ind,:,1);
%     p = s(Ind,:,2);
function [toFill,Hp,rows,cols]=findlocation(origImg,mask,psz)
%% error check
mask(mask>0) = 1;
if ~ismatrix(mask); error('Invalid mask'); end;
if sum(sum(mask~=0 & mask~=1))>0; error('Invalid mask'); end;
if mod(psz,2)==0; error('Patch size psz must be odd.'); end;

fillRegion = mask;

origImg = double(origImg);
img = origImg;
ind = img2ind(img);
sz = [size(img,1) size(img,2)];
sourceRegion = ~fillRegion;

% Initialize isophote values
[Ix(:,:,3), Iy(:,:,3)] = gradient(img(:,:,3));
[Ix(:,:,2), Iy(:,:,2)] = gradient(img(:,:,2));
[Ix(:,:,1), Iy(:,:,1)] = gradient(img(:,:,1));
Ix = sum(Ix,3)/(3*255); Iy = sum(Iy,3)/(3*255);
temp = Ix; Ix = -Iy; Iy = temp;  % Rotate gradient 90 degrees

% Initialize confidence and data terms
C = double(sourceRegion);
D = repmat(-.1,sz);
iter = 1;
% Visualization stuff
if nargout==4
  fillMovie(1).cdata=uint8(img); 
  fillMovie(1).colormap=[];
  origImg(1,1,:) = [0, 255, 0];
  iter = 2;
end

% Seed 'rand' for reproducible results (good for testing)
rand('state',0);

% Loop until entire fill region has been covered
% while any(fillRegion(:))
  % Find contour & normalized gradients of fill region
  fillRegionD = double(fillRegion); % Marcel 11/30/05
  dR = find(conv2(fillRegionD,[1,1,1;1,-8,1;1,1,1],'same')>0);
  
  [Nx,Ny] = gradient(double(~fillRegion)); % Marcel 11/30/05
 %[Nx,Ny] = gradient(~fillRegion);         % Original
  N = [Nx(dR(:)) Ny(dR(:))];
  N = normr(N);  
  N(~isfinite(N))=0; % handle NaN and Inf
  
  % Compute confidences along the fill front
  for k=dR'
    Hp = getpatch(sz,k,psz);
    q = Hp(~(fillRegion(Hp))); % fillRegion?????????????????
    C(k) = sum(C(q))/numel(Hp);
  end
  
  % Compute patch priorities = confidence term * data term
  D(dR) = abs(Ix(dR).*N(:,1)+Iy(dR).*N(:,2)) + 0.001;
  priorities = C(dR).* D(dR);
  
  % Find patch with maximum priority, Hp
  [~,ndx] = max(priorities(:));
  p = dR(ndx(1));
  [Hp,rows,cols] = getpatch(sz,p,psz);
  toFill = fillRegion(Hp);
  toFill = toFill(1:min(size(origImg,1),size(toFill,1)),1:min(size(origImg,2),size(toFill,2)));
  
%---------------------------------------------------------------------
% Returns the indices for a 9x9 patch centered at pixel p.
%---------------------------------------------------------------------
function [Hp,rows,cols] = getpatch(sz,p,psz)
% [x,y] = ind2sub(sz,p);  % 2*w+1 == the patch size
w=(psz-1)/2; p=p-1; y=floor(p/sz(1))+1; p=rem(p,sz(1)); x=floor(p)+1;
rows = max(x-w,1):min(x+w,sz(1));
cols = (max(y-w,1):min(y+w,sz(2)))';
Hp = sub2ndx(rows,cols,sz(1));

%---------------------------------------------------------------------
% Converts the (rows,cols) subscript-style indices to Matlab index-style
% indices.  Unforunately, 'sub2ind' cannot be used for this.
%---------------------------------------------------------------------
function N = sub2ndx(rows,cols,nTotalRows)
X = rows(ones(length(cols),1),:);
Y = cols(:,ones(1,length(rows)));
N = X+(Y-1)*nTotalRows;


%---------------------------------------------------------------------
% Converts an indexed image into an RGB image, using 'img' as a colormap
%---------------------------------------------------------------------
function img2 = ind2img(ind,img)
for i=3:-1:1, temp=img(:,:,i); img2(:,:,i)=temp(ind); end;


%---------------------------------------------------------------------
% Converts an RGB image into a indexed image, using the image itself as
% the colormap.
%---------------------------------------------------------------------
function ind = img2ind(img)
s=size(img); ind=reshape(1:s(1)*s(2),s(1),s(2));