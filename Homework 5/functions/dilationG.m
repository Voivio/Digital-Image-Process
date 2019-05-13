function img_dilation = dilationG(img, se, flat)

%DILATIONG: conduct dilaton operation on given gray scale image
%   img - image to be dilated
%   se - struturing elements
%   flat - is the se flat (no intensity change)

se = se(end:-1:1, end:-1:1); %reflection

[row, col] = size(img);
img = mat2gray(img, [0,255]);
img_dilation = zeros(row,col);
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
        win = img_pad(i - row_se_half : i + row_se_half, j - col_se_half : j + col_se_half) + se;
        img_dilation(i - row_se_half, j - col_se_half) = max(win(se_select));
    end
end

img_dilation(img_dilation > 1) = 1; %cut off
img_dilation = im2uint8(img_dilation);

end

