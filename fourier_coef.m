function [R , I] = fourier_coef(N)
% N x N = size of fourier coefficient matrix

R = zeros(N , N);

I = zeros(N , N);

for f = 0 : N - 1
    for n = 0 : N - 1
        R(f + 1 , n + 1) = cos(2 * pi * f * n / N);
        I(f + 1 , n + 1) = -sin(2 * pi * f * n / N);
    end
end
end