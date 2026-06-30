function c = normxcorr2 (a, b)
  
  rhs = argn(2); 
   
  if (rhs <> 2) then
    error("normxcorr2: Wrong number of input arguments.");
  end

  // Warn if the template is larger than the image
  if (ndims(a) > ndims(b) | or(postpad(size(a), ndims(b)) > size(b))) then
    warning("normxcorr2: TEMPLATE larger than IMG. Arguments may be swapped.");
  end

  // Convert inputs to double and remove their means
  a = double(a);
  a = a - mean(a(:));

  b = double(b);
  b = b - mean(b(:));

  // Prepare flipped template for cross-correlation
  a1 = ones(a);
  ar = matrix(a($:-1:1), size(a));

  // Compute cross-correlation
  c = conv2(b, conj(ar));

  // Compute local variance of the image
  b = conv2(b.^2, a1) - conv2(b, a1).^2 / prod(size(a));

  // Remove small negative values caused by numerical errors
  idx = find(b < 0);
  if idx <> [] then
     b(idx) = 0;
  end

  // Normalize the correlation values
  a = sumsq(a(:));
  c = matrix(c ./ sqrt(b * a), size(c));

  // Replace undefined values resulting from zero variance
  idx = find(isinf(c) | isnan(c));
  if idx <> [] then
     c(idx) = 0;
  end

endfunction


// Helper function: Returns the sum of squares of all elements
function s = sumsq(x)
    s = sum(x(:).^2);
endfunction
