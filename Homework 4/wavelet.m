%clear;
close all;

%% parameters define
origin = double(imread('demo2.tif'));
[length, width] = size(origin);
order = 8;
g0 = [0.0322,-0.0126,-0.0992,0.2979,0.8037,0.4976,-0.0296,-0.0758];
sign_arr = (-1) .^ (0 : order - 1);
g1 = (sign_arr) .* g0(end:-1:1);
h0 = g0(end:-1:1);
h1 = g1(end:-1:1);
%checked, all right
h_phi = g0;
h_psi = g1;
h_phi_neg = h0;
h_psi_neg = h1;
p = 3;
result = cell(p, 4);
result_g = cell(p, 4);
recons = cell(1, p);
psnr = zeros(1, p);

%% compute DWT
for i = 1 : p
    if i == 1
        [result{i,1}, result{i,2}, result{i,3}, result{i,4}] = analBank(origin, h_phi_neg, h_psi_neg);
    else
        [result{i,1}, result{i,2}, result{i,3}, result{i,4}] = analBank(result{i-1,1}, h_phi_neg, h_psi_neg);
    end
        recons{i} = synBank(result{i,1}, result{i,2}, result{i,3}, result{i,4}, h_phi, h_psi);
    if i == 1
        mse = mean(mean((recons{i}( 1 + 6 : end - 7, 1 + 6 : end - 7) - origin) .^ 2));
    else
        mse = mean(mean((recons{i}( 1 + 7 : end - 7, 1 + 7 : end - 7) - result{i - 1, 1}) .^ 2));
    end
    psnr(i) = 10 *log10(255^2/mse);
end

%% result output
for i = 1 : p
    result_g{i,1} = mat2gray(result{i,1});
    result_g{i,2} = mat2gray(result{i,2});
    result_g{i,3} = mat2gray(result{i,3});
    result_g{i,4} = mat2gray(result{i,4});
    recons{i} = mat2gray(recons{i});
end

figure; grid on;
title('the wavelet');
for i = 1 : p
    subplot(p, 5, 1 + (i - 1)*5);
    imshow(result_g{i,1});
    subplot(p, 5, 2 + (i - 1)*5);
    imshow(result_g{i,2});
    subplot(p, 5, 3 + (i - 1)*5);
    imshow(result_g{i,3});
    subplot(p, 5, 4 + (i - 1)*5);
    imshow(result_g{i,4});
    subplot(p, 5, 5 + (i - 1)*5);
    imshow(recons{i});
%     imwrite(recons{i}, sprintf('result/recons_%d.jpg', i));
%     imwrite(result_g{i,1}, sprintf('result/re_%d_a.jpg', i));
%     imwrite(result_g{i,2}, sprintf('result/re_%d_h.jpg', i));
%     imwrite(result_g{i,3}, sprintf('result/re_%d_v.jpg', i));
%     imwrite(result_g{i,4}, sprintf('result/re_%d_d.jpg', i));
end

display(psnr);

%% edge detection
% datavalue change in synthesis band
all_black_21 = zeros(size(result{2,1}));
all_black_22 = zeros(size(result{2,2}));
all_black_23 = zeros(size(result{2,3}));
all_black_24 = zeros(size(result{2,4}));
all_black_12 = zeros(size(result{1,2}));
all_black_13 = zeros(size(result{1,3}));
all_black_14 = zeros(size(result{1,4}));


mid1 = synBank(all_black_21, result{2,2},  result{2,3}, result{2,4}, h_phi, h_psi);
det1 = synBank(mid1( 1 + 7 : end - 7, 1 + 7 : end - 7), result{1,2}, result{1,3}, result{1,4}, h_phi, h_psi);
det1 = mat2gray(det1);

mid2 = synBank(all_black_21, all_black_22, result{2,3}, result{2,4}, h_phi, h_psi);
det2 = synBank(mid2( 1 + 7 : end - 7, 1 + 7 : end - 7), all_black_12, result{1,3}, result{1,4}, h_phi, h_psi);
det2 = mat2gray(det2);

% mid3 = synBank(all_black_21, result{2,2}, all_black_23, result{2,4}, h_phi, h_psi);
% det3 = synBank(mid3( 1 + 7 : end - 7, 1 + 7 : end - 7), result{1,2}, all_black_13, result{1,4}, h_phi, h_psi);
% det3 = mat2gray(det3);
%
% mid4 = synBank(result{2,1}, result{2,2}, result{2,3}, all_black_24, h_phi, h_psi);
% det4 = synBank(mid4( 1 + 7 : end - 7, 1 + 7 : end - 7), result{1,2}, result{1,3}, all_black_14, h_phi, h_psi);
% det4 = mat2gray(det4);

figure; grid on;
title('the edge detection');
subplot(121); imshow(det1);
subplot(122); imshow(det2);
% imwrite(det1, 'result/det1.jpg');
% imwrite(det2, 'result/det2.jpg');

%% function defination
function [a, h, v, d] = analBank(img, h_phi_neg, h_psi_neg)
    %operation on rows: conv at rows
    %downsample at columns: keep even columns
    t_hp = downsample(conv2(img, h_psi_neg)', 2, 1)'; %no 'same', just 'full' convolution
    t_lp = downsample(conv2(img, h_phi_neg)', 2, 1)'; %1 for offset
    %operation on columns: conv at columns
    %downsample at rows: keep even rows
    d = downsample(conv2(t_hp', h_psi_neg)', 2, 1);
    v = downsample(conv2(t_hp', h_phi_neg)', 2, 1);
    h = downsample(conv2(t_lp', h_psi_neg)', 2, 1);
    a = downsample(conv2(t_lp', h_phi_neg)', 2, 1);
end

function img_re = synBank(a, h, v, d, h_phi, h_psi)
    %upsample: insert zeros at odd-indexed columns
    %operation on columns: conv at columns
    f1 = conv2(upsample(a,2,1)',h_phi)' + conv2(upsample(h,2,1)',h_psi)';
    f2 = conv2(upsample(v,2,1)',h_phi)' + conv2(upsample(d,2,1)',h_psi)';
    %upsample: insert zeros at odd-indexed rows
    %operation on rows: conv at rows
    img_re = conv2(upsample(f1',2,1)',h_phi) + conv2(upsample(f2',2,1)',h_phi);
end
