function [H, IMG_BLUR, img_blurred] = motionblur(img, a, b, T, sigma)

[M,N] = size(img);
b = -b;

I_m = 1 : M;
I_n = 1 : N;
x = I_m - M/2;
y = N/2 - I_n; 
[X, Y] = meshgrid(x,y);
Z = pi * ( a * X + b * Y );
H = ( T ./ Z ) .* sin(Z) .* exp(-1j * Z);

A = (Z == 0);
H(A) = 1; % divided by zero

% img_double = mat2gray(img,[0,255]);
% IMG = fftshift(fft2(img_double));
IMG = fftshift(fft2(img));
NOISE = fftshift(fft2(sigma * randn(M,N)));
% NOISE = zeros(N);
IMG_BLUR = IMG .* H + NOISE;

img_blurred_double = real(ifft2(ifftshift(IMG_BLUR)));
img_blurred = im2uint8(mat2gray(img_blurred_double));

% img_blurred = imnoise(img_blurred,'gaussian',0,sigma);

for i = 1:1
end
