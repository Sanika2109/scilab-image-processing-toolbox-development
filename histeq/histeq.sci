function J = histeq(I, n)

    // Default value for n
    if argn(2) < 2 then
        n = 64;
    end

    // Check number of input arguments
    if argn(2) < 1 | argn(2) > 2 then
        error("histeq: Wrong number of input arguments.");
    end

    // Handle empty input
    if isempty(I) then
        J = [];
        return;
    end

    // Get image dimensions
    [r, c] = size(I);

    // Convert image to range [0,1]
    I = mat2gray(I);

    // Convert grayscale image to indexed image
    X = floor(I * (n - 1)); 

    // Compute histogram
    [nn, xx] = imhist(I, n);

    // Compute cumulative distribution function (CDF)
    Icdf = (1 / prod(size(I))) * cumsum(nn);

    // Map pixels using the CDF
    J = matrix(Icdf(X + 1), r, c);

endfunction
