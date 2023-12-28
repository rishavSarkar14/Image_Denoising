clc;
clear;
close all;
% reading the image
Original_Image = imread("C:\Users\Aniket Sourav\Desktop\123.jpeg");

% convert to grayscale
Original_Image = rgb2gray(Original_Image);

% add noise  to image
Noisy_image = imnoise(Original_Image, 'salt & pepper',0.1);

% choose type of thresholding (hard or soft)
type = 's';

% applying dwt to the image and it's components 
[A1, H1, V1, D1] = dwt2(Noisy_image, 'db1'); % level - 1
[A2, H2, V2, D2] = dwt2(A1, 'db1'); % level - 2
[A3, H3, V3, D3] = dwt2(A2, 'db1'); % level - 3


%% LEVEL - 3
% find threshold on detail components
T13 = sigthresh(H3, 3, H3);
T23 = sigthresh(V3, 3, V3);
T33 = sigthresh(D3, 3, D3);
% apply threshold, these matrices are denoised before image reconstruction
Y13 = wthresh(H3, type, T13);
Y23 = wthresh(H3, type, T23);
Y33 = wthresh(H3, type, T33);

%% LEVEL - 2
% find threshold on detail components
T12 = sigthresh(H2, 2, H2);
T22 = sigthresh(V2, 2, V2);
T32 = sigthresh(D2, 2, D2);
% apply threshold, these matrices are denoised before image reconstruction
Y12 = wthresh(H2, type, T12);
Y22 = wthresh(V2, type, T22);
Y32 = wthresh(D2, type, T32);

%% LEVEL - 1
% find threshold on detail components
T11 = sigthresh(H1, 1, H1);
T21 = sigthresh(V1, 1, V1);
T31 = sigthresh(D1, 1, D1);
% apply threshold, these matrices are denoised before image reconstruction
Y11 = wthresh(H1, type, T11);
Y21 = wthresh(V1, type, T21);
Y31 = wthresh(D1, type, T31);

% apply inverse discrete wavelet transform on all levels
Y_cA2 = idwt2(A3, Y13, Y23, Y33, 'db1');
Y_cA1 = idwt2(A2, Y12, Y22, Y32, 'db1');
Y_cA = idwt2(A1, Y11, Y21, Y31, 'db1');

figure(1); imshow(Original_Image);
title("Original image");
figure(2); imshow(Noisy_image);
title("Noisy Image");
figure(3); imshow(uint8(Y_cA));
title("Filtered image");

 filename = 'metrics.xlsx';
writetable(metrics, filename, 'Sheet', 1);
 sz = [20 7];
varTypes = ["string", "double", "double", "double", "double", "double", "double"];
varNames = ["Noise", "Amount", "PSNR_Before", "SNR_Before", "PSNR_After", "SNR_After", "MSE"];
metrics = table('Size', sz, 'VariableTypes', varTypes, 'VariableNames', varNames);

err = immse(Original_Image,uint8(Y_cA));
fprintf('\n The mean-squared error is %0.4f\n', err);

pog = sqrt(mean((Original_Image(:)-uint8(Y_cA(:))).^2));
message = sprintf('The Root mean square error is %.3f.', pog);

[peaksnr, snr] = psnr(Original_Image, uint8(Y_cA));
  
fprintf('\n The Peak-SNR value is %0.4f', peaksnr);

[ssimval,ssimmap] = ssim(Original_Image,uint8(Y_cA));
imshow(ssimmap,[])
title("Local SSIM Map with Global SSIM Value: "+num2str(ssimval))