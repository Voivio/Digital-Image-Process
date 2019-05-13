%% defining required elements
clear;
close all;

img = imread('text.tif');
[row, col] = size(img);

se1 = ones(51,1);
se2 = [1,1,1;
    1,1,1;
    1,1,1];
se1 = imbinarize(se1);
%% extract letters with long vertical stroke

img_e = erosion(img, se1);
img_d = morpRecDilation(img_e, img, se1);

figure;
subplot(311); imshow(img);
subplot(312); imshow(img_e);
subplot(313); imshow(img_d);

%% filling holes

A = false(row - 2, col - 2);
A = padarray(A, [1,1], true);

marker = false(row, col);
marker(A) = ~img(A);

img_fill = ~morpRecDilation(marker, ~img, se2);

imshow(img_fill);

%% border cleansing

marker = false(row, col);
marker(A) = img(A);

img_cln = img & ~morpRecDilation(marker, img, se2);

imshow(img_cln);
