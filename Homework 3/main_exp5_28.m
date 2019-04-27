%% 请大家完成:
% 全逆滤波/半径受限逆滤波函数 my_inverse.m
% 维纳滤波函数 wiener.m 
%% 运行 main_exp5_28.m 获得滤波后的效果

clc;
clear;
close all;

%% 课本图 5.28
% 读取图片
im = imread('demo-1.jpg');   % 原始图像 480x480 uint8

%% 图像退化（大气湍流模型）
% Output（H：退化模型， im_f：退化后图片）
[H, im_f] = atmosph(im);        

%% 全逆滤波，半径受限逆滤波
D0 = 60;
% Input（im_f：退化图片，H：退化模型，D0：半径）
% Output（im_inverse：全逆滤波结果，im_inverse_b：半径受限逆滤波）
[im_inverse, im_inverse_b] = my_inverse(im_f, H, D0);  

% for r = 0 : 0.01 : 0.9
%     D0 = floor(r * 240);
%     fprintf('D0 = %d = %f * 240\n\n',D0,r);
%     [~, im_inverse_b] = my_inverse(im_f, H, D0);
%     imwrite(im_inverse_b, sprintf('atmobestD0/im_inv_%d.jpg',D0));
% end


%% 维纳滤波
K = 0.001;
% Input（im_f：退化图片，H：退化模型，K：维纳滤波常数）
im_wiener = my_wiener(im_f, H, K);



%% 保存结果
% imwrite(im_f, sprintf('result/im_f_%f.jpg',K));
% imwrite(im_inverse, sprintf('result/im_inverse_%f.jpg',K));
% imwrite(im_inverse_b, sprintf('result/im_inverse_b_%f.jpg',K));
% imwrite(im_wiener, sprintf('result/im_wiener_%f.jpg',K));
 
%% 显示结果
figure(1); 
subplot(231); imshow(im); title('原图'); axis on
subplot(232); imshow(im_f); title(sprintf('大气湍流(k=%d)',K)); axis on
subplot(233); imshow(im_inverse); title('全逆滤波'); axis on
subplot(234); imshow(im_inverse_b); title('半径受限的逆滤波'); axis on
subplot(235); imshow(im_wiener); title('维纳滤波'); axis on