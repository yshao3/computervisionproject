 % This distance will be important when calculating the edge costs
 function distanceBetweentwopathes = Mcosts(outputImage,patchOnBackground)
        Mcosts = zeros(size(outputImage));
        EuclideanD = [3,4,2];
        for i = 1:3
            Mcosts(:,:,i) = (outputImage(:,:,i)-patchOnBackground(:,:,i))...
            .*EuclideanD(i);
        end
        distanceBetweentwopathes = sqrt(sum(Mcosts.^2, 3));