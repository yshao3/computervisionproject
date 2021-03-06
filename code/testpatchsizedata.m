patch = im2double(imread('../data/inpaintingdata/8.png'));
mask = im2double(imread('../data/inpaintingdata/mask2.png'));
% imshow(patch.*~mask)
% t = 10;
patchsize = [3,5,11,21,51];
outputimage = cell(5);
outputlabel = cell(5);
x = zeros(1,5);
for i = 1:5
x(i) = cputime;
[outputimage{i}, outputlabel{i}] = inpaint(patch, ~mask, patchsize(i),0);
x(i) = cputime-x(i);
end
save('testpathsize2','outputimage', 'outputlabel','x');