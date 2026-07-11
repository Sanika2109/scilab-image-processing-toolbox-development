function [varargout] = qtgetblk(I, S, dim)
  // Get number of input (rhs) and output (lhs) arguments
  [lhs, rhs] = argn(0); 
  
  if (rhs ~= 3 | lhs > 3) then
    error("Wrong number of input/output arguments");
  end

  // get blocks
  [i, j] = find(S);
  v = S(find(S));

  // filter the ones which match dim
  idx = find(v == dim);

  if (length(idx) == 0) then
    // Initialize varargout as a list
    varargout = list();
    for i = 1:lhs
      varargout(i) = [];
    end
  else
    r = i(idx)';
    c = j(idx)';

    // copy to a dim-by-dim-by-k array
    vals = zeros(dim, dim, length(idx));
    for i = 1:length(idx)
      vals(:, :, i) = I(r(i):r(i)+dim-1, c(i):c(i)+dim-1);
    end

    varargout = list();
    varargout(1) = vals;

    if (lhs == 3) then
      varargout(2) = r;
      varargout(3) = c;
    elseif (lhs == 2) then
      varargout(2) = (c - 1) * size(I, 1) + r;
    end
  end
endfunction
