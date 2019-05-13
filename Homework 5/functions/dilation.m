function img_dilation = dilation(img, se)

%DILATION: conduct dilaton operation on given image
%   img - image to be dilated
%   se - struturing elements
se = se(end:-1:1, end:-1:1); %reflection
se_log = logical(se);

[row, col] = size(img);
img_select = false(row,col);
size_se = (size(se) - 1) / 2;
row_se_half = size_se(1);
col_se_half = size_se(2);
img_pad = padarray(img,[row_se_half, col_se_half],0);

for i = 1 + row_se_half : row + row_se_half     %column
    for j = 1 + col_se_half : col + col_se_half     %row
        win = img_pad(i - row_se_half : i + row_se_half, j - col_se_half : j + col_se_half);
        if sum(sum(win & se_log))
            img_select(i - row_se_half, j - col_se_half) = true;
        end
    end
end

img_dilation = img_select;

end