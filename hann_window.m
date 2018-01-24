function window = hann_window(N)
% N = size of window

window = zeros(N , 1);

for n = 0 : N - 1
    window(n + 1) = (1 / 2) * (1 - cos(2 * pi * n / N));
end

end