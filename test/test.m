patch = im2double(imread('../data/inpaintingdata/8.png'));
mask = im2double(imread('../data/inpaintingdata/mask2.png'));
% imshow(patch.*~mask)
t = [0,5,10,20];
% t = 10;
outputimage = cell(4);
outputlabel = cell(4);
x = zeros(1,4);
for i = 1:4
x(i) = cputime;
[outputimage{i}, outputlabel{i}] = inpaint(patch, ~mask, 11,t(i));
x(i) = cputime-x(i);
end
save('testtolerance2','outputimage', 'outputlabel','x');