function [peaksnr, snr] = psnr(A, ref, peak)

    // argn(2) is the Scilab equivalent of nargin
    if argn(2) < 2 | argn(2) > 3 then
        error("psnr: Wrong number of input arguments.");

    // size_equal(A, ref) replaced with element-wise size comparison
    elseif or(size(A) <> size(ref)) then
        error("psnr: A and REF must be of same size");

    // class() replaced with typeof() in Scilab
    elseif typeof(A) <> typeof(ref) then
        error("psnr: A and REF must have same class");
    end

    if argn(2) < 3 then

        // Octave: peak = getrangefromclass(A)(2)
        // Scilab does not support indexing directly on function outputs
        peak = getrangefromclass(A);
        peak = peak(2);

    elseif ~isscalar(peak) then
        error("psnr: PEAK must be a scalar value");
    end

    if isinteger(A) then
        A = double(A);
        ref = double(ref);
    end

    mse = immse(A, ref);

    // Element-wise power operator .^ replaced by ^ since peak is scalar
    peaksnr = 10 * log10((peak^2) / mse);

    // argn(1) is the Scilab equivalent of nargout
    if argn(1) > 1 then

        // Octave:
        // sumsq(A(:)) / numel(A)
        // A(:), sumsq(), and numel() are implemented through helper functions
        snr = 10 * log10((sumsq(A(:)) / numel(A)) / mse);

    end

endfunction


// ----------------------------------------------------
// Helper Functions
// ----------------------------------------------------

// Octave isinteger() equivalent
function isint = isinteger(x)
    isint = or(typeof(x) == ["int8","uint8","int16","uint16","int32","uint32","int64","uint64"]);
endfunction


// Octave sumsq() equivalent
function s = sumsq(x)
    s = sum(x(:).^2);
endfunction


// Octave numel() equivalent
function n = numel(x)
    n = size(x, "*");
endfunction
