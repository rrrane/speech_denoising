function [ft_r , ft_i] = fourier_transform(y)
% y = input signal in time domain

N = size(y , 1);

[R , I] = fourier_coef(N);

ft_r = R * y;
ft_i = I * y;

end