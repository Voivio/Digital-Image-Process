function [img_2] = myBicubic(img_1, n)

size_1 = size(img_1);
h_1 = size_1(1);
w_1 = size_1(2);
h_2 = floor(h_1 * n);
w_2 = floor(w_1 * n);
img_2 = zeros(h_2, w_2);

pad = 2;
img_1_pad = padarray(img_1,[pad,pad],0,'both');

for i = 1 :h_2
    for j = 1 : w_2
        %calculate 16 parameters
        x = i/n; x_cen = floor(i/n);
        y = j/n; y_cen = floor(j/n);
        A = [];
        b = [];
        
        for ii = -1 : 2
            for jj = -1 : 2
                xn = x_cen + ii;
                yn = y_cen + jj;
                a = [1,yn,yn^2,yn^3,xn,xn*yn,xn*yn^2,xn*yn^3,xn^2,(xn^2)*yn,(xn^2)*(yn^2),(xn^2)*(yn^3),(xn^3),(xn^3)*yn,(xn^3)*(yn^2),(xn^3)*(yn^3)];
                A = [A;a];
                b = [b;img_1_pad(xn+pad,yn+pad)];
            end
        end
        
        X = linsolve(A,double(b));
        img_2(i,j) = [1,y,y^2,y^3,x,x*y,x*y^2,x*y^3,x^2,(x^2)*y,(x^2)*(y^2),(x^2)*(y^3),(x^3),(x^3)*y,(x^3)*(y^2),(x^3)*(y^3)]*X;
    end
end

img_2 = uint8(img_2);
end
