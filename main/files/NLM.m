function filteredImage = NLM(noisyImage, h, bigWindow, smallWindow)

    % noisyImage: the noisy input image to be filtered
    % h: the smoothing parameter
    % windowSize: size of the search window
    % patchSize: size of the patch
    
    % Convert the input image to double precision
    noisyImage = im2double(noisyImage);
    
    % Get the dimensions of the input image
    image = noisyImage;
    [rows, cols] = size(image);
    

    % Calculate half of the window and patch size
    padwidth = floor(bigWindow / 2);
    smallhalfwidth = floor(smallWindow / 2);
    
    % Pad the noisy image to account for the border effects
    paddedImage = zeros(rows+bigWindow, cols+bigWindow);

    %Get the size of padded Image
    [rows1, cols1] = size(paddedImage);

    %Padded image processing
    paddedImage = cast(paddedImage, "uint8");
    paddedImage(padwidth+1:padwidth+rows+1, padwidth+1:padwidth+cols+1) = image;
    paddedImage(padwidth+1:padwidth+rows+1, 1:padwidth+1) = flip(image(:, 1:padwidth+1), 2);
    paddedImage(padwidth+1:padwidth+rows+1, cols+padwidth+1:cols+2*padwidth+1) = flip(image(:, cols-padwidth-1:cols));
    paddedImage(1:padwidth-1, :) = flip(paddedImage(padwidth-1:2*padwidth-1, :));
    paddedImage(padwidth+rows-1:2*padwidth+cols, :) = flip(paddedImage(rows1-2*padwidth-1:cols1-padwidth+1, :));

    %Take out the number of iterations
    iterator = 0;
    totalIterations = cols*rows*((bigWindow - smallWindow)^2);

    %Initialize the empty image
    filteredImage = zeros(size(paddedImage));
    
    % Loop through each pixel in the input image
    for imageX = (padwidth+1):padwidth+rows
        for imageY = (padwidth+1):padwidth+cols
            
            % Define the search window centered at the current pixel
            bWinX = imageX - padwidth;
            bWinY = imageY - padwidth;

            %Defining comparison neighbourhood
            compNbhd = paddedImage(imageY - smallhalfwidth-1:imageY+smallhalfwidth, image);
    
            % Loop through each patch in the search window
            for m = imageX:imageX+2*padwidth-2*smallhalfwidth
                for n = imageY:imageY+2*padwidth-2*smallhalfwidth
                    
                    % Define the patch centered at the current pixel
                    patch = searchWindow(m:m+2*smallhalfwidth, n:n+2*smallhalfwidth);
    
                    % Calculate the distance between the current patch and the
                    % reference patch
                    distance = sum(sum((patch - noisyImage(imageX:imageX+2*smallhalfwidth, imageY:imageY+2*smallhalfwidth)).^2));
    
                    % Calculate the weight for the current patch
                    weight = exp(-distance / h);
    
                    % Add the weighted patch to the weighted average
                    weightedAverage = weightedAverage + weight * patch;
    
                    % Add the weight to the normalization factor
                    normalizationFactor = normalizationFactor + weight;
                end
            end
        end
    end
    
    % Convert the filtered image to the same class as the input image
    filteredImage = cast(filteredImage, class(noisyImage));
end