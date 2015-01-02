function [J, C, h, ac, bc] = ciecam02(XYZ, XYZn, La, Yb, F, c, Nc)

Mcat02 = [0.7328 0.4296 -0.1624; -0.7036 1.6975 0.0061; 0.0030 0.0136 0.9834];
MH = [0.38971 0.68898 -0.07868; -0.22981 1.18340 0.04641; 0.0 0.0 1.0];
Mcat02inv = [1.096124 -0.278869 0.182745; 0.454369 0.473533 0.072098; -0.009628 -0.005698 1.015326];

% Viewing Condition Parameters

k = 1 / (5 * La + 1);
Fl = 0.2 * k^4 * (5 * La) + 0.1 * (1 - k^4)^2 * (5 * La)^(1 / 3);

n = Yb / XYZn(2); % Yb / Yw
Ncb = 0.725 * (1 / n)^0.2;
Nbb = Ncb;
z = 1.48 + sqrt(n);

% put adopted white point as the last sample to simplify equations.
XYZ = [XYZ XYZn];

% Chromatic Adaptation

RGB = Mcat02 * XYZ;
D = F * (1 - (1 / 3.6) * exp(( -La - 42) / 92) );
Yw = XYZn(2);
% use diag instead of repmat for broadcasting; RGB(:, end) is white point.
RGBc = diag(Yw * D ./ RGB(:, end) + 1 - D) * RGB; 
RGBp = MH * Mcat02inv * RGBc;

% Non-Linear Response Compression

RGBpa = sign(RGBp) .* (400 * (Fl * abs(RGBp) / 100) .^ 0.42) ./ (27.13 + (Fl * abs(RGBp) / 100) .^ 0.42) + 0.1; 
% sepatate sample and white point data
RGBpaw = RGBpa(:, end);
RGBpa = RGBpa(:, 1:end-1);

% Perceptual Attribute Correlates

a = RGBpa(1, :) - 12 * RGBpa(2, :) / 11 + RGBpa(3, :) / 11;
b = (RGBpa(1, :) + RGBpa(2, :) - 2 * RGBpa(3, :)) / 9;
h = atan2d(b, a);
h(h<0) = h(h<0) + 360;

% eccentricity factor
et = (cos(2 + h * pi / 180) + 3.8) / 4;

A = (2 * RGBpa(1, :) + RGBpa(2, :) + RGBpa(3, :) / 20 - 0.305) * Nbb;
Aw = (2 * RGBpaw(1) + RGBpaw(2) + RGBpaw(3) / 20 - 0.305) * Nbb;

% lightness
J = 100 * ( A / Aw ) .^ (c * z);

% brightness
Q = (4 / c) * sqrt(J / 100) * (Aw + 4) * Fl ^ 0.25;

% chroma
t = (50000 / 13 * Nc * Ncb) * et .* (a.^2 + b.^2).^0.5 ./ (RGBpa(1, :) + RGBpa(2, :) + 21 * RGBpa(3, :) / 20);
C = (t .^ 0.9) .* sqrt(J / 100) * (1.64 - 0.29 ^ n) ^ 0.73;

% colorfulness
M = C * Fl .^ 0.25;

% saturation
s = 100 * sqrt(M ./ Q);

% Cartesian coordinates
ac = C .* cosd(h);
bc = C .* sind(h);


