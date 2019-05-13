%% defining required elements

rice = imread('rice.tif');
bolbs= imread('bolbs.tif');
dowels = imread('dowels.tif');

r = 40;
se_rr = ones(2 * r + 1, 2 * r + 1);
x = -r : r;
y = -r : r;
[X, Y] = meshgrid(x, y);
se_cir = ones(2 * r + 1, 2 * r + 1);
se_cir(X.^2 + Y.^2 > r^2) = 0;

%% top-hatting

shade = dilationG(erosionG(rice, se_cir, true), se_cir, true);
rice_tp = mat2gray(rice - shade); % $f - f \circ b$

%using otsu method to segment the image
counts = imhist(rice_tp);
mask = otsuthresh(counts);
rice_seg = imbinarize(rice_tp, mask);

figure;
subplot(121); imshow(rice_tp);
subplot(122); imshow(rice_seg);

%% Granulometry

r = 5;
x = -r : r;
y = -r : r;
[X, Y] = meshgrid(x, y);
se_cir = ones(2 * r + 1, 2 * r + 1);
se_cir(X.^2 + Y.^2 > r^2) = 0;

% Morphological smoothing
% opening and then closing
dowels_open_sm = dilationG(erosionG(dowels, se_cir, true), se_cir, true);
dowels_sm = erosionG(dilationG(dowels_open_sm, se_cir, true), se_cir, true);

dowels_open = cell(1,5);
figure;
for i = 1 : 5
    r = (i + 1) * 5;
    x = -r : r;
    y = -r : r;
    [X, Y] = meshgrid(x, y);
    se_cir = ones(2 * r + 1, 2 * r + 1);
    se_cir(X.^2 + Y.^2 > r^2) = 0;
    dowels_open{i} = dilationG(erosionG(dowels_sm, se_cir, true), se_cir, true);
    subplot(2,3,i); imshow(dowels_open{i});
end

%% texture

% code for searching the proper radium
r_max = 60;
count = zeros(1, floor(r_max/2));

for r = 1 : 2 : r_max
    fprintf('current r: %d\n', r)
    x = -r : r;
    y = -r : r;
    [X, Y] = meshgrid(x, y);
    se_cir = ones(2 * r + 1, 2 * r + 1);
    se_cir(X.^2 + Y.^2 > r^2) = 0;

    bolbs_open = mat2gray(dilationG(erosionG(bolbs, se_cir, true), se_cir, true),[0 255]);
    count(ceil(r/2)) = sum(bolbs_open(:));
end

figure;
plot(1:2:r_max, count);
plot(1:2:r_max - 2, diff(count));
r = max(diff(count(5:end)));

% dish se

% r = 27;
% x = -r : r;
% y = -r : r;
% [X, Y] = meshgrid(x, y);
% se_cir = ones(2 * r + 1, 2 * r + 1);
% se_cir(X.^2 + Y.^2 > r^2) = 0;

% hexagon se
r = 30;
half = floor((r * sind(60)));
temp = zeros(2 * half + 1);
N = 6;
t = 0: 2*pi/N :2*pi;
x = r * sin(t) + half; y = r * cos(t) + half;
hx = double(roipoly(temp, x, y));

bolbs_close = erosionG(dilationG(bolbs, se_cir, true), se_cir, true);

% dish se

% r = 60;
% x = -r : r;
% y = -r : r;
% [X, Y] = meshgrid(x, y);
% se_cir = ones(2 * r + 1, 2 * r + 1);
% se_cir(X.^2 + Y.^2 > r^2) = 0;

% hexagon se
r = 60;
half = floor((r * sind(60)));
temp = zeros(2 * half + 1);
N = 6;
t = 0: 2*pi/N :2*pi;
x = r * sin(t) + half; y = r * cos(t) + half;
hx = double(roipoly(temp, x, y));

bolbs_close_cut = bolbs_close(1 + 27 : end - 27, 1 + 27: end - 27);
bolbs_close_open = dilationG(erosionG(bolbs_close_cut, se_cir, true), se_cir, true);

figure;
subplot(121); imshow(bolbs_close);
subplot(122); imshow(bolbs_close_open);

se = ones(7,7);
grad = imbinarize(dilationG(bolbs_close_open, se, true) - erosionG(bolbs_close_open, se, true));
grad(:, 1 : 87) = false;
bolbs_seg = bolbs(1 + 27 : end - 27, 1 + 27: end - 27);
bolbs_seg(grad) = 255;
figure;
imshow(bolbs_seg);
