function Yxy = rad2yxy(ill, cmf)
XYZ = 683 * cmf' * ill;
x = XYZ(1) / sum(XYZ);
y = XYZ(2) / sum(XYZ);
Yxy = [XYZ(2), x, y];


