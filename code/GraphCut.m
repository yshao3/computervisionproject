patch = im2double(imread('../data/jelly.jpg'));
% mask = ones(size(patch,1),size(patch,2));
% mask(55:84,55:84) = zeros(30,30);
% patch = patch.*mask;
% patch = im2double(imread('in/basket_png_flipped.png'));
% patch = im2double(imread('in/strawberries2.jpg'));
size(patch)
% mask = ones(size(patch,1),size(patch,2));
% mask(55:84,55:84) = zeros(30,30);
% patch1 = patch.*mask;
%imshow(patch);
patch = im2double(imread('../data/monalisa.jpg'));
patch1 = im2double(imread('../data/wyeth.jpg'));
close all;


PLOT_X_NUM = 4;
PLOT_Y_NUM = 3;
plotIndex = 1;

% These are the dimensions of the output image. They should be at least as
% big as the dimensions of the input texture.
OUT_IMG_WIDTH = 800;
OUT_IMG_HEIGHT = 800;

% This will be the actual output image (in double RGB format)
outputImage = zeros(OUT_IMG_HEIGHT, OUT_IMG_WIDTH, 3);

% This will be an image that indicates what parts of the output image
% belong to what copy of the input image. A value of zero indicates that
% a pixel is empty, and no patch has been placed on it yet
outputImagePatchLabels = zeros(OUT_IMG_HEIGHT, OUT_IMG_WIDTH);

%% Place the first patch
% simply copy the entire patch onto the output image
outputImage(1:size(patch1, 1), 1:size(patch1, 2), :) = patch1;
% update the label image so that the updated values have a label of "1"
outputImagePatchLabels(1:size(patch1, 1), 1:size(patch1, 2)) = ones(size(patch1, 1), size(patch1, 2));
[toFill,Hp,rows,cols] = impainting(outputImage,outputImagePatchLabels,21);
imshow(toFill)
% outputImagePatchLabels(55:84,55:84) = zeros(30,30);
subplot(PLOT_X_NUM, PLOT_X_NUM, plotIndex);
plotIndex = plotIndex + 1;

imshow(outputImage)
%figure
subplot(PLOT_X_NUM, PLOT_X_NUM, plotIndex);
plotIndex = plotIndex + 1;

imagesc(outputImagePatchLabels)
patchBackup = patch;
% for label=2:10
 %% Find the offset for the next patch. By offset, we just mean the coordinates of the new patch, so an offset of [1, 1] represents placing a patch on the top left corner.
    % known bug: when the offset is [2 2], graphcut algorithm goes into
    % infinite loop
    %offset = [50, 100];
% for k = 1:5   
%     figure;
%     imshow(outputImage);
%     % Let the user select the location where to put the next image patch
% %     offset = int32(ginput(1))
%      % the above gives [x y], but we want [y x], so we swap the entries
% %     offset = [offset(2) offset(1)];
% % %     
%     [off, p, s, Ind] = findlocation(outputImage,[50,50],5,50,1);
%     off
%     offset = off(1,:);
%     while isequal(offset, updated)
%         k = k+1;
%         offset = off(k,:);
%     end
% for label = 2:2
%     offset = off(label-1,:);
%     patch = patchBackup(p(label-1,1):min(p(label-1,1)+49,size(patchBackup,1)),...
%                     p(label-1,2):min(p(label-1,2)+49, size(patchBackup,2)),:);
%    %patch = patchBackup;
% %     patch = patchBackup(p(1):end,p(2):end,:);
%     
%     % If the offset causes the image to get off-screen, clip the patch so
%     % that is fits entirely on-screen
%     patch = patch(max(1,offset(1))-offset(1)+1 : min(size(outputImage,1),offset(1)+size(patch, 1)-1)-offset(1)+1, ...
%                   max(1,offset(2))-offset(2)+1 : min(size(outputImage,2),offset(2)+size(patch, 2)-1)-offset(2)+1, ...
%                   :);
%     
%     % adjust the offset for the clipped patch, if necessary
%     offset = [max(1, offset(1)), max(1, offset(2))];
%     
%     %offset = [100 1]
%     
%     close all;
%     
%     plotIndex = 1;
% 
%     %% plot the offset second patch
%     patchOnBackground = zeros(size(outputImage));
%     patchOnBackgroundMask = zeros(size(outputImage, 1), size(outputImage, 2));
%     patchOnBackground(offset(1):offset(1)+size(patch, 1)-1, ...
%                       offset(2):offset(2)+size(patch, 2)-1, ...
%                       :) ...
%                       = patch;
%     patchOnBackgroundMask(offset(1):offset(1)+size(patch, 1)-1, ...
%                           offset(2):offset(2)+size(patch, 2)-1, ...
%                           :) = 1;
%     subplot(PLOT_X_NUM, PLOT_X_NUM, plotIndex);
%     plotIndex = plotIndex + 1;
%     imshow(patchOnBackground);
% 
%     %% Find the seam (i.e. compute the mask) for the second patch
%     % Find the overlapping region
%     disp('Finding the seam...');
% 
%     %mask = ones(size(patch, 1), size(patch, 2));
%     % The output mask is a binary 2d image the size of the output image
%     % that uses a 1 to inticate that a pixel should come from the new,
%     % offset texture, and a 0 to indicate that a pixel should come from the
%     % old current output texture
%     mask = findSeam(patchOnBackground, patchOnBackgroundMask, outputImage);
% 
%     disp('Finding the seam...done.');
% 
% 
%     %% Place the new patch with the calculated offset and seam
% 
%     %mask = round(rand(size(patch, 1), size(patch, 2)));
%     
%     % The alphaMask function uses the mask computed above as a transparency
%     % mask for the new patch, combining the new patch with the current background
%     % image
%     outputImage = alphaMask(outputImage, patch, offset, mask);
%     outputImagePatchLabels = alphaMask(outputImagePatchLabels, mask*label, offset, mask);
% 
%     %maskLogical = mask == ones(size(patch, 1), size(patch, 2));
%     %outputImage((1+offset(1)):(size(patch, 1)+offset(1)), (1+offset(2)):(size(patch, 2)+offset(2)), :) = patch .* repmat(mask, 1, 1, 3);
% 
%     %outputImagePatchLabels((1+offset(1)):(size(patch, 1)+offset(1)), (1+offset(2)):(size(patch, 2)+offset(2))) = 2*mask;
% 
%     % Show the output image and the seam so that we can save them, or add a
%     % new patch.
%     figure
%     imshow(outputImage)
%     figure
%     imagesc(outputImagePatchLabels)
% end
% end
% end
% Repeatedly let the user place new patches. After
% being done, the user can save the output image through the MATLAB imshow interface and quit the program using CTRL-C.
for label=2:1000
    %% Find the offset for the next patch. By offset, we just mean the coordinates of the new patch, so an offset of [1, 1] represents placing a patch on the top left corner.
    % known bug: when the offset is [2 2], graphcut algorithm goes into
    % infinite loop
    %offset = [50, 100];
    
    figure;
    imshow(outputImage);
    % Let the user select the location where to put the next image patch
    offset = int32(ginput(1))
     % the above gives [x y], but we want [y x], so we swap the entries
    offset = [offset(2) offset(1)];
