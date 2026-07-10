function J = qtsetblk(I, S, dim, vals)
  // Get the number of input arguments
  [lhs, rhs] = argn(0);
  if (rhs ~= 4) then
    error("Wrong number of input arguments");
  end

  // get blocks
  [ii, ji] = find(S);
  // Extract values at the indices
  v = S(find(S));

  // filter the ones which match dim
  idx = find(v == dim);
  if (size(vals, 3) < length(idx)) then
    error("qtsetblk: k (vals 3rd dimension) is not equal to number of blocks.");
  end
  ii = ii(idx);
  ji = ji(idx);

  J = I;
  
  // Only calculate ending vertices and replace if there are matching blocks
  if length(idx) > 0 then
    // calc end vertex
    ie = ii + dim - 1;
    je = ji + dim - 1;

    for b = 1:length(idx)
      J(ii(b):ie(b), ji(b):je(b)) = vals(:, :, b);
    end
  end
endfunction
