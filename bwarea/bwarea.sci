function binaryobj_area = bwarea(bw)

    // Check number of arguments
    if argn(2) <> 1 then
        error("bwarea: one input argument required.");
    end

    // Check if image is 2D
    if ndims(bw) <> 2 then
        error("bwarea: input image must be a 2D image");
    end

    // Convert any nonzero pixel to foreground (1) and zero pixels to background (0)
    bw = bw <> 0;

    // Define 2×2 kernels used for pattern detection
    // ---------------------------------------------------------
    // Kernel of all ones
    // Used to count the number of foreground pixels in every 2×2 neighborhood
    four = ones(2,2);

    // Diagonal kernel
    // Helps distinguish adjacent-pixel patterns from diagonal-pixel patterns
    two = [1 0;
           0 1];

    // Convolution operations
    // For each 2×2 neighborhood, fours contains the total number of foreground pixels (0–4)
    fours = conv2(double(bw), four);

    // Used for identifying diagonal configurations
    twos = conv2(double(bw), two);

    // Count configurations

    // Q1 : Neighborhoods containing exactly 1 foreground pixel
    Q1 = sum(fours == 1);
    
    // QA : Neighborhoods containing exactly two foreground pixels (adjacent pair)
    QA = sum((fours == 2) & (twos == 1));
    
    // QD : Neighborhoods containing exactly two foreground pixels (diagonal pair)
    QD = sum((fours == 2) & (twos <> 1));

    // Q3 : Neighborhoods containing exactly three foreground pixels
    Q3 = sum(fours == 3);

    // Q4 : Neighborhoods completely filled with four foreground pixels
    Q4 = sum(fours == 4);

    // Compute weighted area estimate
    binaryobj_area = 0.25*Q1 + 0.5*QA + 0.75*QD + 0.875*Q3 + Q4;

endfunction
