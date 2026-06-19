function S = qtdecomp(I, p1, varargin)

  rhs = argn(2); 
  // Octave uses nargin 
  // Scilab uses rhs = argn(2)

  if (rhs < 1) then
    error("qtdecomp: invalid number of arguments");
  elseif (~issquare(I)) then
    error("qtdecomp: I should be square.");
  end

  curr_size = size(I, 1);
  // Current quadtree block size being processed.

  mindim = 1;
  // Minimum allowed block size.

  maxdim = curr_size;
  // Maximum allowed block size.

  if (rhs < 2) then

    decision_method = 0;

  elseif (typeof(p1) == "function" | typeof(p1) == "function handle" | typeof(p1) == "inline function" | typeof(p1) == "fptr") then
     // Octave uses typeinfo() to detect function handles and inline functions.
    // Scilab uses typeof(), and additional function-related types are checked
    // for compatibility across Scilab versions.

    fun = p1;
    decision_method = 2;

  elseif (isreal(p1)) then

    threshold = p1;
    decision_method = 1;

    if (typeof(I) == "uint8") then
      // Octave: strcmp(typeinfo(I), "uint8 matrix")
      // Scilab equivalent is typeof(I) == "uint8"        
      threshold = threshold * 255;
      
    elseif (typeof(I) == "uint16") then
      // Octave: strcmp(typeinfo(I), "uint16 matrix")
      // Scilab equivalent is typeof(I) == "uint16"   
      threshold = threshold * 65535;
    end

    if (rhs > 3) then

      error("qtdecomp: invalid arguments");

    elseif (rhs == 3) then

      dims = varargin(1);

      if (isvector(dims) & length(dims) == 2) then

        mindim = dims(1);
        maxdim = dims(2);
        

      elseif (isreal(dims)) then

        mindim = dims;

      else

        error("qtdecomp: third parameter must be mindim or range [mindim maxdim]");

      end

    end

  else

    error("qtdecomp: second parameter must be a integer (threshold) or a function handle (fun).");

  end

  res = [];
  // Stores final block coordinates and sizes.

  finished = %f;

  offsets = [1, 1];
  // Starting block position (entire image).

  if (maxdim < mindim) then
    error("qtdecomp: mindim must be smaller than maxdim.");
  end
  
  if (maxdim < curr_size) then

    initial_splits = ceil(log2(curr_size / maxdim));
    // Number of mandatory splits required to satisfy maxdim.

    if (initial_splits > 0) then

      divs = 2 ^ initial_splits;

      if (modulo(curr_size, divs) <> 0) then
        // Octave uses rem(); Scilab equivalent is modulo().
        error("qtdecomp: Cant decompose I enough times to fulfill maxdim requirement.");
      end

      curr_size = curr_size / divs;
      // Update block size after mandatory splitting.

      if (curr_size < mindim) then
        error("qtdecomp: maxdim restriction collides with mindim restriction.");
      end

      els = ([0:divs-1] * curr_size + 1).';

      offsets = [ ...
        kron(els, ones(divs,1)), ...
        kron(ones(divs,1), els) ...
      ];
      // Generate offsets for all initial blocks.

    end

  end

  while (~finished & size(offsets,1) > 0) 
      // Octave uses rows(offsets) 
      // Scilab equivalent is size(offsets,1)

    if ((modulo(curr_size,2) <> 0) | ((curr_size / 2) < mindim)) then
      // Octave uses rem(curr_size,2).
      // Scilab equivalent is modulo(curr_size,2).
      
      res = [res; offsets, ones(size(offsets,1),1) * curr_size];
      // Store blocks that cannot be subdivided further.

      finished = %t;

    else

      if (decision_method < 2) then

        db = %t * ones(size(offsets,1),1); // Octave: db=logical(ones(rows(offsets),1));
        // Decision vector: %t = split block, %f = keep block.
        
        for r = 1:size(offsets,1) // Octave: for r=1:rows(offsets)

          o = offsets(r,:);
          fo = offsets(r,:) + curr_size - 1;

          if (decision_method == 0) then

            blk = I(o(1):fo(1), o(2):fo(2));
            
            // Octave checks:
            // all(I(o(1),o(2)) == I(o(1):fo(1),o(2):fo(2)))
            // Scilab uses max()==min(), which is equivalent for determining
            // whether all pixels in the block have the same value.
            
            if max(blk) == min(blk) then
               db(r) = %f;
            end

          else

            t = I(o(1):fo(1), o(2):fo(2));
            t = t(:);
            // Convert block to a vector for range computation.

            if ((max(t) - min(t)) <= threshold) then
              db(r) = %f;
            end

          end

        end

      elseif (decision_method == 2) then

        b = zeros(curr_size, curr_size, size(offsets,1));
        // Stack candidate blocks for user-defined split decision.

        rbc = offsets(:,1:2) + curr_size - 1;

        for r = 1:size(offsets,1)

          b(:,:,r) = I(offsets(r,1):rbc(r,1), ...
                       offsets(r,2):rbc(r,2));

        end

        db = fun(b, varargin(:));
        // Octave uses: db = feval(fun, b, varargin{:})
        // Scilab can invoke function variables directly and passes the
        // variable argument list as a vectorized argument collection.

      else

        error("qtdecomp: execution shouldnt reach here. Please report this as a bug.");

      end
    
      nd = offsets(find(~db), :);
      // Blocks that will not be split further.

      res = [res; nd, ones(size(nd,1),1) * curr_size];
      // Add terminal blocks to result list.

      curr_size = curr_size / 2;
      // Move to the next quadtree level.
      
      otemp = offsets(find(db), :);
      // Blocks selected for subdivision.

      hs = ones(size(otemp,1),1) * curr_size;
      zs = zeros(size(hs,1), size(hs,2));
      
      offsets = [ ...
        otemp;
        otemp + [hs, zs];
        otemp + [zs, hs];
        otemp + [hs, hs]
      ];
      // Generate offsets for the four child quadrants.

    end

  end

  x = res(:,1:2);
  v = res(:,3);
  // Extract block coordinates and block sizes.

  S = sparse(x, v, [size(I,1), size(I,2)]);
  
  // Octave: S = sparse(res(:,1), res(:,2), res(:,3), size(I,1), size(I,2))
  // Scilab sparse() uses a different API. It accepts an index matrix
  // [row col], the corresponding values, and the final matrix dimensions.

endfunction
