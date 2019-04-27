%% �������������ֵ�㷨���� myNearest.m��myBilinear.m��myCubic.m��Ȼ�󽫱��������еı���
%% filename����Ϊ��ֵͬ��'lenna'��'cameraman'��'building'��������main.m�����ɵõ���ֵ���
%%
clc; 
clear;
close all;

%%
ratio_1 = 0.3; % ��������1
ratio_2 = 3;   % ��������2
filename = 'lenna'; %����ͼ��1
% filename = 'cameraman'; %����ͼ��2
% filename = 'building'; %����ͼ��3

im = imread([filename, '.jpg']);
[row, col, channel] = size(im); %�õ�ͼ��ߴ�
im_center = im(floor(row*3/8):floor(row*5/8), floor(col*3/8):floor(col*5/8), :); %��ȡ�м�ͼ��飬����ͼ��Ŵ�

%% ��ͼ�񳤿�����Ϊԭͼ�� ratio_1 (<1)��
im1_n = myNearest(im, ratio_1);
im1_b = myBilinear(im, ratio_1);
im1_c = myBicubic(im, ratio_1);
% im1_n = imresize(im, ratio_1, 'nearest', 'antialiasing',false);
% im1_b2 = imresize(im, ratio_1, 'bilinear','antialiasing',false);
% im1_c = imresize(im, ratio_1, 'bicubic','antialiasing',false);

%% ��ͼ�񳤿�����Ϊԭͼ�� ratio_2 (>1)��
im2_n = myNearest(im_center, ratio_2);
im2_b = myBilinear(im_center, ratio_2);
im2_c = myBicubic(im_center, ratio_2);
% im2_n = imresize(im_center, ratio_2, 'nearest');
% im2_b = imresize(im_center, ratio_2, 'bilinear');
% im2_c = imresize(im_center, ratio_2, 'bicubic');

%% ��������浽��ǰĿ¼�µ�result�ļ�����
imwrite(im1_n, sprintf('result/%s%.1fn.jpg', filename, ratio_1));
imwrite(im1_b, sprintf('result/%s%.1fb.jpg', filename, ratio_1));
imwrite(im1_c, sprintf('result/%s%.1fc.jpg', filename, ratio_1));
imwrite(im2_n, sprintf('result/%s%.1fn.jpg', filename, ratio_2));
imwrite(im2_b, sprintf('result/%s%.1fb.jpg', filename, ratio_2));
imwrite(im2_c, sprintf('result/%s%.1fc.jpg', filename, ratio_2));

%% ��ʾ���
figure(1); 
subplot(221); imshow(im); title('ԭͼ'); axis on
subplot(222); imshow(im1_n); title('������ڲ�ͼ��'); axis on
subplot(223); imshow(im1_b); title('˫�����ڲ�ͼ��'); axis on
subplot(224); imshow(im1_c); title('˫�����ڲ�ͼ��'); axis on

figure(2);
subplot(221); imshow(im_center); title('ԭͼ'); axis on
subplot(222); imshow(im2_n); title('������ڲ�ͼ��'); axis on
subplot(223); imshow(im2_b); title('˫�����ڲ�ͼ��'); axis on
subplot(224); imshow(im2_c); title('˫�����ڲ�ͼ��'); axis on