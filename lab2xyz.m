function xyzout=lab2xyz(labin,xyzn)

n = size(labin,2);
fxyz = zeros(3,n);   
fxyz_n(1,:) = (labin(1,:)+16)/116 + labin(2,:)/500;  
fxyz_n(2,:) = (labin(1,:)+16)/116;   
fxyz_n(3,:) = (labin(1,:)+16)/116 - labin(3,:)/200;

xyzout = fxyz_n .^3;

l = fxyz_n <= 0.206893;
xyzout(l) = (fxyz_n(l)-16/116)/7.787;
clear fxyz_n l;

% scale by white point
xyzout = diag(xyzn)*xyzout;