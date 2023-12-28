% Load the image
image = imread('plants.jpg');

% Create a figure to display the images
figure;

% Loop through noise levels
for i = 1:9
    % Calculate noise level
    h = i * 10;
    
    % Calculate number of quantization levels
    n_levels = floor(256 / (1 / h));
    
    % Generate the quantization noise
    q_noise = randn(size(image)) * n_levels / 256;
    noisy = im2double(image) + q_noise;
    noisy = im2uint8(noisy / max(noisy(:)));
    
    % Display the noisy image
    subplot(3, 3, i);
    imshow(noisy);
    title(sprintf('Noise Level: %d%%', h));
end
