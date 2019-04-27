function im_wiener = my_wiener(img, H, K)

img_double = mat2gray(img,[0,255]);

IMG = fftshift(fft2(img_double));
PARA = ( conj(H) ./ (abs(H).^2 + K) ); %.^
IMG_EST = PARA .* IMG;

im_wiener_double = real(ifft2(ifftshift(IMG_EST)));
im_wiener = im2uint8(mat2gray(im_wiener_double));
