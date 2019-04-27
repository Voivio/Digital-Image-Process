%% 请大家完成两个空域滤波算法函数 myAverage.m、myMedian.m，然后将本主程序中的变量
%% filename设置为'circuit'，运行main_filter.m，即可得到滤波后结果
%%
clc;
clear;
close all;

%% 读取图像
filename = 'circuit'; % 受到椒盐噪声污染的电路板X射线图像
im = imread([filename, '.jpg']);
n = 4; % 滤波次数

%% 将图像进行均值滤波
im_a = myAverage(im);

im_inf_a = im_a;
for i = 1 : n - 1
    fprintf('%d average\n', i + 1);
    im_inf_a = myAverage(im_inf_a);
end

%因为pad所以最后变成了0？
%可是不pad最后尺寸会变的原来越小，也许换一种pad方法会更好？

%% 将图像进行中值滤波
im_m = myMedian(im);

im_inf_m = im_m;
for i = 1 : n - 1
    fprintf('%d median\n', i + 1);
    im_inf_m = myMedian(im_inf_m);
end

%% 将结果保存到当前目录下的result文件夹下
% imwrite(im_a, sprintf('result/_%s_a.jpg', filename));
% imwrite(im_m, sprintf('result/_%s_m.jpg', filename));
% imwrite(im_inf_a, sprintf('result/_%s_inf_a%d.jpg', filename, n));
% imwrite(im_inf_m, sprintf('result/_%s_inf_m%d.jpg', filename, n));

%% 显示结果
figure(1);
subplot(231); imshow(im); title('原图'); axis on
subplot(232); imshow(im_a); title('均值滤波'); axis on
subplot(233); imshow(im_m); title('中值滤波'); axis on
subplot(234); imshow(im_inf_a); title(strcat(num2str(n),'次均值滤波')); axis on
subplot(235); imshow(im_inf_m); title(strcat(num2str(n),'次中值滤波')); axis on
