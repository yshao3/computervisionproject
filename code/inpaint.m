function [outputImage,outputImagePatchLabels] = inpaint(inputimage,mask,patchsize,t)
outputImage = inputimage.*mask;
patchbackup = outputImage;
outputImagePatchLabels = mask;

label = 1;
while sum(sum(outputImagePatchLabels==0))>0
% index = 1;
% for i =1:6
    label = label+1;
    [toFill,Hp,rows,cols] = findlocation(outputImage,~outputImagePatchLabels,patchsize);
    toFill = toFill';
% toFill
    targetpatch = outputImage(rows(1):rows(1)+size(toFill,1)-1....
                            ,cols(1):cols(1)+size(toFill,2)-1,:);
% figure(1)
% imshow(targetpatch);
                  
%     index = index+1;
% mostmatchPatch =Hp;
    [mostmatchPatch, shifted] = MatchingSimilarPatches(toFill,targetpatch,patchbackup,t,1);
%     imshow(mostmatchPatch);
    offset = [max(1, rows(1)), max(1, cols(1))];
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
imshow(outputImage);
    outputImagePatchLabels = alphaMask(outputImagePatchLabels, mask*label, offset, mask);
end