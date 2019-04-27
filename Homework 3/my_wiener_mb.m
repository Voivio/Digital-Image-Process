function im_wiener = my_wiener_mb(IMG, H, K)

% mb for motionblur specified, directly transfer frequency result

PARA = ( conj(H) ./ (abs(H).^2 + K) ); %.^
IMG_EST = PARA .* IMG;

im_wiener_double = real(ifft2(ifftshift(IMG_EST)));
im_wiener = im2uint8(mat2gray(im_wiener_double));
