function Yxy = xyz2yxy(XYZ)
Y = XYZ(2, :);
x = XYZ(1, :) ./ sum(XYZ, 1);
y = XYZ(2, :) ./ sum(XYZ, 1);
Yxy = [Y; x; y];
