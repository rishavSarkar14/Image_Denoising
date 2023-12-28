%% MAIN PROGRAM USES NOISE.M, NLM.PY FILES

%% CREATED BY RISHAV SARKAR BTECH/10404/21

%% Defining the Metrics table for storage
iterations = 1;
sz = [iterations 11];
varTypes = ["string", "string", "double", "double", "double", "double", "double", "double", "double", "double", "string"];
varNames = ["Image", "Noise", "Amount", "PSNR_Before", "SNR_Before", "PSNR_After", "SNR_After", "MSE", "RMSE", "SSIM", "FilterUsed"];
noiseTypes = ["gaussian", "salt & pepper", "speckle", "poisson", "localvar", "rayleigh", "gamma", "periodic", "rician", "quantization"];
metrics = table('Size', sz, 'VariableTypes', varTypes, 'VariableNames',varNames);

%% Defining the filter Parameters
bigWindow = 21;
smallWindow = 7;
h = 30;
padwidth = floor(bigWindow/2);

%% Main Loop Starts
%Loop1 - for looping through images
for i = 1:5

    %Looping through the images in the folder img
    filename = sprintf('img/%d.jpg', i);
    img = imread(filename);

    %Converting them to grayscale (for easier computation)
    img = im2gray(img);
    
    %Loop2 - for looping through noise types
    for j = 1:10

        %Loop3 - for looping through noise amounts
        for k = 1:9
            
            %Defining the amount of noise to be added
            amount = k/10;

            %Adding the noise using Noise.m file
            noisy = Noise(img, noiseTypes(j), amount);

            %Storing the noise type for metrics
            noiseType = noiseTypes(j);

            noisy = uint8(noisy); %Converting the noisy image array to uint8 format
            padNoisy = padarray(noisy, [padwidth padwidth], 'symmetric', 'both'); %Padding the noisy array

            %Computing the PSNR, SNR of the noisy image w.r.t Original
            [peaksnr1, snr1] = psnr(img, noisy);

            %Getting the denoised image from the python file NLM.py and
            %converting it into uint8 MATLAB format
            img_denoise = imnlmfilt(noisy); %Put your function for denoising images here
            img_denoise = uint8(img_denoise);

            %Getting the PSNR, SNR, MSE, RMSE and SSIM of denoised image w.r.t Original
            [peaksnr2, snr2] = psnr(img, img_denoise);
            mse = immse(img, img_denoise);
            rmse = sqrt(mse);
            sim = ssim(img, img_denoise);

            %Storing the data into metrics table
            metrics(iterations, :) = {i, noiseType, amount, peaksnr1, snr1, peaksnr2, snr2, mse, rmse, sim, "NonLocalMeans"};

            %Writing the images into the output folder
            %filename = sprintf('Decision Algorithm/img_noisy%d%d%d.jpg', i, j, k); %Noisy image
            %filename2 = sprintf('Decision Algorithm/img_denoise%d%d%d.jpg', i, j, k); %Denoised image
            %imwrite(noisy, filename);
            %imwrite(img_denoise, filename2);

            %Incrementing the metrics index
            iterations = iterations+1;
        end
    end
end

%Writing the table into metrics.csv file in output folder
writetable(metrics, 'NLM/nlm.xlsx');

%% END