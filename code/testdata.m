patch = cell(17);
% mask = cell(4);
patch{1} = im2double(imread('../data/inpaintingdata/1.png'));
patch{2} = im2double(imread('../data/inpaintingdata/2.png'));
patch{3} = im2double(imread('../data/inpaintingdata/3.png'));
patch{4} = im2double(imread('../data/inpaintingdata/4.png'));
patch{5} = im2double(imread('../data/inpaintingdata/5.png'));
patch{6} = im2double(imread('../data/inpaintingdata/6.png'));
patch{7} = im2double(imread('../data/inpaintingdata/7.png'));
patch{8} = im2double(imread('../data/inpaintingdata/8.png'));
patch{9} = im2double(imread('../data/inpaintingdata/9.png'));
patch{10} = im2double(imread('../data/inpaintingdata/10.png'));
patch{11} = im2double(imread('../data/inpaintingdata/11.png'));
patch{12} = im2double(imread('../data/inpaintingdata/12.png'));
patch{13} = im2double(imread('../data/inpaintingdata/13.png'));
patch{14} = im2double(imread('../data/inpaintingdata/14.png'));
patch{15} = im2double(imread('../data/inpaintingdata/15.png'));
patch{16} = im2double(imread('../data/inpaintingdata/16.png'));
patch{17} = im2double(imread('../data/inpaintingdata/17.png'));
% mask{1} = im2double(imread('../data/inpaintingdata/mask1.png'));
% mask = im2double(imread('../data/inpaintingdata/mask2.png'));
% mask = im2double(imread('../data/inpaintingdata/mask3.png'));
mask = im2double(imread('../data/inpaintingdata/mask4.png'));
% imshow(patch.*~mask)
% t = [5,10,20,50];
% % t = 10;
% patchsize = [5,11,21,51];
outputimage = cell(17);
outputlabel = cell(17);
x = zeros(1,17);
for i = 1:17
x(i) = cputime;
[outputimage{i}, outputlabel{i}] = inpaint(patch{i}, ~mask, 11, 0);
x(i) = cputime-x(i);
end

save('mask4results','outputimage', 'outputlabel','x');