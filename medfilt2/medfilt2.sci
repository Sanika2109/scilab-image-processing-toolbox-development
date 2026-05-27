function median_filter = medfilt2(I, windowsize, padopt)

    // Determine window dimensions
    // If a single value is given (e.g., 3), use a square window (3×3)
    // Otherwise, use the specified dimensions (m×n)
    if size(windowsize,"*")==1 then
        m = windowsize;
        n = windowsize;
    else
        m = windowsize(1);
        n = windowsize(2);
    end

    // Median filtering requires odd-sized windows to ensure a center pixel exists
    if modulo(m,2)==0 | modulo(n,2)==0 then
        error("Window dimensions must be odd");
    end

    // Get image dimensions
    [row,col] = size(I);

    // Calculate padding size on each side
    k1 = floor(m/2);
    k2 = floor(n/2);

    // Apply selected padding method
    select padopt

    // Replicate border values outward
    case "replicate" then
        padded = padarray(I,[k1 k2],"replicate");

    // Mirror image including edge pixels
    case "symmetric" then
        padded = padarray(I,[k1 k2],"symmetric");

    // Mirror image excluding edge pixels
    case "reflect" then
        padded = padarray(I,[k1 k2],"reflect");

    // Wrap image values from opposite side
    case "circular" then
        padded = padarray(I,[k1 k2],"circular");

    // Add zero-valued padding around image
    case "zero" then
        padded = zeros(row+2*k1, col+2*k2);
        // Place original image at center
        padded(k1+1:k1+row, k2+1:k2+col) = I;

    // Handle invalid padding option
    else
        error("Invalid padding option");

    end

    // Initialize output image
    median_filter = zeros(row,col);

    // Traverse each pixel of original image
    for i = 1:row
        for j = 1:col

            // Extract neighborhood window around current pixel
            window = padded(i:i+2*k1, j:j+2*k2);

            // Convert window matrix into a row vector
            values = matrix(window,1,-1);

            // Compute median and assign to output pixel
            median_filter(i,j) = median(values);

        end
    end

endfunction
