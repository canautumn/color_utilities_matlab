function dE94 = CIE94(Lab1, Lab2, kL,kC,kH)

% set default parametric factors
if ~exist('kL','var'), kL=1; end
if ~exist('kC','var'), kC=1; end
if ~exist('kH','var'), kH=1; end

%CIELAB Chroma
C1 = sqrt(Lab1(2, :) .^ 2 + Lab1(3, :) .^2);
C2 = sqrt(Lab2(2, :) .^ 2 + Lab2(3, :) .^2);

% Weights
% C = sqrt(C1 .* C2);
C = (C1 + C2)/2; % use arithmetic average
% C = C1;
SL = 1.0;
SC = 1.0 + 0.045 * C;
SH = 1.0 + 0.015 * C;

% CIELAB deltas, no need to determine the sign of dH
dL = Lab1(1, :) - Lab2(1, :);
dC = C1 - C2;
dH_without_sign = sqrt((Lab1(2, :) - Lab2(2, :)).^ 2 + ...
    (Lab1(3, :) - Lab2(3, :)) .^2 - dC .^ 2);

% CIE94
dE94 = sqrt((dL ./ (kL * SL)) .^ 2 + ...
    (dC ./ (kC * SC)) .^ 2 + ...
    (dH_without_sign ./ (kH * SH)) .^ 2);
