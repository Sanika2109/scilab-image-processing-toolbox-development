function J = qtsetblk(I, S, dim, vals)

  rhs = argn(2);

  // Validate number of input arguments.
  if rhs <> 4 then
    error("qtsetblk: invalid number of arguments.");
  end

  // Find all nonzero entries in the decomposition matrix S.
  idx_all = find(S);

  if size(idx_all, "*") > 0 then

    // Convert linear indices into row and column coordinates.
    ii = modulo(idx_all - 1, size(S,1)) + 1;
    ji = floor((idx_all - 1) / size(S,1)) + 1;

    // Extract block sizes stored at the corresponding locations.
    v = S(idx_all);

  else

    // No blocks present in the decomposition matrix.
    ii = [];
    ji = [];
    v = [];

  end

  // Identify blocks whose size matches the requested dimension.
  idx = find(v == dim);

  // If no matching blocks exist, return the original image unchanged.
  if length(idx) == 0 then
    J = I;
    return;
  end

  // Ensure vals contains at least one page for each matching block.
  if size(vals, 3) < length(idx) then
    error("qtsetblk: k (vals 3rd dimension) is not equal to number of blocks.");
  end

  // Keep only coordinates corresponding to blocks of size dim.
  ii = ii(idx);
  ji = ji(idx);

  // Compute ending row and column indices of each block.
  ie = ii + dim - 1;
  je = ji + dim - 1;

  // Initialize output image.
  J = I;

  // Replace each matching block with the corresponding page from vals.
  for b = 1:length(idx)

    J(ii(b):ie(b), ji(b):je(b)) = vals(:, :, b);

  end

endfunction
