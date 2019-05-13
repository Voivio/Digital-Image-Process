function img_erosion = erosionG(img, se, flat)
%EROSIONG: conduct erosion operation on given gray scale image
%   img - image to be erosed
%   se - struturing elements
%   flat - is the se flat (no intensity change)

[row, col] = size(img);
img = mat2gray(img, [0,255]);
img_erosion = zeros(row,col);
se_select = imbinarize(se);

size_se = (size(se) - 1) / 2;
row_se_half = size_se(1);
col_se_half = size_se(2);
img_pad = padarray(img,[row_se_half, col_se_half],0);

if flat
    se = zeros(size(se));
end

for i = 1 + row_se_half : row + row_se_half     %column
    for j = 1 + col_se_half : col + col_se_half    %row
        win = img_pad(i - row_se_half : i + row_se_half, j - col_se_half : j + col_se_half) - se;
        img_erosion(i - row_se_half, j - col_se_half) = min(win(se_select));
    end
end

img_erosion(img_erosion > 1) = 1;
img_erosion = im2uint8(img_erosion);

end

