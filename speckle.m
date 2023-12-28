

% Load the image
img = imread('coins.jpg');

% Create a figure to display the images
figure;

% Loop through noise levels
for i = 1:9
    % Calculate noise level
    noise_level = i * 10;
    
    % Add speckle noise to the image
    noisy_img = imnoise(img, 'speckle', noise_level/100);
    
    % Display the noisy image
    subplot(3, 3, i);
    imshow(noisy_img);
    title(sprintf('Noise Level: %d%%', noise_level));
end

