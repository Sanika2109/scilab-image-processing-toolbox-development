function mse = immse(A, B)

    // Ensure exactly two input arguments are provided
    if argn(2) <> 2 then
        error("immse requires exactly two input arguments.");
    end

    // Check whether input images are empty
    if size(A, "*") == 0 | size(B, "*") == 0 then
        error("Input images cannot be empty.");
    end

    // Verify that both images have the same dimensions
    if or(size(A) <> size(B)) then
        error("Input images must have the same dimensions.");
    end

    // Convert images to double type for arithmetic operations
    A = double(A);
    B = double(B);

    // Compute difference between corresponding pixels
    diff = A - B;

    // Calculate Mean Squared Error (MSE)
    // MSE = average of squared pixel differences
    mse = mean(diff.^2);

endfunction
