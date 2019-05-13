function img_erosion = erosion(img, se)

%EROSION: conduct erosion operation on given image
%   img - image to be erosed
%   se - struturing elements
se_log = logical(se);

[row, col] = size(img);
img_select = false(row,col);
size_se = (size(se) - 1) / 2;
row_se_half = size_se(1);
col_se_half = size_se(2);
img_pad = padarray(img,[row_se_half, col_se_half],0);

for i = 1 + row_se_half : row + row_se_half     %column
    for j = 1 + col_se_half : col + col_se_half    %row
        win = img_pad(i - row_se_half : i + row_se_half, j - col_se_half : j + col_se_half);
        if (win .* se_log) == se
            img_select(i - row_se_half, j - col_se_half) = true;
        end
    end
end

img_erosion = img.*img_select;

end
        

