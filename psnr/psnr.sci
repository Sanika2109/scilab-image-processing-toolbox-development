function [peaksnr, snr] = psnr(A, ref, peak)

    // Check number of input arguments
    if argn(2) < 2 | argn(2) > 3 then
        error("psnr: Wrong number of input arguments.");
    
    // Check whether A and REF have the same dimensions
    elseif or(size(A) <> size(ref)) then
        error("psnr: A and REF must be of same size");
    
    // Check whether A and REF have the same class
    elseif typeof(A) <> typeof(ref) then
        error("psnr: A and REF must have same class");
    end

    // Assign default peak value if not provided
    if argn(2) < 3 then
        peak = getrangefromclass(A);
        peak = peak(2);

    // Verify that peak is scalar
    elseif size(peak, "*") <> 1 then
        error("psnr: PEAK must be a scalar value");
    end

    // Convert integer images to double
    if typeof(A) == "uint8" | typeof(A) == "uint16" | ...
       typeof(A) == "int8"  | typeof(A) == "int16"  | ...
       typeof(A) == "int32" | typeof(A) == "uint32" then

        A   = double(A);
        ref = double(ref);
    end

    // Compute Mean Squared Error
    mse = immse(A, ref);

    // Compute Peak Signal-to-Noise Ratio
    peaksnr = 10 * log10((peak^2) / mse);

    // Compute Signal-to-Noise Ratio
    snr = 10 * log10((sum(A(:).^2) / size(A, "*")) / mse);

endfunction