% %     
 
    patch = patchBackup;
    
    % If the offset causes the image to get off-screen, clip the patch so
    % that is fits entirely on-screen
    patch = patch(max(1,offset(1))-offset(1)+1 : min(size(outputImage,1),offset(1)+size(patch, 1)-1)-offset(1)+1, ...
                  max(1,offset(2))-offset(2)+1 : min(size(outputImage,2),offset(2)+size(patch, 2)-1)-offset(2)+1, ...
                  :);
    
    % adjust the offset for the clipped patch, if necessary
    offset = [max(1, offset(1)), max(1, offset(2))];
    
    %offset = [100 1]
    
    close all;
    
    plotIndex = 1;

    %% plot the offset second patch
    patchOnBackground = zeros(size(outputImage));
    patchOnBackgroundMask = zeros(size(outputImage, 1), size(outputImage, 2));
    patchOnBackground(offset(1):offset(1)+size(patch, 1)-1, ...
                      offset(2):offset(2)+size(patch, 2)-1, ...
                      :) ...
                      = patch;
    patchOnBackgroundMask(offset(1):offset(1)+size(patch, 1)-1, ...
                          offset(2):offset(2)+size(patch, 2)-1, ...
                          :) = 1;
    subplot(PLOT_X_NUM, PLOT_X_NUM, plotIndex);
    plotIndex = plotIndex + 1;
    imshow(patchOnBackground);

    %% Find the seam (i.e. compute the mask) for the second patch
    % Find the overlapping region
    disp('Finding the seam...');

    %mask = ones(size(patch, 1), size(patch, 2));
    % The output mask is a binary 2d image the size of the output image
    % that uses a 1 to inticate that a pixel should come from the new,
    % offset texture, and a 0 to indicate that a pixel should come from the
    % old current output texture
    %mask = findSeam(patchOnBackground, patchOnBackgroundMask, outputImage);
    [mask,outputImagePatchLabels] = findseam(patchOnBackground, patchOnBackgroundMask, ...
                outputImage, outputImagePatchLabels, offset, patch);
    disp('Finding the seam...done.');


    %% Place the new patch with the calculated offset and seam

    %mask = round(rand(size(patch, 1), size(patch, 2)));
    
    % The alphaMask function uses the mask computed above as a transparency
    % mask for the new patch, combining the new patch with the current background
    % image
    outputImage = alphaMask(outputImage, patch, offset, mask);
    outputImagePatchLabels = alphaMask(outputImagePatchLabels, mask*label, offset, mask);

    %maskLogical = mask == ones(size(patch, 1), size(patch, 2));
    %outputImage((1+offset(1)):(size(patch, 1)+offset(1)), (1+offset(2)):(size(patch, 2)+offset(2)), :) = patch .* repmat(mask, 1, 1, 3);

    %outputImagePatchLabels((1+offset(1)):(size(patch, 1)+offset(1)), (1+offset(2)):(size(patch, 2)+offset(2))) = 2*mask;

    % Show the output image and the seam so that we can save them, or add a
    % new patch.
    figure
    imshow(outputImage)
    figure
    imagesc(outputImagePatchLabels)
end