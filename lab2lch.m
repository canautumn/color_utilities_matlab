function LCh = lab2lch(Lab)
C = sqrt(Lab(2, :) .^ 2 + Lab(3, :) .^ 2);
h = atan2d(Lab(3, :), Lab(2, :));
posNegative = h<0;
h(posNegative) = h(posNegative) + 360;
LCh = [Lab(1, :); C; h];
