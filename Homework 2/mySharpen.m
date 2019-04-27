function [img_2] = mySharpen(img_1)

size_1 = size(img_1);
h = size_1(1);
w = size_1(2);
img_2 = zeros(h, w);

% 请在下面继续完成图像锐化功能代码
pad = 1;
img_pad = padarray(double(img_1),[pad pad],0,'both');
mask = [-1,-1,-1;-1,8,-1;-1,-1,-1];
self = [0,0,0;0,1,0;0,0,0];
kernel = mask + self;

for i = 1 : h
    for j = 1 : w
        img_2(i,j) = sum(kernel .* img_pad(i + pad - 1 : i + pad + 1, j + pad -1 : j + pad + 1 ),'all');
    end
end

img_2 = uint8(floor(img_2));


end
