function img_dil = morpRecDilation(marker, mask, se)
%morpRecDilation: morphological reconstruction by dilation on an image
%   marker: image to be transformed
%   mask: image used to restrict operation
%   se: structuring element

mask = mask > 0;
last = marker;
img_dil = dilation(last, se) & mask;
while sum(sum(img_dil ~= last))
    sum(sum(img_dil ~= last))
    last = img_dil;
    img_dil = dilation(last, se) & mask;
end

end