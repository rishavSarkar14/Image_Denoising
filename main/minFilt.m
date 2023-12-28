sz = [1 7];
varTypes = ["string", "double", "double", "double", "double", "double", "double"];
varNames = ["Noise", "Amount", "PSNR_Before", "SNR_Before", "PSNR_After", "SNR_After", "MSE"];
metrics = table('Size', sz, 'VariableTypes', varTypes, 'VariableNames',varNames);
%creating a matrix of size same as that of original image with random
%numbers


