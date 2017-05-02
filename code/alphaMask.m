function output = alphaMask(background, overlayedImage, offset, alphaMask)
        xMin = offset(1);
        yMin = offset(2);
        xMax = offset(1)+size(overlayedImage, 1)-1;
        yMax = offset(2)+size(overlayedImage, 2)-1;
        realMask = repmat(alphaMask, 1, 1, size(background, 3));
        %alphaMask
        background(xMin:xMax, yMin:yMax, :) ...
                = background(xMin:xMax, yMin:yMax, :).*(1-realMask) ...
                 + overlayedImage.*realMask;
        output = background;
    end