function [img_2] = myBilinear(img_1, n)

size_1 = size(img_1);
h_1 = size_1(1);
w_1 = size_1(2);
h_2 = floor(h_1 * n);
w_2 = floor(w_1 * n);
img_2 = zeros(h_2, w_2);

pad = 1;
img_1_pad = padarray(img_1,[pad,pad],0,'both');

for i = 1 :h_2
    for j = 1 : w_2
            x1 = floor(i/n); x2 = x1+1;
            y1 = floor(j/n); y2 = y1+1;
            a1 = [1,x1,y1,x1*y1];
            a2 = [1,x1,y2,x1*y2];
            a3 = [1,x2,y1,x2*y1];
            a4 = [1,x2,y2,x2*y2];
            A = [a1;a2;a3;a4];
            b = [img_1_pad(x1+pad,y1+pad);img_1_pad(x1+pad,y2+pad);img_1_pad(x2+pad,y1+pad);img_1_pad(x2+pad,y2+pad)];
            X = linsolve(A,double(b));
            img_2(i,j) = [1,i/n,j/n,(i*j)/(n^2)]*X;
            
%             x = i/n;
%             y = j/n;
%             x1 = floor(x); x2 = x1 + 1; d1 = x - x1; d2 = x2 - x;
%             y1 = floor(y); y2 = y1 + 1; d3 = y - y1; d4 = y2 - y;
%             v1 = d2 * img_1_pad(x1+pad,y1+pad,:) + d1 * img_1_pad(x2+pad,y1+pad,:);
%             v2 = d2 * img_1_pad(x1+pad,y2+pad,:) + d1 * img_1_pad(x2+pad,y2+pad,:);
%             img_2(i,j,:) = d4 * v1 + d3 * v2;
    end
end  
    img_2 = uint8(img_2);
end

