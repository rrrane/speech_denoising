% Read speech signal
[y_trn , sf] = audioread('data\trn.wav');

% Read noise signal
[y_trs , ~] = audioread('data\trs.wav');

% Mix the signals
x = y_trn + y_trs;

frame_size = 1024;

Y_S = rearrange(y_trs , frame_size , ceil(frame_size / 2));
Y_N = rearrange(y_trn , frame_size , ceil(frame_size / 2));
Y_X = rearrange(x , frame_size , ceil(frame_size / 2));

[S_r , S_i] = fourier_transform(Y_S);
[N_r , N_i] = fourier_transform(Y_N);
[X_r , X_i] = fourier_transform(Y_X);

S = abs(S_r(1:513 , :) + 1i * S_i(1:513 , :));
N = abs(N_r(1:513 , :) + 1i * N_i(1:513 , :));
X = abs(X_r(1:513 , :) + 1i * X_i(1:513 , :));

% Calculate mask
M = double(S > N);
disp('Mask created.');
disp('Now training neural network ...');
% Train the network
W1 = rand(50 , 514);
W2 = rand(50 , 51);
W3 = rand(513 , 51);

num_iter = 5000;
L = zeros(num_iter , 1);
rho = 0.05;
X_scaled = (X - mean(X , 2))./var(X , 0, 2);
for iter = 1 : num_iter
    disp(strcat('Epoch-' , num2str(iter)))
    loss = 0;
    for i = 1 : size(M , 2)
        
        % Forward pass
        X1 = [1 ; X_scaled(: , i)];
        z1 = W1 * X1;
        
        X2 = [1 ; tanh(z1)];
        z2 = W2 * X2;
        
        X3 = [1 ; tanh(z2)];
        z3 = W3 * X3;
        
        y_hat = 1 ./(1 + exp(-z3));
        
        % Backward propagation
        delta3 = (y_hat .* (1 - y_hat)) .* (y_hat - M(: , i));
        dw3 = delta3 * X3';
        
        delta2 = (X3(2 : 51) .* (1 - X3(2 : 51))) .* (W3(: , 2 : 51)' * delta3); %double(z1 > 0) .* (W2(: , 2 : 51)' * delta2);
        dw2 = delta2 * X2';
        
        delta1 = (X2(2 : 51) .* (1 - X2(2 : 51))) .* (W2(: , 2 : 51)' * delta2); %double(z1 > 0) .* (W2(: , 2 : 51)' * delta2);
        dw1 = delta1 * X1';
        
        % Update weight
        W1 = W1 - rho * dw1;
        W2 = W2 - rho * dw2;
        W3 = W3 - rho * dw3;
        
        loss = loss + (y_hat - M(: , i))' * (y_hat - M(: , i))/513;
    end
    L(iter , 1) = loss / size(M , 2);
end

% Denoise the test signal

% Read test signal
[y_test , ~] = audioread('data\tex.wav');

% Get stft of test signal
Y_te = rearrange(y_test , frame_size , ceil(frame_size / 2));
[Y_te_r , Y_te_i] = fourier_transform(Y_te);
X_te = abs(Y_te_r(1:513 , :) + 1i * Y_te_i(1:513 , :));

X_te_scaled = (X_te - mean(X_te , 2))./var(X_te , 0, 2);

% Initialize test_mask
M_test = zeros(size(X_te , 1), size(X_te , 2));


for i = 1 : size(M_test , 2)     
    
    X_te1 = [1 ; X_te_scaled(: , i)];
    z_te1 = W1 * X_te1;
    
    X_te2 = [1 ; tanh(z_te1)];
    z_te2 = W2 * X_te2;
    
    X_te3 = [1 ; tanh(z_te2)];
    z_te3 = W3 * X_te3;

    M_test(: , i) = 1 ./(1 + exp(-z_te3));
    
end

% Recover spectrogram
X_rec_r = [M_test(1:512,:) ; flip(M_test(1:512,:))] .* Y_te_r;
X_rec_i = [M_test(1:512,:) ; flip(M_test(1:512,:))] .* Y_te_i;

% Get inverse fourier transform
[y_te_r , y_te_i] = inverse_fourier_transform(X_rec_r , X_rec_i);

% Normalize the signal
y_pre_final = reconstruct(y_te_r , frame_size , ceil(frame_size / 2));
maxval = max(y_pre_final);
minval = min(y_pre_final);

y_final = (y_pre_final - minval) / (maxval - minval);

% Read original source file
[y_source_pre , ~] = audioread('data\tes.wav');
n = size(y_final,1);

maxval = max(y_source_pre);
minval = min(y_source_pre);

y_source = (y_source_pre - minval) / (maxval - minval);

% Calculate SNR
SNR = 10 * log10(sum(y_source(1:n , 1) .^ 2) / sum((y_source(1:n , 1) - y_final(: , 1)).^2));

% Uncomment following line to write recovered audio to the file
% audiowrite('problem1.wav' , y_final , sf);
