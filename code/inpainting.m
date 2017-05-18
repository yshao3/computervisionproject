% % fill output function
% patch = im2double(imread('../data/jelly.jpg'));
% % patch = patch.*mask;
patch = im2double(imread('../data/basket_png_flipped.png'));
% % patch = im2double(imread('in/strawberries2.jpg'));
% size(patch)
% mask = ones(size(patch,1),size(patch,2));
% mask(55:84,55:84) = zeros(30,30);
% patch1 = patch.*mask;
%imshow(patch);
% patch = im2double(imread('../data/monalisa.jpg'));
patchbackup = patch;
% m = ones(size(patch,1),size(patch,2));
% m(130:160,150:190) = zeros(31,41);
% patch = patch.*m;
size(patch)
close all;


PLOT_X_NUM = 4;
PLOT_Y_NUM = 3;
plotIndex = 1;

% These are the dimensions of the output image. They should be at least as
% big as the dimensions of the input texture.
OUT_IMG_WIDTH = 300;
OUT_IMG_HEIGHT = 400;

% This will be the actual output image (in double RGB format)
outputImage = zeros(OUT_IMG_HEIGHT, OUT_IMG_WIDTH, 3);
% This will be an image that indicates what parts of the output image
% belong to what copy of the input image. A value of zero indicates that
% a pixel is empty, and no patch has been placed on it yet
outputImagePatchLabels = zeros(OUT_IMG_HEIGHT, OUT_IMG_WIDTH);

%% Place the first patch
% simply copy the entire patch onto the output image
outputImage(1:size(patch, 1), 1:size(patch, 2), :) = patch;
% figure(1)
% imshow(outputImage);
% update the label image so that the updated values have a label of "1"
outputImagePatchLabels(1:size(patch, 1), 1:size(patch, 2)) = ones(size(patch, 1), size(patch, 2));
% outputImagePatchLabels(130:160,150:190) = zeros(31,41);
% while any(outputlabel == 0)
label = 1;
s = 9;
while sum(sum(outputImagePatchLabels==0))>0
% index = 1;
% for i =1:6
    label = label+1;
    [toFill,Hp,rows,cols] = findlocation(outputImage,~outputImagePatchLabels,101);
    toFill = toFill';
    targetpatch = outputImage(rows(1):rows(1)+size(toFill,1)-1....
                            ,cols(1):cols(1)+size(toFill,2)-1,:);
imshow(targetpatch);
                  
%     figure(1)
%     hold on;
%     subplot(3,2,index); imshow(outputImage);
%     figure(2)
%     hold on;
%     subplot(3,2,index); imshow(targetpatch);
%     index = index+1;
    [mostmatchPatch, shifted] = MatchingSimilarPatches(toFill,targetpatch,patchbackup,0,1);
%     subplot(5,2,index); imshow(mostmatchPatch);
%     index = index+1;
    offset = [max(1, rows(1)), max(1, cols(1))]
    patchOnBackground = zeros(size(outputImage));
    patchOnBackgroundMask = zeros(size(outputImage, 1), size(outputImage, 2));
    patchOnBackground(offset(1):offset(1)+size(mostmatchPatch, 1)-1, ...
                      offset(2):offset(2)+size(mostmatchPatch, 2)-1, ...
                      :) = mostmatchPatch;
    patchOnBackgroundMask(offset(1):offset(1)+size(mostmatchPatch, 1)-1, ...
                          offset(2):offset(2)+size(mostmatchPatch, 2)-1, ...
                          :) = 1;
    [mask, outputImagePatchLabels] = findseam(patchOnBackground, patchOnBackgroundMask, ...
                outputImage, outputImagePatchLabels, offset, mostmatchPatch);
    outputImage = alphaMask(outputImage, mostmatchPatch, offset, mask);
    outputImagePatchLabels = alphaMask(outputImagePatchLabels, mask*label, offset, mask);
end 
figure(2)
imshow(outputImage);
figure(3)
imagesc(outputImagePatchLabels);
% end