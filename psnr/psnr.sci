function [peaksnr, snr] = psnr(A, ref, peak)

    // Validate input arguments, size, and data type
    if argn(2) < 2 | argn(2) > 3 then
        error("psnr: Wrong number of input arguments.");

    elseif or(size(A) <> size(ref)) then
        error("psnr: A and REF must be of same size");

    elseif typeof(A) <> typeof(ref) then
        error("psnr: A and REF must have same class");
    end

    // Use the maximum value of the input class if PEAK is not provided
    if argn(2) < 3 then
        peak = getrangefromclass(A);
        peak = peak(2);

    elseif ~isscalar(peak) then
        error("psnr: PEAK must be a scalar value");
    end

    // Convert integer inputs to double before calculations
    if isinteger(A) then
        A = double(A);
        ref = double(ref);
    end

    // Compute Mean Squared Error between A and REF
    mse = immse(A, ref);

    // Peak Signal-to-Noise Ratio (PSNR)
    peaksnr = 10 * log10((peak^2) / mse);

    // Compute Signal-to-Noise Ratio (SNR) if requested
    if argn(1) > 1 then

        snr = 10 * log10((sumsq(A(:)) / numel(A)) / mse);

    end

endfunction

// ----------------------------------------------------
// Helper Functions
// ----------------------------------------------------

// Returns true if x belongs to an integer data type
function isint = isinteger(x)
    isint = or(typeof(x) == ["int8","uint8","int16","uint16","int32","uint32","int64","uint64"]);
endfunction


// Computes the sum of squares of all elements
function s = sumsq(x)
    s = sum(x(:).^2);
endfunction


// Returns the total number of elements in x
function n = numel(x)
    n = size(x, "*");
endfunction
