function S = qtdecomp(I, p1, varargin)

  nargin = argn(2);

  // Validate input image and number of arguments
  if (nargin < 1) then
    error("qtdecomp: invalid number of arguments");
  elseif (~issquare(I)) then
    error("qtdecomp: I should be square.");
  end

  curr_size = size(I, 1);

  // Smallest and largest block sizes allowed during decomposition
  mindim = 1;
  maxdim = curr_size;

  if (nargin < 2) then

    // Default mode: split blocks until all pixels within a block are equal
    decision_method = 0;

  elseif (typeof(p1) == "function" | typeof(p1) == "function handle" | typeof(p1) == "inline function" | typeof(p1) == "fptr") then

    // User-defined block splitting function
 
    fun = p1;
    decision_method = 2;

  elseif (isreal(p1)) then

    // Threshold-based decomposition
    threshold = p1;
    decision_method = 1;

    if (typeof(I) == "uint8") then
      threshold = threshold * 255;

    elseif (typeof(I) == "uint16") then
      threshold = threshold * 65535;
    end

    if (nargin > 3) then

      error("qtdecomp: invalid arguments");

    elseif (nargin == 3) then

      dims = varargin(1);

      if (isvector(dims) & length(dims) == 2) then

        // User specified [mindim maxdim]
        mindim = dims(1);
        maxdim = dims(2);

      elseif (isreal(dims)) then

        // User specified only minimum block size
        mindim = dims;

      else

        error("qtdecomp: third parameter must be mindim or range [mindim maxdim]");

      end

    end

  else

    error("qtdecomp: second parameter must be a integer (threshold) or a function handle (fun).");

  end

  res = [];
  // Stores coordinates and sizes of terminal blocks

  finished = %f;

  offsets = [1, 1];
  // Initial block covers the entire image

  if (maxdim < mindim) then
    error("qtdecomp: mindim must be smaller than maxdim.");
  end

  if (maxdim < curr_size) then

    // Force initial subdivision until block size satisfies maxdim
    initial_splits = ceil(log2(curr_size / maxdim));

    if (initial_splits > 0) then

      divs = 2 ^ initial_splits;

      if (modulo(curr_size, divs) <> 0) then
        error("qtdecomp: Cant decompose I enough times to fulfill maxdim requirement.");
      end

      curr_size = curr_size / divs;

      if (curr_size < mindim) then
        error("qtdecomp: maxdim restriction collides with mindim restriction.");
      end

      els = ([0:divs-1] * curr_size + 1).';

      // Generate coordinates of all starting blocks
      offsets = [ ...
        kron(els, ones(divs,1)), ...
        kron(ones(divs,1), els) ...
      ];

    end

  end

  while (~finished & size(offsets,1) > 0)

    // Stop splitting if blocks cannot be halved further
    if ((modulo(curr_size,2) <> 0) | ((curr_size / 2) < mindim)) then

      res = [res; offsets, ones(size(offsets,1),1) * curr_size];

      finished = %t;

    else

      if (decision_method < 2) then

        // Split decision for each candidate block
        db = %t * ones(size(offsets,1),1);

        for r = 1:size(offsets,1)

          o = offsets(r,:);
          fo = offsets(r,:) + curr_size - 1;

          if (decision_method == 0) then

            // is everything equal?
            if (and(I(o(1),o(2)) == I(o(1):fo(1), o(2):fo(2)))) then
               db(r) = 0;
            end

          else

            t = I(o(1):fo(1), o(2):fo(2));
            t = t(:);

            // Split if intensity range exceeds threshold
            if ((max(t) - min(t)) <= threshold) then
              db(r) = 0;
            end

          end

        end

      elseif (decision_method == 2) then

        // Collect blocks and pass them to user-defined decision function
        b = zeros(curr_size, curr_size, size(offsets,1));

        rbc = offsets(:,1:2) + curr_size - 1;

        for r = 1:size(offsets,1)

          b(:,:,r) = I(offsets(r,1):rbc(r,1), ...
                       offsets(r,2):rbc(r,2));

        end

        db = fun(b, varargin(:));

      else

        error("qtdecomp: execution shouldnt reach here. Please report this as a bug.");

      end

      // Store blocks that do not require further subdivision
      nd = offsets(find(~db), :);
      res = [res; nd, ones(size(nd,1),1) * curr_size];

      // Move to the next quadtree level
      curr_size = curr_size / 2;

      // Create four child quadrants for blocks marked for splitting
      otemp = offsets(find(db), :);

      hs = ones(size(otemp,1),1) * curr_size;
      zs = zeros(size(hs,1), size(hs,2));

      offsets = [ ...
        otemp;
        otemp + [hs, zs];
        otemp + [zs, hs];
        otemp + [hs, hs]
      ];

    end

  end

  // Build sparse quadtree representation:
  // x stores top-left coordinates of terminal blocks.
  // v stores the corresponding block sizes.

  x = res(:,1:2);
  v = res(:,3);

  S = sparse(x, v, [size(I,1), size(I,2)]);

endfunction
