function varargout = qtgetblk(I, S, dim)

  // Get number of input and output arguments
  rhs = argn(2);
  lhs = argn(1);

  // Validate number of inputs and outputs
  if (rhs <> 3 | lhs > 3) then
    error("qtgetblk: Wrong number of input/output arguments.");
  end

  // Find all nonzero entries in the quadtree decomposition matrix S
  idx_all = find(S);

  if size(idx_all, "*") > 0 then

    // Convert linear indices to row and column subscripts
    i = modulo(idx_all - 1, size(S, 1)) + 1;
    j = floor((idx_all - 1) / size(S, 1)) + 1;

    // Extract corresponding values from S
    v = S(idx_all);

  else

    i = [];
    j = [];
    v = [];

  end

  // Select only those blocks whose size matches dim
  idx = find(v == dim);

  // Return empty outputs if no matching blocks exist
  if length(idx) == 0 then

    for i = 1:lhs
      varargout(i) = [];   
    end

  else

    // Row and column coordinates of matching blocks
    r = i(idx);
    c = j(idx);

    // Create output array to store extracted blocks
    vals = zeros(dim, dim, length(idx));

    // Extract each dim-by-dim block from image I
    for k = 1:length(idx)
      vals(:, :, k) = I(r(k):r(k)+dim-1, c(k):c(k)+dim-1);
    end

    // First output: extracted blocks
    varargout(1) = vals;   

    // Additional outputs depend on number of requested outputs
    if lhs == 3 then       

      // Return row and column coordinates
      varargout(2) = r;
      varargout(3) = c;

    elseif lhs == 2 then   

      // Return linear indices of block locations
      varargout(2) = (c - 1) * size(I, 1) + r;

    end

  end

endfunction
