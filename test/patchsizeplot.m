orig = load('original');
x = load('testpatchsize2');
img = orig.patch{8,1};
patchsize = [3,5,11,21,51];
figure(1)
subplot(1,2,1); imshow(img);
title('original image');
subplot(1,2,2); imshow(img.*(~mask2));
title('masked image');
figure(2)
for i = 1:5
    res = x.outputimage{i,1};
    subplot(1,5,i); imshow(res);
    name = ['patch size ', num2str(patchsize(i)),'*',num2str(patchsize(i))]
    title(name);  
end