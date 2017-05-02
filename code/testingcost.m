%Mcost difference test%



% patch = im2double(imread('../data/wyeth.jpg'));
patch = im2double(imread('../data/monalisa.jpg'));
offset = [200,100];
OUT_IMG_WIDTH = 500;
OUT_IMG_HEIGHT = 800;
label = 2;
outputImage = zeros(OUT_IMG_HEIGHT, OUT_IMG_WIDTH, 3);
outputImagePatchLabels = zeros(OUT_IMG_HEIGHT, OUT_IMG_WIDTH);
outputImage(1:size(patch, 1), 1:size(patch, 2), :) = patch;
outputImagePatchLabels(1:size(patch, 1), 1:size(patch, 2)) = ones(size(patch, 1), size(patch, 2));
mostmatchPatch = patch;
patchOnBackground = zeros(size(outputImage));
patchOnBackgroundMask = zeros(size(outputImage, 1), size(outputImage, 2));
patchOnBackground(offset(1):offset(1)+size(mostmatchPatch, 1)-1, ...
                      offset(2):offset(2)+size(mostmatchPatch, 2)-1, ...
                      :) = mostmatchPatch;
patchOnBackgroundMask(offset(1):offset(1)+size(mostmatchPatch, 1)-1, ...
                          offset(2):offset(2)+size(mostmatchPatch, 2)-1, ...
                          :) = 1;
[mask1, outputImagePatchLabels1] = findseam(patchOnBackground, patchOnBackgroundMask, ...
                outputImage, outputImagePatchLabels, offset, mostmatchPatch);
[mask2, outputImagePatchLabels2] = findseamOri(patchOnBackground, patchOnBackgroundMask, ...
                outputImage, outputImagePatchLabels, offset, mostmatchPatch);
    outputImage1 = alphaMask(outputImage, mostmatchPatch, offset, mask1);
    outputImagePatchLabels1 = alphaMask(outputImagePatchLabels1, mask1*label, offset, mask1);

    outputImage2 = alphaMask(outputImage, mostmatchPatch, offset, mask2);
    outputImagePatchLabels2 = alphaMask(outputImagePatchLabels2, mask2*label, offset, mask2);
figure(1)
subplot(1,2,1); imshow(outputImage1);
subplot(1,2,2); imshow(outputImage2);
figure(2)
subplot(1,2,1); imagesc(outputImagePatchLabels1);
subplot(1,2,2); imagesc(outputImagePatchLabels2);
