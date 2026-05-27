function p = psnr(A, B, peak)

    // Verify that both input images have same dimensions
    if or(size(A) <> size(B)) then
        error("Input images must have same dimensions.");
    end

    // Convert images to double for mathematical calculations
    A = double(A);
    B = double(B);

    // Assign default peak value if not provided
    // Default value follows Octave-like behavior
    if argn(2) < 3 then
        peak = 1;
    end

    // Compute pixel-wise difference between images
    diff = A - B;

    // Calculate Mean Squared Error (MSE)
    mse = mean(diff.^2);

    // If images are identical, MSE becomes zero
    // PSNR is infinite in this case
    if mse == 0 then
        p = %inf;
        return;
    end

    // Compute Peak Signal-to-Noise Ratio (PSNR)
    // PSNR = 10 × log10((peak²)/MSE)
    p = 10 * log10((peak^2) / mse);

endfunction
