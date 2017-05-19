function [mostmatchPatch, shifted] = MatchingSimilarPatches(toFill,Patch,targetPatch,t,step)
   [A,B,C] = size(targetPatch);
   x = 1;
   y = 1;
   shifted = [1,1];
   cost = Inf;
   
   while x+size(Patch,1)-1<=A 
       y = 1;
         while y+size(Patch,2)-1<=B
             target = targetPatch(x:x+size(Patch,1)-1,y:y+size(Patch,2)-1,:);
             if sum(find(sum(target,3)==0))~=0
                    y = y+step;
                    continue
             end
             comparepatch = (1-toFill).*target;
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
    