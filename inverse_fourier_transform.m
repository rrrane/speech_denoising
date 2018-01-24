function [inv_ft_r , inv_ft_i] = inverse_fourier_transform(y_r , y_i)
% y = signal in frequency domain

N = size(y_r , 1);

[R_inv , I_inv] = inv_fourier_coef(N);

inv_ft_r = R_inv * y_r - I_inv * y_i;
inv_ft_i = I_inv * y_r + R_inv * y_i;

end