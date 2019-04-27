function [im_inverse, im_inverse_b] = my_inverse_mb(IMG, H, D0)

% mb for motionblur specified, directly transfer frequency result

% Input（im_f：退化图片，H：退化模型，D0：半径）
% Output（im_inverse：全逆滤波结果，im_inverse_b：半径受限逆滤波）

[M,N] = size(IMG);
% 全逆滤波

IMG_INV = IMG ./ H;
im_inverse_double = real(ifft2(ifftshift(IMG_INV)));
im_inverse = im2uint8(mat2gray(im_inverse_double));

% 半径受限逆滤波

I_m = 1:M; I_n = 1:N;
x = I_m - M/2;
y = N/2 - I_n;
[X,Y] = meshgrid(x,y);
% A = (X.^2 + Y.^2 > D0^2);
A = (abs(H) < D0);
H(A) = 1;

% IMG = fftshift(fft2(img_double)); 已经做过了

IMG_INV_B = IMG ./ H;
im_inverse_b_double = real(ifft2(ifftshift(IMG_INV_B)));
im_inverse_b = im2uint8(mat2gray(im_inverse_b_double));
