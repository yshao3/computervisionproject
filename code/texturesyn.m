% % fill output function
patch = im2double(imread('../data/basket_png.png'));

patchbackup = patch;
size(patch)
close all;


PLOT_X_NUM = 4;
PLOT_Y_NUM = 3;
plotIndex = 1;

OUT_IMG_WIDTH = 300;
OUT_IMG_HEIGHT = 400;


outputImage = zeros(OUT_IMG_HEIGHT, OUT_IMG_WIDTH, 3);

outputImagePatchLabels = zeros(OUT_IMG_HEIGHT, OUT_IMG_WIDTH);

%% Place the first patch
% simply copy the entire patch onto the output image
outputImage(1:size(patch, 1), 1:size(patch, 2), :) = patch;

outputImagePatchLabels(1:size(patch, 1), 1:size(patch, 2)) = ones(size(patch, 1), size(patch, 2));

label = 1;
while sum(sum(outputImagePatchLabels==0))>0
% index = 1;
% for i =1:6
    label = label+1;
    [toFill,Hp,rows,cols] = findlocation(outputImage,~outputImagePatchLabels,71);
    toFill = toFill';
    targetpatch = outputImage(rows(1):rows(1)+size(toFill,1)-1....
                            ,cols(1):cols(1)+size(toFill,2)-1,:);
    imshow(targetpatch);
                  
    mostmatchPatch = MatchingSimilarPatches(~toFill,targetpatch,patchbackup,0,1);
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