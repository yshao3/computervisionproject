orig = load('original');
% x = load('testtolerance');
x = load('mask2results');
load('otherresults');
mask2 = im2double(imread('../data/inpaintingdata/mask2.png'));
num = sum(sum(mask2==1));
for i=1:16
img = orig.patch{i,1};
figure(i);
title('error pixel percentage')
xlabel('threshold') % x-axis label
ylabel('percentage of error pixels') % y-axis label
hold on;
res = x.outputimage{i,1};
res = sqrt(sum((res-img).^2, 3));
y = @(n) sum(sum(res>n))/num;
fplot(@(n) y(n),[0.01,1]);

res = patch1{i,1};
res = sqrt(sum((res-img).^2, 3));
y = @(n) sum(sum(res>n))/num;
fplot(@(n) y(n),[0.01,1]);

res = patch2{i,1};
res = sqrt(sum((res-img).^2, 3));
y = @(n) sum(sum(res>n))/num;
fplot(@(n) y(n),[0.01,1]);

res = patch3{i,1};
res = sqrt(sum((res-img).^2, 3));
y = @(n) sum(sum(res>n))/num;
fplot(@(n) y(n),[0.01,1]);

res = patch4{i,1};
res = sqrt(sum((res-img).^2, 3));
y = @(n) sum(sum(res>n))/num;
fplot(@(n) y(n),[0.01,1]);
legend('my','bugeau','herling','tv','xu')
hold off;
saveas(figure(i),['image', num2str(i),'.jpg'])
end
