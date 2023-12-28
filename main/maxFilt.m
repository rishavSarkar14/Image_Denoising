sz = [1 9];
varTypes = ["string", "string", "double", "double", "double", "double", "double", "double", "string"];
varNames = ["Image", "Noise", "Amount", "PSNR_Before", "SNR_Before", "PSNR_After", "SNR_After", "MSE", "FilterUsed"];
noiseTypesInbuilt = ["gaussian", "salt & pepper", "speckle", "poisson", "localvar"];
noiseTypesCustom = ["rayleigh", "gamma", "periodic", "rician", "quantization"];
metrics = table('Size', sz, 'VariableTypes', varTypes, 'VariableNames',varNames);
iterations = 1;
for i = 1:5
    filename = sprintf("img/%d.jpg", i);
    img = imread(filename);
    img = im2gray(img);

    for j = 1:9
        h = j/10;
        x = rand(size(img));
        img_original = img;
        img(x(:)<h) = 255;
		[peaksnr1, snr1] = psnr(img, img_original);
		denoise = maxFilter(img);
		[peaksnr2, snr2] = psnr(denoise, img_original);
		mse = immse(denoise, img_original);
		metrics(iterations, :) = {filename, 'salt', h, peaksnr1, snr1, peaksnr2, snr2, mse, "MinFilter"};
		iterations = iterations + 1;
    end
end

function denoise = maxFilter(image)
	[m, n] = size(image);
	image = padarray(image, [1 1], 'replicate', 'both');
	
	for i = 2:m
		for j = 2:n
			sto = image(i-1:i+1, j-1:j+1);
			maxi = min(sto, [], "all");
			image(i, j) = maxi;
		end
	end
	denoise = image(2:m+1, 2:n+1);
end