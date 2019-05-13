function img_ero = morpRecErosion(marker, mask, se)
%morpRecErosion: conduct morphological reconstruction by erosion operation onto an image
%   marker: image to be transformed
%   mask: image used to restrict operation
%   se: structuring element

mask = mask > 0;
last = marker;
img_ero = erosion(last, se) | mask;
while sum(sum(img_ero ~= last))
    last = img_ero;
    img_ero = erosion(last, se) | mask;
end 

end

