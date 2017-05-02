patch = im2double(imread('in/jelly.jpg'));
patch1 = im2double(imread('in/jelly.jpg'));
mask = ones(size(patch,1),size(patch,2));
mask(55:84,55:84) = zeros(30,30);
psize = [50,50];
patch = patch.*mask;
% These are the dimensions of the output image. They should be at least as
% big as the dimensions of the input texture.
OUT_IMG_WIDTH = 300;
OUT_IMG_HEIGHT = 300;
% This will be the actual output image (in double RGB format)
outputImage = zeros(OUT_IMG_HEIGHT, OUT_IMG_WIDTH, 3);
outputImagePatchLabels = zeros(OUT_IMG_HEIGHT, OUT_IMG_WIDTH);
outputImage(1:size(patch, 1), 1:size(patch, 2), :) = patch;
% patchBackup = patch(1:psize(1),1:psize(2),:);
% update the label image so that the updated values have a label of "1"
outputImagePatchLabels(1:size(patch, 1), 1:size(patch, 2)) = ones(size(patch, 1), size(patch, 2));
figure(1)
imshow(patch)
% s = MatchingSimilarPatches(patch,[5,5],16,5)
[offset, p, s, Ind] = findlocation(patch,psize,5,50,1)
% patchBackup = patch(p(1):p(1)+psize(1)-1,p(2):p(2)+psize(2)-1,:);
figure(2)
imshow(patch(offset(1):offset(1)+49,offset(2):offset(2)+49,:))
figure(3)
imshow(patch(p(1):p(1)+49,p(2):p(2)+49,:))
figure(4)
stem(s(:,1,3));
%prepare new patch
patchOnBackground = zeros(size(outputImage));
patchOnBackgroundMask = zeros(size(outputImage, 1), size(outputImage, 2))
patchOnBackground(offset(1):offset(1)+size(patch, 1)-1, ...
                      offset(2):offset(2)+size(patch, 2)-1,:) = patch1;
patchOnBackgroundMask(offset(1):offset(1)+size(patch, 1)-1, ...
                      offset(2):offset(2)+size(patch, 2)-1, ...
                          :) = 1;
mask = findseam(patchOnBackground, patchOnBackgroundMask, outputImage, ...
        outputImagePatchLabels, offset, patch1);
    
outputImage = alphaMask(outputImage, patch1, offset, mask);
outputImagePatchLabels = alphaMask(outputImagePatchLabels, mask*2, offset, mask);
 figure
    imshow(outputImage)
figure
  imagesc(outputImagePatchLabels)

