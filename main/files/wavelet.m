clear;
% reading the image
I=imread('C:\Users\Aniket Sourav\Desktop\123.jpeg');
figure;
%displaying the original image
imshow(I)

% applying discrete wavelet transform to the image's different components ,applying haar for image
% compression
[R1, R2, R3, R4] = dwt2(I(:,:,1), 'haar');
[G1, G2, G3, G4] = dwt2(I(:,:,1), 'haar');
[B1, B2, B3, B4] = dwt2(I(:,:,1), 'haar');

%combining the components of transormed image segments
A1(:,:,1)= R1;A1(:,:,2) = G1;A1(:,:,3) = B1;
H1(:,:,1)= R2;A1(:,:,2) = G2;A1(:,:,3) = B2;
V1(:,:,1)= R3;A1(:,:,2) = G3;A1(:,:,3) = B3;
D1(:,:,1)= R4;D1(:,:,2) = G4;A1(:,:,3) = B4;

%creating matrix with value ranging between 0 and 1 as all pixel values
%lies between 0 and 255(white color)
xA=A1/255;

%displaying the output we are applying log function for image enhancement
%and readiblity
figure,imshow(A1*0.3);
figure,imshow(log10(H1)*0.3);
figure,imshow(log10(V1)*0.3);
figure,imshow(log10(D1)*0.3);

err = immse(I,A1*0.3);
fprintf('\n The mean-squared error is %0.4f\n', err);

pog = sqrt(mean(I,A1*0.3.^2));
message = sprintf('The Root mean square error is %.3f.', pog);

[peaksnr, snr] = psnr(I,A1*0.3);
  
fprintf('\n The Peak-SNR value is %0.4f', peaksnr);

[ssimval,ssimmap] = ssim(I,A1*0.3);
imshow(ssimmap,[])
title("Local SSIM Map with Global SSIM Value: "+num2str(ssimval))
