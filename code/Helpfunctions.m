
patchOnBackground = imread('in/basket.gif');
patchOnBackground = patchOnBackground(5:20,5:20)
 size(patchOnBackground)
%  figure(1);
%  hold o
 %imshow(patchOnBackground)
 xDerivativeFilter = [-1/2, 0, 1/2];
 yDerivativeFilter = xDerivativeFilter';
 patchOnBackgroundXDerivative = imfilter(patchOnBackground, xDerivativeFilter);
 patchOnBackgroundYDerivative = imfilter(patchOnBackground, yDerivativeFilter);
 overlap = imfilter(patchOnBackground, xDerivativeFilter)>0;
 %getOverlap(outputImagePatchLabels, patch, offset);
 figure;
 subplot(1, 5, 1);
 imshow(overlap);
 subplot(1,3,1), subimage(patchOnBackground)
 subplot(1,3,2), subimage(patchOnBackgroundXDerivative)
 subplot(1,3,3), subimage(patchOnBackgroundYDerivative)