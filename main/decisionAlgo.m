function [img_denoise] = decisionAlgo(image)
    %getting the size and assuming a 3-channel RGB image
    [m, n, l] = size(image);

    %padding the image for proper denoising
    image = padarray(image, [1 1], 'replicate', 'both');

    %creating an empty matrix
    img_denoise = zeros(size(image));

    %implementing the algorithm with a 3x3 window
    for k = 1:l
        img_slice = image(:, :, k);
        for i = 2:m
            for j=2:n
                arr = img_slice((i-1):(i+1), (j-1):(j+1));
                
                p_med = median(arr, "all");
                p_max = max(arr, [], "all");
                p_min = min(arr, [], "all");
                

                if(p_min < arr(2,2) && arr(2,2) < p_max)
                    continue;

                elseif(p_min < p_med && p_med < p_max)
                    arr(2,2) = p_med;
                
                else
                    arr_flat = reshape(arr.', 1, []);
                    p_mean = mean(arr_flat(1:4));
                    arr(2,2) = p_mean;

                end

                img_slice((i-1):(i+1), (j-1):(j+1)) = arr(:, :);
            end
        end

        img_denoise(:, :, k) = img_slice(:, :);
    end
    img_denoise = uint8(img_denoise);

    %unpadding the image
    img_denoise = img_denoise(2:end-1, 2:end-1, :);
end