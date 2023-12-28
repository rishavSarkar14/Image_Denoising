clear ; clc; close all;

%% Defining the Metrics table for storage
iterations = 1;
sz = [iterations 12];
varTypes = ["string", "string", "double", "double", "double", "double", "double", "double", "double", "double", "string", "string"];
varNames = ["Image", "Noise", "Amount", "PSNR_Before", "SNR_Before", "PSNR_After", "SNR_After", "MSE", "RMSE", "SSIM", "WaveletUsed", "Thresholding"];
noiseTypes = ["gaussian", "salt & pepper", "speckle", "poisson", "localvar", "rayleigh", "gamma", "periodic", "rician", "quantization"];
varImages = ["Landscape.jpg", "Coins.jpg", "Leaves.jpg", "Trains.jpg", "Satellite.jpg"];
metrics = table('Size', sz, 'VariableTypes', varTypes, 'VariableNames',varNames);

for i = 1:5
    img = sprintf("%d.jpg", i);
    I = im2double(imread(img));

    for j = 1:10
        if(size(I,3) == 3)
            I = rgb2gray(I);
        end
        for k = 1:9
            % noise generation
            Sigma = k/10;
            J = Noise(I, noiseTypes(j), Sigma);

            %Metrics calculation
            [psnr_b, snr_b] = psnr(J, I);
    
            %% Wavelet transform
            Nlevels=4;
            NoOfBands=3*Nlevels+1;
            wname='db8';
            [C,S] = Wavelet_Decomposition(J,Nlevels,NoOfBands,wname);
    
            %% Wavelet Sureshrinkage
            Eband=cell(1,NoOfBands);
            for x=1:NoOfBands-1
                Sband=C{x};                 
                Sbandd = Sband(:); 
                n = length(Sbandd);
                Tlambda = 0:0.01:Sigma*sqrt(2*log(n));
                Sure_thr = zeros(1,length(Tlambda));
    
                for l = 1:length(Tlambda)
                    T = Tlambda(l);        
                    Temp1 = Sigma^2;
                    Temp2 = (2*Sigma^2*(length(find(abs(Sbandd)<=T))))/n;
                    Temp3 =(sum( min(abs(Sbandd),T).^2))/n;
                    Sure_thr(l) = Temp1 - Temp2 + Temp3;
                end
    
                minn = min(Sure_thr);
                bb = find(Sure_thr==minn);
                Thr = Tlambda(bb);
                Tcoeff = wthresh(Sband,'s',Thr);
        %     Sband(abs(Sband)>Thr) = 0; % hard thresholding
                Eband{x}=Tcoeff;
            end
    
            Eband{x+1}=C{x+1};
    
    
            %% General Wavelet Reconstruction.
            [Dpro] = Wavelet_Reconstruction(Eband,NoOfBands,S,wname);
    
            %Calculation of PSNR_A, SNR_A, MSE, SSIM
            [psnr_a, snr_a] = psnr(Dpro, I);
            sim = ssim(Dpro, I);
            mse = immse(Dpro, I);
    
            metrics(iterations, :) = {varImages(i), noiseTypes(j), Sigma, psnr_b, snr_b, psnr_a, snr_a, mse, sqrt(mse), sim, wname, "SureSHRINK"};
            iterations = iterations+1;
        end
    end
end