function [img_2] = myHisteq(img_1, n)

size_1 = size(img_1);
h = size_1(1);
w = size_1(2);
img_2 = zeros(h, w);

% 请在下面继续完成直方图均衡化功能代码

all = h * w;
count = zeros(1,256);
cdf = zeros(1,256);

for i = 1 : h
    for j = 1 : w
        count(img_1(i,j) + 1) = count(img_1(i,j) + 1) + 1;
    end
end

count = count/all;

for i = 1 : 256
    for j = 1 : i
        cdf(i) = cdf(i) + count(j);
    end
end

for i = 1 : h
    for j = 1 : w
        img_2(i,j) = floor(floor(n * cdf(img_1(i,j) + 1)) * (256/(n-1)));
    end
end

img_2 = uint8(img_2);

end