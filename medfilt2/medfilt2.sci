function median_filter = medfilt2(I, windowsize, padopt)

    // Use default 3×3 neighborhood if window size is not specified
    if argn(2) < 2 then
        windowsize = [3 3];
    end

    // Use zero padding by default
    if argn(2) < 3 then
        padopt = "zero";
    end

    // Convert RGB image to grayscale if necessary
    if ndims(I) == 3 then
       I = rgb2gray(I);
    elseif ndims(I) <> 2 then
       error("medfilt2: Input image must be a 2-D or RGB image.");
    end

    // Determine window dimensions
    if size(windowsize,"*")==1 then
        // Scalar window size (e.g., 3 → 3×3)
        m = windowsize;
        n = windowsize;

    elseif size(windowsize,"*")==2 & min(size(windowsize))==1 then
        // Rectangular window dimensions [m n]
        m = windowsize(1);
        n = windowsize(2);

    else

        error("medfilt2: Window size must be a scalar or a two-element vector.");

    end

    // Median filtering requires odd-sized windows
    if modulo(m,2)==0 | modulo(n,2)==0 then
        error("Window dimensions must be odd");
    end

    // Get image dimensions
    [row,col] = size(I);

    // Check for empty image
    if row==0 | col==0 then
        error("medfilt2: Input image cannot be empty.");
    end

    // Compute padding required on each side
    k1 = floor(m/2);
    k2 = floor(n/2);

    // Apply selected padding method
    select padopt

    // Replicate border pixels
    case "replicate" then
        padded = padarray(I,[k1 k2],"replicate");

    // Mirror image including edge pixels
    case "symmetric" then
        padded = padarray(I,[k1 k2],"symmetric");

    // Mirror image excluding edge pixels
    case "reflect" then
        padded = padarray(I,[k1 k2],"reflect");

    // Wrap values from opposite image borders
    case "circular" then
        padded = padarray(I,[k1 k2],"circular");

    // Pad with zeros
    case "zero" then
        padded = zeros(row+2*k1, col+2*k2);
        padded(k1+1:k1+row, k2+1:k2+col) = I;

    // Invalid padding option
    else
        error("Invalid padding option");

    end

    // Initialize output image
    median_filter = zeros(row,col);

    // Apply median filtering pixel by pixel
    for i = 1:row
        for j = 1:col
            // Extract neighborhood centered at current pixel
            window = padded(i:i+m-1, j:j+n-1);

            // Convert neighborhood into a vector
            values = matrix(window,1,-1);

            // Replace current pixel with neighborhood median
            median_filter(i,j) = median(values);
        end
    end
endfunction
