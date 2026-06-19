function mse = immse(x, y)

    // Validate number of input arguments
    if argn(2) <> 2 then
        error("immse: Wrong number of input arguments.");

    // Both inputs must have identical dimensions
    elseif or(size(x) <> size(y)) then
        error("immse: X and Y must be of same size");
    end

    // Both inputs must belong to the same data type
    if typeof(x) <> typeof(y) then
        error("immse: X and Y must have same class");
    end

    // Convert integer inputs to double before arithmetic
    if isinteger(x) then
        x = double(x);
        y = double(y);
    end

    // Compute element-wise error
    err = x - y;

    // Mean Squared Error = sum of squared errors / number of elements
    mse = sumsq(matrix(err, -1, 1)) / numel(err);

endfunction


// Helper Functions

// Returns true if x is of any integer data type
function isint = isinteger(x)
    isint = or(typeof(x) == ["int8","uint8","int16","uint16","int32","uint32","int64","uint64"]);
endfunction


// Computes sum of squares of all elements
function s = sumsq(x)
    s = sum(x(:).^2);
endfunction


// Returns total number of elements in x
function n = numel(x)
    n = size(x, "*");
endfunction
