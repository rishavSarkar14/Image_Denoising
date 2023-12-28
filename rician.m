
% Load the image
image = imread('img\1.jpg');

% Create a figure to display the images
figure;

% Loop through noise levels
for i = 1:9
    % Calculate noise level
    noise_level = i * 10;
    
 %Rician Noise
                    % Calculate the Rician noise parameters
                    s = noise_level/100 * double(max(image(:)));
                    r = s / sqrt(2);
    
                    % Generate the Rician noise
                    noise = r * (randn(size(image)) + 1i * randn(size(image)));
                    noisy = double(image) + real(noise);
    
                    % Convert the noisy image to uint8 format
                    noisy = uint8(max(min(noisy, 255), 0));
    
    % Display the noisy image
    subplot(3, 3, i);
    imshow(noisy);
    title(sprintf('Noise Level: %d%%', noise_level));
end