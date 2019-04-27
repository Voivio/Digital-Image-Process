function [img_2] = myAverage(img_1)

size_1 = size(img_1);
h = size_1(1);
w = size_1(2);
img_2 = zeros(h, w);

% 请在下面继续完成均值滤波功能代码

pad = 1;
img_pad = padarray(double(img_1),[pad pad],'replicate','both');
% 'replicate'
mask = [1,1,1;1,1,1;1,1,1];

for i = 1 : h
    for j = 1 : w
        img_2(i,j) = sum(mask .* img_pad(i + pad - 1 : i + pad + 1, j + pad -1 : j + pad + 1 ),'all');
    end
end

img_2 = uint8(floor(img_2/9));

end
