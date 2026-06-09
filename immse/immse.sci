function mse = immse(x, y)

    // Check number of input arguments
    if argn(2) <> 2 then
        error("immse: Two input arguments required.");
    // Check whether X and Y have the same size
    elseif or(size(x) <> size(y)) then
        error("immse: X and Y must be of same size");
    // Check whether X and Y have the same data type
    elseif typeof(x) <> typeof(y) then
        error("immse: X and Y must have same class");
    end

    // Convert integer images to double
    if typeof(x) == "uint8" | typeof(x) == "uint16" | ...
       typeof(x) == "int8"  | typeof(x) == "int16"  | ...
       typeof(x) == "int32" | typeof(x) == "uint32" then

        x = double(x);
        y = double(y);
    end

    // Compute error image
    err = x - y;

    // Mean Squared Error
    mse = sum(err(:).^2) / size(err, "*");

endfunction
