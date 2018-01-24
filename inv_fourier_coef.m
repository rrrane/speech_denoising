function [R_inv , I_inv] = inv_fourier_coef(N)
% N x N = size of inverse fourier coefficient matrix

R_inv = zeros(N , N);

I_inv = zeros(N , N);

for n = 0 : N - 1
    for f = 0 : N - 1
        R_inv(n + 1 , f + 1) = cos(2 * pi * n * f / N);
        I_inv(n + 1 , f + 1) = sin(2 * pi * n * f / N);
    end
end

end