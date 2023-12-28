function outputImage = nonLocalMeans(noisy, params, verbose)

% Performs the non-local-means algorithm given a noisy image.
% params is a tuple with:
% params = (bigWindowSize, smallWindowSize, h)
% Please keep bigWindowSize and smallWindowSize as even numbers

bigWindowSize = params(1);
smallWindowSize = params(2);
h = params(3);

padwidth = floor(bigWindowSize/2);
image = noisy;

% The next few lines creates a padded image that reflects the border so that the big window can be accommodated through the loop
paddedImage = uint8(zeros(size(image,1) + bigWindowSize, size(image,2) + bigWindowSize));
paddedImage(padwidth+1:padwidth+size(image,1), padwidth+1:padwidth+size(image,2)) = image;
paddedImage(padwidth+1:padwidth+size(image,1), 1:padwidth) = fliplr(image(:,1:padwidth));
paddedImage(padwidth+1:padwidth+size(image,1), size(image,2)+padwidth+1:size(paddedImage,2)) = fliplr(image(:,size(image,2)-padwidth:size(image,2)));
paddedImage(1:padwidth,:) = flipud(paddedImage(padwidth+1:2padwidth,:));
paddedImage(size(image,1)+padwidth+1:size(paddedImage,1), :) = flipud(paddedImage(size(paddedImage,1)-2padwidth:size(paddedImage,1)-padwidth,:));

iterator = 0;
totalIterations = size(image,1)*size(image,2)*(bigWindowSize-smallWindowSize)^2;

if verbose
disp(['TOTAL ITERATIONS = ', num2str(totalIterations)]);
end

outputImage = paddedImage;

smallhalfwidth = floor(smallWindowSize/2);

% For each pixel in the actual image, find a area around the pixel that needs to be compared
for imageX = padwidth+1:padwidth+size(image,2)
for imageY = padwidth+1:padwidth+size(image,1)

    bWinX = imageX - padwidth;
    bWinY = imageY - padwidth;

    %comparison neighbourhood
    compNbhd = paddedImage(imageY-smallhalfwidth:imageY+smallhalfwidth, imageX-smallhalfwidth:imageX+smallhalfwidth);

    pixelColor = 0;
    totalWeight = 0;

    % For each comparison neighbourhood, search for all small windows within a large box, and compute their weights
    for sWinX = bWinX:bWinX+bigWindowSize-smallWindowSize-1
        for sWinY = bWinY:bWinY+bigWindowSize-smallWindowSize-1

            %find the small box       
            smallNbhd = paddedImage(sWinY:sWinY+smallWindowSize, sWinX:sWinX+smallWindowSize);
            euclideanDistance = sqrt(sum(sum((smallNbhd-compNbhd).^2)));
            %weight is computed as a weighted softmax over the euclidean distances
            weight = exp(-euclideanDistance/h); %this is a scalar value do NOT make it a vector
            totalWeight = totalWeight + weight;
            pixelColor = pixelColor + weight*paddedImage(sWinY+smallhalfwidth, sWinX+smallhalfwidth);
            iterator = iterator + 1;

            if verbose && mod(iterator*100/totalIterations,5) == 0
                disp(['% COMPLETE = ', num2str(iterator*100/totalIterations)]);
            end
        end
end
end
end
end