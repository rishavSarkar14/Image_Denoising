% Read the input image
img = imread('train.jpg');

% Define the noise level as a percentage
noiseLevel = 90;

% Generate Rayleigh noise with the same size as the image
[m, n, c] = size(img);
noise = noiseLevel/100 * raylrnd(sqrt(2/pi), [m, n, c]);

% Add noise to the image and clip the pixel values to the valid range
noisyImg = double(img) + noise;
noisyImg(noisyImg < 0) = 0;
noisyImg(noisyImg > 255) = 255;
noisyImg = uint8(noisyImg);

% Display the original and noisy images side by side
figure;
subplot(1, 2, 1);
imshow(img);
title('Original Image');
subplot(1, 2, 2);
imshow(noisyImg);
title(sprintf('Noisy Image (Noise Level = %d%%)', noiseLevel));
