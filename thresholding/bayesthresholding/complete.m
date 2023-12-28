clear ; clc; close all;

%% Defining the Metrics table for storage
iterations = 1;
sz = [iterations 13];
varTypes = ["string", "string", "double", "double", "double", "double", "double", "double", "double", "double", "string", "string", "double"];
varNames = ["Image", "Noise", "Amount", "PSNR_Before", "SNR_Before", "PSNR_After", "SNR_After", "MSE", "RMSE", "SSIM", "WaveletUsed", "Thresholding", "DecompLevel"];
noiseTypes = ["gaussian", "salt & pepper", "speckle", "poisson", "localvar", "rayleigh", "gamma", "periodic", "rician", "quantization"];
wname = ["haar", "db2", "db4", "sym4", "bior6.8", "mexh", "coif5", "dmey", "mor1", "jpeg9.7"];
threshTypes = ["soft", "hard", "bayes"];
varImages = ["Landscape.jpg", "Coins.jpg", "Leaves.jpg", "Trains.jpg", "Satellite.jpg"];
metrics = table('Size', sz, 'VariableTypes', varTypes, 'VariableNames',varNames);


for i = 1:5
    img = sprintf("%d.jpg", i);
    I = imread(img);    
    if(i == 2 || i == 3 || i == 4)
        I = pagetranspose(I);
    end


    for j = 1:10

        if(size(I,3) == 3)
            I = im2gray(I);
        end
        for k = 1:9
            % noise generation
            Sigma = k/10;
            J = Noise(I, noiseTypes(j), Sigma);
            J = uint8(J);

            %Metrics calculation
            [psnr_b, snr_b] = psnr(J, I);
            
            for m = 1:10
                if(m == 2 || m == 6 || m == 7 || m == 8 || m == 9 || m == 10)
                    continue;
                end
                for n = 1:3
                    for p = 1:2
                        
                        Dpro = waveDenoise(I, J, m, n, p);

                        %Calculation of PSNR_A, SNR_A, MSE, SSIM
                        Dpro = uint8(Dpro);
                        [psnr_a, snr_a] = psnr(Dpro, I);
                        sim = ssim(Dpro, I);
                        mse = immse(Dpro, I);
                        
                        %filename_noisy = sprintf("output/imagen_%d%d%d%d%d%d.jpg", i, j, k, m, n, p);
                        %filename_denoisy = sprintf("output/imagedn_%d%d%d%d%d%d.jpg", i, j, k, m, n, p);
                        metrics(iterations, :) = {varImages(i), noiseTypes(j), Sigma, psnr_b, snr_b, psnr_a, snr_a, mse, sqrt(mse), sim, wname(m), threshTypes(n), p};
                        %imwrite(J, filename_noisy);
                        
                        %imwrtie(Dpro, filename_denoise);
                        iterations = iterations+1;
                    end
                end
            end

        end
    end
end

writetable(metrics, 'WaveletTransform.xlsx');