%clear;
close all;

p = 4;
pyra = cell(1,p);
res_pyra = cell(1,p);

origin = imread('demo1.jpg');
pyra{1} = origin;

for i = 1 : p - 1
    [length, width, depth] = size(pyra{i});
    %filter
    iblur = imgaussfilt3(pyra{i},0.5);
    %downsampling
    pyra{i + 1} = imresize(iblur, 0.5, 'nearest');
    %upsampling and interpolation
    res_pyra{i} = mat2gray(double(pyra{i}) - double(imresize(pyra{i + 1}, 2, 'Antialiasing',false)));
    %double and uint8 type problem, no negative values
end
res_pyra{p} = pyra{p};

figure; grid on;
title('the pyramid');
colormap(gray);
for i = 1 : p
    subplot(2, p, i);
    imshow(pyra{i});
    subplot(2, p, p + i);
    imshow(res_pyra{i});
    imwrite(pyra{i}, sprintf('result/pyra_%d.jpg', i));
    imwrite(res_pyra{i}, sprintf('result/res_pyra_%d.jpg', i));
end
