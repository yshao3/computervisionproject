function [mask, outputImagePatchLabels] = findseam(patchOnBackground, patchOnBackgroundMask, ...
                outputImage, outputImagePatchLabels, offset, patch)
    % Uses graphcuts to find the seam to apply to a new patch given the
    % offset. The input "patchOnBackground" should be an image the size of
    % the output image with the patch image as a subimage at the desired
    % offset

        % compute derivatives (used for the graphcut cost)
         size(patchOnBackground)
%         size(patchOnBackgroundMask)
%         size(outputImage)
        xDerivativeFilter = [-1/2, 0, 1/2];
        yDerivativeFilter = xDerivativeFilter';
        
        patchOnBackgroundXDerivative = imfilter(patchOnBackground, xDerivativeFilter);
        patchOnBackgroundYDerivative = imfilter(patchOnBackground, yDerivativeFilter);
        outputImageXDerivative = imfilter(outputImage, xDerivativeFilter);
        outputImageYDerivative = imfilter(outputImage, yDerivativeFilter);
        
        overlap = patchOnBackgroundMask & (outputImagePatchLabels>0);
        %getOverlap(outputImagePatchLabels, patch, offset);
%         figure;
%         subplot(1, 5, 1);
%         imshow(overlap);

        % Find the edges of the overlap region. We'll set graphcut constraints on
        % these edges
        innerEdgeFilter = [0 -1 0; -1 4 -1; 0 -1 0];
        outerEdgeFilter = -innerEdgeFilter;
        overlapOuterEdges = imfilter(overlap, outerEdgeFilter)>0;
        constraintA = (outputImagePatchLabels>0) & overlapOuterEdges; % The pixels that are required to pertain to image A (the old patch)
        constraintB = patchOnBackgroundMask & overlapOuterEdges; % The pixels that are required to pertain to image B (the new patch)

        pixelsToInputToCutAlgorithmMask = constraintA | constraintB | overlap;

        %outputImageOuterEdges = imfilter(outputImagePatchLabels>0, outerEdgeFilter)>0;
        %figure;
%         subplot(1, 5, 2);
%         imshow(overlapOuterEdges);
%         %figure;
%         subplot(1, 5, 3);
%         imshow(pixelsToInputToCutAlgorithmMask);
% 
%         subplot(1, 5, 4);
%         imshow(constraintA);
% 
%         subplot(1, 5, 5);
%         imshow(constraintB);

        % Set up table that maps pixels in the output image to node indices
        % in the graphcut algorithm
        graphCutInputCount = 0;
        graphCutIndexTable = zeros(size(outputImage)); % This table will map a position in the output image to the corresponding index in the graphcut array
        for i = 1:size(outputImage, 1)
            for j = 1:size(outputImage, 2)
                if pixelsToInputToCutAlgorithmMask(i,j)
                    graphCutInputCount = graphCutInputCount + 1;
                    graphCutIndexTable(i, j) = graphCutInputCount;
                end
            end
        end
        % Set graphcut infinity constraints at the non-overlapping portions
        % of the images for the graphcut algorithm
        graphCutInputCount2 = 0;
        nodeCosts = zeros(2, graphCutInputCount);
        for i = 1:size(outputImage, 1)
            for j = 1:size(outputImage, 2)
                if pixelsToInputToCutAlgorithmMask(i,j)
                    graphCutInputCount2 = graphCutInputCount2 + 1;
                    newColumn = [0; 0];
                    if (constraintA(i,j)==1)
                        newColumn = [0;inf];
                    elseif (constraintB(i,j)==1)
                        newColumn = [inf;0];
                    end
                    nodeCosts(:, graphCutInputCount2) = newColumn;
                end
            end
        end
        
        loopIndex = 0;
        %disp('tik')
        %numGraphCutEdges = sum(sum(rightNeighboring)) + sum(sum(bottomNeighboring));
        
        % boolean arrays denoting whether or not a pixel to be used in the
        % graphcut graph has a right or bottom neighboring pixel that will also be part of
        % the graphcut graph
        rightNeighboring = pixelsToInputToCutAlgorithmMask & imfilter(pixelsToInputToCutAlgorithmMask, [0; 0; 1]);
        bottomNeighboring = pixelsToInputToCutAlgorithmMask & imfilter(pixelsToInputToCutAlgorithmMask, [0 0 1]);
        
        % This distance will be important when calculating the edge costs
%         Mcosts = zeros(size(outputImage));
%         EuclideanD = [3,4,2];
%         for i = 1:3
%             Mcosts(:,:,i) = (outputImage(:,:,i)-patchOnBackground(:,:,i))...
%             .*EuclideanD(i);
%         end
        distanceBetweenOutputImageAndPatchOnBackground = Mcosts(outputImage,patchOnBackground);
