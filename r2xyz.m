function XYZ = r2xyz(ill, cmf, refl)
XYZ = (100 / (ill' * cmf(:, 2))) * cmf' * diag(ill) * refl;

