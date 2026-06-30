function B = postpad(A, l, c, dim)

    rhs = argn(2);

    if rhs < 2 then
        error("postpad: invalid number of arguments");
    end

    // Default padding value is 0
    if rhs < 3 | isempty(c) then
        c = 0;
    elseif ~isscalar(c) then
        error("postpad: third argument must be a scalar");
    end

    if ~isscalar(l) | l < 0 | l <> fix(l) then
        error("postpad: second argument must be a non-negative integer");
    end

    sz = size(A);

    // Use the first non-singleton dimension if DIM is not specified
    if rhs < 4 then
        idx = find(sz > 1);

        if isempty(idx) then
            dim = 1;
        else
            dim = idx(1);
        end
    elseif ~isscalar(dim) | dim < 1 | dim <> fix(dim) then
        error("postpad: DIM must be a positive integer");
    end

    // Extend size vector for 1-D and 2-D arrays
    if length(sz) < 3 then
        sz(3) = 1;
    end

    d = sz(dim);

    // Return input unchanged if already the requested length
    if d == l then
        B = A;
        return;
    end

    //--------------------------------------------------
    // Dimension 1
    //--------------------------------------------------
    if dim == 1 then

        if d > l then
            // Truncate rows
            B = A(1:l,:,:);
        else
            // Pad rows
            B = c * ones(l, sz(2), sz(3));
            B(1:d,:,:) = A;
        end

    //--------------------------------------------------
    // Dimension 2
    //--------------------------------------------------
    elseif dim == 2 then

        if d > l then
            // Truncate columns
            B = A(:,1:l,:);
        else
            // Pad columns
            B = c * ones(sz(1), l, sz(3));
            B(:,1:d,:) = A;
        end

    //--------------------------------------------------
    // Dimension 3
    //--------------------------------------------------
    elseif dim == 3 then

        if d > l then
            // Truncate along third dimension
            B = A(:,:,1:l);
        else
            // Pad along third dimension
            B = c * ones(sz(1), sz(2), l);
            B(:,:,1:d) = A;
        end

    //--------------------------------------------------
    // Higher dimensions
    //--------------------------------------------------
    else

        error("postpad: dimensions greater than 3 are not implemented");

    end

endfunction
