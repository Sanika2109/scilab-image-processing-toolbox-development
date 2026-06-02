function equi_hist = histeq(Img, numBins)
    
    // Ensure input is a grayscale image
    if ndims(Img) == 3 then
       Img = rgb2gray(Img);
    end

    // Default 64 histogram bins for Octave-like behavior
    if argn(2) < 2 then
        numBins = 64;
    end

    // Return empty output for empty input image
    if isempty(Img) then
        equi_hist = [];
        return;
    end

    // Convert image to double precision for computations
    Img = double(Img);

    // Get image dimensions
    [row, col] = size(Img);

    // Find minimum and maximum intensity values
    minIntensity = min(Img);
    maxIntensity = max(Img);

    // If all pixels have the same intensity, return the image unchanged
    if maxIntensity == minIntensity then
        equi_hist = Img;
        return;
    end

    // Normalize image intensities to the range [0, 1]
    normalizedImg = (Img - minIntensity) / (maxIntensity - minIntensity);

    // Assign each pixel to one of the histogram bins
    binIndices = floor(normalizedImg * (numBins - 1));

    // Compute histogram counts for each bin
    histCount = zeros(numBins, 1);

    for bin = 0:numBins-1
        histCount(bin + 1) = sum(binIndices == bin);
    end

    // Compute the cumulative distribution function (CDF)
    cdf = cumsum(histCount) / (row * col);

    // Map each pixel intensity using the CDF
    equi_hist = matrix(cdf(binIndices + 1), row, col);

endfunction
