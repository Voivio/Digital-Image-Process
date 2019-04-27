%% 请大家完成:
% 由运动模糊和加性噪声污染的退化函函数 motionblur.m
% 全逆滤波/半径受限逆滤波函数 my_inverse.m
% 维纳滤波函数 wiener.m
%% 运行 main_exp5_29.m 获得滤波后的效果

clc;
clear;
close all;

%% 课本 5.29
% 读取图片
im = imread('demo-2.jpg');   % 原始图像 688x688 uint8

%% 图像退化（运动模糊+高斯噪声）
sigma = 100;
a = 0.1; % x displacement
b = 0.1; % y displacement
T = 1; % shutter speed
[H,IMG1_F ,im1_f] = motionblur(im, a, b, T, sigma*0.3);        % 噪声方差=0.01
[~,IMG2_F ,im2_f] = motionblur(im, a, b, T, sigma*0.1);
[~,IMG3_F ,im3_f] = motionblur(im, a, b, T, sigma*0.00001);        % H：退化模型

%% 全逆滤波，半径受限逆滤波
D0 = 0.1;    % 半径
% [~, im1_inverse_b] = my_inverse(im1_f, H, D0);
% [~, im2_inverse_b] = my_inverse(im2_f, H, D0);
% [~, im3_inverse_b] = my_inverse(im3_f, H, D0);
[~, im1_inverse_b] = my_inverse_mb(IMG1_F, H, D0); %mb for motionblur specified, directly transfer frequency result
[~, im2_inverse_b] = my_inverse_mb(IMG2_F, H, D0);
[~, im3_inverse_b] = my_inverse_mb(IMG3_F, H, D0);
% [im1_inverse, ~] = my_inverse(im1_f, H, D0);
% [im2_inverse, ~] = my_inverse(im2_f, H, D0);
% [im3_inverse, ~] = my_inverse(im3_f, H, D0);

% for r = 0.001 : 0.001 : 0.1
%     fprintf('r = %f\n',r);
%     [~, im3_inverse_b] = my_inverse_mb(IMG3_F, H, r);
%     imwrite(im3_inverse_b, sprintf('bestD0/im3_inv_%f.jpg',r));
% end


%% 维纳滤波
K = 0.0051;
% im1_wiener = my_wiener(im1_f, H, 0.01);
% im2_wiener = my_wiener(im2_f, H, 0.002);
% im3_wiener = my_wiener(im3_f, H, 0.0005);
im1_wiener = my_wiener_mb(IMG1_F, H, 0.01);
im2_wiener = my_wiener_mb(IMG2_F, H, 0.002);
im3_wiener = my_wiener_mb(IMG3_F, H, 0.0005);

% TO FIND BEST PARAMETER
% for r = 0.000001 : 0.000001 : 0.0001
%     r
%     im3_wiener = my_wiener(im3_f, H, r);
%     imwrite(im3_wiener, sprintf('bestK/im2_wie_%f.jpg',r));
% end

%% 保存结果
% imwrite(im1_f, sprintf('result/im1_f.jpg'));
% imwrite(im2_f, sprintf('result/im2_f.jpg'));
% imwrite(im3_f, sprintf('result/im3_f.jpg'));
% imwrite(im1_inverse_b, sprintf('result/im1_inverse_b.jpg'));
% imwrite(im2_inverse_b, sprintf('result/im2_inverse_b.jpg'));
% imwrite(im3_inverse_b, sprintf('result/im3_inverse_b.jpg'));
% imwrite(im1_wiener, sprintf('result/im1_wiener.jpg'));
% imwrite(im2_wiener, sprintf('result/im2_wiener.jpg'));
% imwrite(im3_wiener, sprintf('result/im3_wiener.jpg'));

%% 显示结果
figure(1);
subplot(331); imshow(im1_f); title('运动模糊+加性噪声(sigma)'); axis on
subplot(332); imshow(im1_inverse_b); title('逆滤波结果'); axis on
subplot(333); imshow(im1_wiener); title('维纳滤波结果'); axis on
subplot(334); imshow(im2_f); title('运动模糊+加性噪声(sigma*0.1)'); axis on
subplot(335); imshow(im2_inverse_b); title('逆滤波结果'); axis on
subplot(336); imshow(im2_wiener); title('维纳滤波结果'); axis on
subplot(337); imshow(im3_f); title('运动模糊+加性噪声(sigma*0.00001)'); axis on
subplot(338); imshow(im3_inverse_b); title('逆滤波结果'); axis on
subplot(339); imshow(im3_wiener); title('维纳滤波结果'); axis on