%         distanceBetweenOutputImageAndPatchOnBackground = sqrt(sum((outputImage-patchOnBackground).^2, 3));
        
        % This sum of adjacent distances will be important when calculating
        % the edge costs
        vertFilterOfDistanceBetweenOutputImageAndPatchOnBackground = imfilter(distanceBetweenOutputImageAndPatchOnBackground, [0;1;1]);
        horFilterOfDistanceBetweenOutputImageAndPatchOnBackground = imfilter(distanceBetweenOutputImageAndPatchOnBackground, [0 1 1]);
        
        % These derivatives will be important when calculating
        % the edge costs
        normOutputImageYDerivative = sqrt(sum(outputImageYDerivative.^2, 3));
        normPatchOnBackgroundYDerivative = sqrt(sum(patchOnBackgroundYDerivative.^2, 3));
        normOutputImageXDerivative = sqrt(sum(outputImageXDerivative.^2, 3));
        normPatchOnBackgroundXDerivative = sqrt(sum(patchOnBackgroundXDerivative.^2, 3));
        
        % These denominators use the derivatives above and will be important when calculating
        % the edge costs. In order to avoid divide by zero issues, we add a
        % small value to these denominators, although the paper doesn't
        % address this issue.
        verticalDenominator = (1/10000)+imfilter(normOutputImageYDerivative + normPatchOnBackgroundYDerivative, [0; 1; 1]);
        verticalResult = vertFilterOfDistanceBetweenOutputImageAndPatchOnBackground ./ verticalDenominator;
        horizontalDenominator = (1/10000)+imfilter(normOutputImageXDerivative + normPatchOnBackgroundXDerivative, [0 1 1]);
        horizontalResult = horFilterOfDistanceBetweenOutputImageAndPatchOnBackground ./ horizontalDenominator;

        % We now construct the sparse edge matrix
        
        % Process horizontal edges
        indices = find(rightNeighboring)';
        graphCutEdgeIndicesI = graphCutIndexTable(indices);
        graphCutEdgeIndicesJ = graphCutIndexTable(indices+1);
        graphCutEdgeValues = verticalResult(indices);
        
        % Add vertical edges
        indices = find(bottomNeighboring)';
        graphCutEdgeIndicesI = [graphCutEdgeIndicesI graphCutIndexTable(indices)];
        graphCutEdgeIndicesJ = [graphCutEdgeIndicesJ graphCutIndexTable(indices+size(pixelsToInputToCutAlgorithmMask, 1))];
        graphCutEdgeValues = [graphCutEdgeValues horizontalResult(indices)];
        
        % This is a legacy 'for' loop that I had to replace with the
        % vectorized version for speed
        % for IND = indices
        %     [i, j] = ind2sub(size(pixelsToInputToCutAlgorithmMask),IND);
        %     loopIndex = loopIndex + 1;
        %     graphCutEdgeValues(loopIndex) = ...
        %         (sqrt(sum((outputImage(i, j, :)-patchOnBackground(i, j, :)).^2)) ...
        %         + sqrt(sum((outputImage(i, j+1, :)-patchOnBackground(i, j+1, :)).^2))) ...
        %          / (sqrt(sum(outputImageXDerivative(i, j, :).^2)) ...
        %            + sqrt(sum(outputImageXDerivative(i, j+1, :).^2)) ...
        %            + sqrt(sum(patchOnBackgroundXDerivative(i, j, :).^2)) ...
        %            + sqrt(sum(patchOnBackgroundXDerivative(i, j+1, :).^2)));
        % end

        %disp('tok')
        % construct the sparse edges from the weights and connections
        % specified above
        graphCutEdges = sparse(graphCutEdgeIndicesI, graphCutEdgeIndicesJ, graphCutEdgeValues, graphCutInputCount, graphCutInputCount);
        %disp('tok')

        % Run Graphcut algorithm
        %BK_BuildLib;
        % Load Graphcut library
        BK_LoadLib;

        size(graphCutEdges)
        size(nodeCosts)

        % Compute the graph cut using the graph cut library
        disp('Computing graph cut...');
        hinc = BK_Create(graphCutInputCount,2*graphCutInputCount);
        BK_SetNeighbors(hinc,graphCutEdges);
        BK_SetUnary(hinc,nodeCosts);
        e_inc = BK_Minimize(hinc);
        graphCutLabels = BK_GetLabeling(hinc)-1;
        disp('Computing graph cut...done.');

        % Based on the computed graph cut, create and output an appropriate
        % mask (this will represent the seam)
        mask = ones(size(patch, 1), size(patch, 2));
        for i = 1:size(patch, 1)
            for j = 1:size(patch, 2)
                if pixelsToInputToCutAlgorithmMask(i+offset(1)-1,j+offset(2)-1)
                    graphCutIndex = graphCutIndexTable(i+offset(1)-1,j+offset(2)-1);
                    mask(i, j) = graphCutLabels(graphCutIndex);
                end
            end
        end
    end
    