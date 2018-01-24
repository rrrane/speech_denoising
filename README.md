# Speech Denoising with Neural Network
## Description
In this application, the neural network is trained to generate audio-denoising mask. The input to the network is a Short-Time Fourier Transform (STFT) of noisy speech signal. Output of the network is the denoising mask, which when applied to the noisy signal, produces denoised signal. The neural network has two hidden layers with hyperbolic tangent activations. Each hidden layer has 51 units including the bias term. **Gradient Descent** is used for optimization.

## Usage
Create a directory with name **"data"** and add following files in it:
1. **data\trn.wav:** the noise signal used for training
2. **data\trs.wav:** the original speech signal used for training
3. **data\tex.wav:** the noisy speech signal used for testing
4. **data\tes.wav:** the original test speech signal to calculate Signal-to-Noise Ratio (SNR)

Now run **denoise.m**.
