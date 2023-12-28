clc
clear
img = imread('C:\Users\risha\Study\Projects\DSP Assignment\img\1.jpg');
noise_type = ["salt & pepper", "gaussian", "speckle"];
img_noise = add_noise(img, noise_type);
n = 20;

threshRGB = multithresh(img, n);
threshForPlanes = zeros(3, n);

for i = 1:3
    threshForPlanes(i, :) = multithresh(img(:, :, i), n);
end

value = [0 threshRGB(2:end) 255];
quantRGB = imquantize(img, threshRGB, value);
quantPlane = zeros(size(img));

for i = 1:3
    value = [0 threshForPlanes(i, 2:end) 255];
    quantPlane(:, :, i) = imquantize(img(:, :, i), threshForPlanes(i, :), value);
end

quantPlane = uint8(quantPlane);
imshowpair(quantRGB, quantPlane, 'montage');

function img_noise = add_noise(image, noise)
    img_noise = [];
    for n = 1:length(noise)
        for k = 1:8
            var_n = k/10;
            img_temp = imnoise(image, noise(n), var_n);
            img_noise = cat(4, img_noise, img_temp);
        end
    end
end