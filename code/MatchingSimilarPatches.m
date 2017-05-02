function [mostmatchPatch, shifted] = MatchingSimilarPatches(toFill,Patch,targetPatch,t,step)
   [A,B,C] = size(targetPatch);
%     while i+psize(1)-1<= A
%         j = 1;
%         while j+psize(2)-1<=B
            %Initialize the matching similar patches
   x = 1;
   y = 1;
   shifted = [1,1];
   cost = Inf;
   
   while x+size(Patch,1)-1<=A 
       y = 1;
         while y+size(Patch,2)-1<=B
%              costs = Mcosts(Patch,...
%                 targetPatch(x:x+size(Patch,1)-1,y:y+size(Patch,2)-1,:));
             comparepatch = toFill.*targetPatch(x:x+size(Patch,1)-1,y:y+size(Patch,2)-1,:);
%              costs = Mcosts(Patch,comparepatch);
             costs = sqrt(sum((Patch...
                 -comparepatch).^2, 3));
             c = sum(sum(costs,1),2);
             if c < cost & c > t
                shifted = [x,y];
                cost = c;
             end
            y = y+step;
         end
         x = x+step;
   end
   x = shifted(1);
   y = shifted(2);
   mostmatchPatch = targetPatch(x:x+size(Patch,1)-1,y:y+size(Patch,2)-1,:);
%             k = k+1;
%             j = j+step;
%         end
%          k = k+1;
%          i = i+step;
%     end
%     position( all(~position,2), : ) = [];
%     shifted( all(~shifted,2), : ) = [];
%     cost = cost(cost~=0);
%     s(:,:,1) = position;
%     s(:,:,2) = shifted;
%     s(:,:,3) = [cost',zeros(size(cost,2),1)];
    
    