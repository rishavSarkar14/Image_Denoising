clear ; clc; close all;

%% Defining the Metrics table for storage
iterations = 1;
sz = [iterations 13];
varTypes = ["string", "string", "double", "double", "double", "double", "double", "double", "double", "double", "string", "string", "double"];
varNames = ["Image", "Noise", "Amount", "PSNR_Before", "SNR_Before", "PSNR_After", "SNR_After", "MSE", "RMSE", "SSIM", "WaveletUsed", "Thresholding", "DecomLevel"];
noiseTypes = ["gaussian", "salt & pepper", "speckle", "poisson", "localvar", "rayleigh", "gamma", "periodic", "rician", "quantization"];
wname = ["haar", "db2", "db4", "sym4", "bior6.8", "mexh", "coif5", "dmey", "mor1", "jpeg9.7"];
varImages = ["Landscape.jpg", "Coins.jpg", "Leaves.jpg", "Trains.jpg", "Satellite.jpg"];
metrics = table('Size', sz, 'VariableTypes', varTypes, 'VariableNames',varNames);

tStart = tic;
for i = 1
    img = sprintf("%d.jpg", i);
    I = im2double(imread(img));

    for j = 1:10
        if(size(I,3) == 3)
            I = rgb2gray(I);
        end
        for k = 1:9
            % noise generation
            Sigma = k/10;
            Sigma = Sigma^2;
            J = Noise(I, noiseTypes(j), Sigma);

            %Metrics calculation
            [psnr_b, snr_b] = psnr(J, I);
            for m = 1:10
                if(m == 6 || m == 9 || m == 10)
                    continue;
                end
                for p = 1:2
                    % Denoise using NeighShrink SURE (DWT)
                    L = p; % the number of wavelet decomposition levels
                    wtype = wname(m); % wavelet type
                    Dpro = NeighShrinkSUREdenoise(J, Sigma, wtype, L);
    
                    %Calculation of PSNR_A, SNR_A, MSE, SSIM
                    [psnr_a, snr_a] = psnr(Dpro, I);
                    sim = ssim(Dpro, I);
                    mse = immse(Dpro, I);
    
                    metrics(iterations, :) = {varImages(i), noiseTypes(j), Sigma, psnr_b, snr_b, psnr_a, snr_a, mse, sqrt(mse), sim, wtype, "NeighShrinkSURE", L};
                    iterations = iterations+1;
                end
            end

        end
    end
end
tEnd = toc(tStart);