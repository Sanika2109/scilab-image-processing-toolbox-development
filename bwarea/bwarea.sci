function total = bwarea(bw)

    // Check number of input arguments
    if argn(2) <> 1 then
        error("bwarea: One input argument required.");

    // Verify input is a 2-D image
    elseif ndims(bw) <> 2 then
        error("bwarea: input image must be a 2D image");
    end

    // Convert non-logical inputs to binary
    if typeof(bw) <> "boolean" then
        bw = (bw <> 0);
    end

    four = ones(2,2);
    two  = diag([1 1]);

    fours = conv2(double(bw), four);
    twos  = conv2(double(bw), two);

    nQ1 = sum(fours(:) == 1);
    nQ3 = sum(fours(:) == 3);
    nQ4 = sum(fours(:) == 4);

    nQD = sum((fours(:) == 2) & (twos(:) <> 1));
    nQ2 = sum((fours(:) == 2) & (twos(:) == 1));

    total = 0.25*nQ1 + 0.5*nQ2 + 0.875*nQ3 + nQ4 + 0.75*nQD;

endfunction
