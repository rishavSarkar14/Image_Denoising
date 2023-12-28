function noisy = Noise(image, noiseType, h)
    if(noiseType == "salt & pepper" || noiseType == "speckle")
        noisy = imnoise(image, noiseType, h);
    elseif(noiseType == "poisson")
        noisy = imnoise(image, noiseType);
    elseif(noiseType == "localvar")
        noisy = imnoise(image, noiseType, h*rand(size(image)));
	elseif(noiseType == "gaussian")
		noisy = imnoise(image, noiseType, 0, h/10);
    else
        sz = size(image);
        switch noiseType
            case "rayleigh"
            %Rayleigh noise
            noisy = rayleigh_noise_cvip(image, h*10, sz);

            case "gamma"
            %Gamma Noise
            noisy = gamma_noise_cvip(image, h, sz);

            case "periodic"
            %Periodic Noise
            % Create a sinusoidal grating
            [x,y] = meshgrid(1:size(image,2), 1:size(image,1));
            grating = sin(2*pi*y/32);

            % Add sinusoidal grating to the image
            noisy = im2double(image) + h*grating;
    
            % Clip the values to [0,1]
            noisy(noisy < 0) = 0;
            noisy(noisy > 1) = 1;
    
            % Convert back to uint8 format
            noisy = im2uint8(noisy);
    
            case "rician"
            %Rician Noise
            % Calculate the Rician noise parameters
            s = h * double(max(image(:)));
            r = s / sqrt(2);
    
            % Generate the Rician noise
            noise = r * (randn(size(image)) + 1i * randn(size(image)));
            noisy = double(image) + real(noise);
    
            % Convert the noisy image to uint8 format
            noisy = uint8(max(min(noisy, 255), 0));
    
            case "quantization"
            %Quantization Noise
    
            % Calculate number of quantization levels
            n_levels = floor(256*h);

            % Generate the quantization noise
            q_noise = randn(size(image)) * n_levels / 256;
            noisy = im2double(image) + q_noise;
            noisy = im2uint8(noisy / max(noisy(:)));
    
            otherwise
                errordlg("Invalid input");

        end

    end
end