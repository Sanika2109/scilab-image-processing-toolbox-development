function [peaksnr, snr] = psnr(A, ref, peak)

    if argn(2) < 2 | argn(2) > 3 then
        error("psnr: Wrong number of input arguments.");

    elseif or(size(A) <> size(ref)) then
        error("psnr: A and REF must be of same size");

    elseif typeof(A) <> typeof(ref) then
        error("psnr: A and REF must have same class");
    end

    if argn(2) < 3 then
        peak = getrangefromclass(A);
        peak = peak(2);

    elseif size(peak, "*") <> 1 then
        error("psnr: PEAK must be a scalar value");
    end

    if isinteger(A) then
        A = double(A);
        ref = double(ref);
    end

    mse = immse(A, ref);

    peaksnr = 10 * log10((peak^2) / mse);

    if argn(1) > 1 then
        snr = 10 * log10 ((sumsq (A(:)) / numel (A)) / mse);
    end

endfunction

//Helper Functions
//isinteger function
function isint = isinteger(x)
    isint = or(typeof(x) == ["int8","uint8","int16","uint16","int32","uint32","int64","uint64"]);
endfunction

//sumsq function
function s = sumsq(x)
    s = sum(x(:).^2);
endfunction

//numel function
function n = numel(x)
    n = size(x, "*");
endfunction
