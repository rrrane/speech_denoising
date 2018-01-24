function X = rearrange(y , N , k)
    % y = input signal
    % N = frame size
    % k = number of locations to shift
    
    window = hann_window(N);
    sample_length = size(y,1);
    num_transforms = floor((sample_length - N) / k);
    X = zeros(N , num_transforms);
    for i = 1 : num_transforms
        front = (i - 1) * k + 1;
        rear = front + N - 1;
        X(: , i) = y(front : rear) .* window;
    end
end