%%%Plot image results

orig = load('original','patch');
load('otherresults');
mask2result = load('mask2results');
mask2 = im2double(imread('../data/inpaintingdata/mask2.png'));
for i = 1:16
    img = orig.patch{i,1};
    res = mask2result.outputimage{i,1};
    figure(2*i-1)
    subplot(1,2,1); imshow(img);
    title('original image');
    subplot(1,2,2); imshow(img.*(~mask2));
    title('masked image');
    figure(2*i)
    subplot(1,5,1); imshow(patch1{i});
    title('Bugeau');  
    subplot(1,5,2); imshow(patch2{i});
    title('herling'); 
    subplot(1,5,3); imshow(patch3{i});
    title('tv'); 
    subplot(1,5,4); imshow(patch4{i});
    title('xu'); 
    subplot(1,5,5); imshow(res);
    title('my');
end