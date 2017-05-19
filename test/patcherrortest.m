orig = load('original');
% x = load('testtolerance');
x = load('testpatchsize2');
load('otherresults');
mask2 = im2double(imread('../data/inpaintingdata/mask2.png'));
num = sum(sum(mask2==1))
figure(1);
img = orig.patch{8,1};
title('error pixel percentage')
xlabel('threshold') % x-axis label
ylabel('percentage of error pixels') % y-axis label
hold on;
for i=1:5
res = x.outputimage{i,1};
res = sqrt(sum((res-img).^2, 3));
y = @(n) sum(sum(res>n))/num;
fplot(@(n) y(n),[0,1]);
end
legend('3*3','5*5','11*11','21*21','51*51')
hold off;
saveas(figure(1),'patchsizeerrorplot')