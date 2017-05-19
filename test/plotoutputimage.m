mask2result = load('mask2results');
for i=1:16
    res = mask2result.outputimage{i,1};
    figure(i)
    imshow(res);
    saveas(figure(i),['image-mask2-',num2str(i),'.jpg'])
end