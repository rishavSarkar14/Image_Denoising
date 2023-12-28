% img - original image
% horiz  - horizontal component
% verti  - Vertical   component


% read the image image
img = imread('C:\Users\Aniket Sourav\Desktop\123.jpeg');

% Define the wavelet type and level of decomposition
wtype = 'haar'; % Wavelet type
decom = 1; % Number of decomposition levels

% Applying DWT on the input
[Approxi, horiz, verti, cD] = dwt2(img, wtype, 'mode', 'sym');

for i=1:decom-1
    [Approxi, horiz, verti, cD] = dwt2(Approxi, wtype, 'mode', 'sym');
end

% outputs
figure;
imshow(img, []), title('Original Image')
figure;
 imshow(Approxi, []), title('Approximation Coefficients')
figure;
imshow(horiz, []), title('Horizontal Detail Coefficients')

figure;
 imshow(verti, []), title('Vertical Detail Coefficients')

 err = immse(img,horiz);
fprintf('\n The mean-squared error is %0.4f\n', err);

pog = sqrt(mean(img,horiz));
message = sprintf('The Root mean square error is %.3f.', pog);

[peaksnr, snr] = psnr(img,horiz);
  
fprintf('\n The Peak-SNR value is %0.4f', peaksnr);

[ssimval,ssimmap] = ssim(img,horiz);
imshow(ssimmap,[])
title("Local SSIM Map with Global SSIM Value: "+num2str(ssimval))

