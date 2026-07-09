# qtdecomp
## Description
- The qtdecomp function performs quadtree decomposition of a square image, recursively splitting it into smaller square blocks until each block satisfies a stopping criterion.
- The number of arguments passed must be at least 1.
- The result is a sparse matrix `S` of the same size as the input image, where each nonzero entry marks the top-left corner of a final (un-split) block and records that block's side length. Three splitting rules are supported: uniform-value blocks only (no second argument), a numeric intensity-range threshold, or a user-supplied decision function.
## Calling Sequence
```
S = qtdecomp(I)
S = qtdecomp(I, threshold)
S = qtdecomp(I, threshold, mindim)
S = qtdecomp(I, threshold, [mindim maxdim])
S = qtdecomp(I, fun)
S = qtdecomp(I, fun, ...)
```
## Parameters
`I` - A 2-D square image to decompose (any numeric class; `uint8`/`uint16` receive special threshold scaling).

`p1` - (Optional) Either a numeric splitting threshold, or a function handle / inline function used as a custom split decision. If omitted, blocks are split until every remaining block is uniform (all pixels equal).

`varargin(1)` (`dims`) - (Optional, threshold mode only) Either a single value `mindim`, or a two-element vector `[mindim maxdim]` bounding the allowed block sizes. Defaults to `mindim = 1`, `maxdim = size(I,1)`.

`varargin(2:)` - (Optional, function-handle mode only) Additional arguments forwarded to `fun` on every call.

`S` - Output. Quadtree decomposition sparse matrix, same size as `I`. `S(r,c) = d` marks `(r,c)` as the top-left corner of a final `d×d` block; all other entries are `0`.
# Examples
## 1 — 1×1 Image
      I = 1;
      S = full(qtdecomp(I))
##
      A valid decomposition matrix is returned; no subdivision occurs, and the single pixel is represented as one block.
## 2 — Odd-Sized Identity Matrix (5×5)
      I = eye(5,5);
      S = full(qtdecomp(I))
##
      Decomposition succeeds without errors; internal padding is handled automatically, and blocks containing diagonal transitions may be subdivided.
## 3 — Even-Sized Identity Matrix (6×6)
      I = eye(6,6);
      S = full(qtdecomp(I))
##
      Successful decomposition; internal resizing or padding is handled automatically, and non-uniform regions are subdivided.
## 4 — Power-of-Two Identity Matrix (8×8)
      I = eye(8,8);
      S = full(qtdecomp(I))
##
      No padding is required; regions intersecting the diagonal are subdivided while uniform regions remain large blocks.
## 5 — Near-Uniform Image
      I = ones(8,8);
      I(4:5,4:5) = 3;
      S = full(qtdecomp(I))
##
      Most of the image remains a large block; the altered central region triggers local subdivision concentrated near the intensity change.
## 6 — Uniform Zero Image
      I = zeros(8,8);
      S = full(qtdecomp(I))
##
      A single large block represents the image; no recursive splitting occurs.
## 7 — Checkerboard Pattern
      I = [
      0 1 0 1;
      1 0 1 0;
      0 1 0 1;
      1 0 1 0
      ];
      S = full(qtdecomp(I))
##
      Extensive subdivision occurs; many blocks reach the minimum allowable size, preserving fine image detail.
## 8 — Threshold = 0
      I = [
      1 1 1 1;
      1 1 1 1;
      1 1 2 2;
      1 1 2 2
      ];
      S = full(qtdecomp(I,0))
##
      Any intensity variation triggers subdivision; mixed-value regions are recursively split, and only perfectly uniform blocks remain unsplit.
## 9 — Threshold = 1
      I = [
      1 1 1 1;
      1 1 1 1;
      1 1 2 2;
      1 1 2 2
      ];
      S = full(qtdecomp(I,1))
##
      Fewer subdivisions compared with Test Case 8; regions differing by at most one intensity level may remain unsplit.
## 10 — Minimum Block Size Restriction
      S = full(qtdecomp(I, 0, 4))
##
      No block smaller than 4×4 is generated; recursive subdivision stops at the specified limit.
## 11 — Minimum and Maximum Block Size Constraints
      S = full(qtdecomp(I, 0, [2 4]))
##
      All generated blocks have dimensions between 2 and 4; blocks larger than 4 are forced to split, and blocks smaller than 2 are not produced.
## 12 — Regression Matrix A
      S = full(qtdecomp(A))
##
      Mixed regions are subdivided; homogeneous regions remain intact, consistent with Octave behavior.
## 13 — Regression Matrix A with Threshold = 5
      S = full(qtdecomp(A,5))
##
      Fewer subdivisions than the default configuration; small variations within blocks are tolerated.
## 14 — Regression Matrix A with Threshold = 10
      S = full(qtdecomp(A,10))
##
      Significantly fewer blocks than Tests 12 and 13; larger image regions remain unsplit.
## 15 — Function Handle Criterion
      function y = first_eq(B, varargin)
          y = squeeze(B(1,1,:) <> 54);
          y = y(:);
      endfunction
      S = full(qtdecomp(A, first_eq))
##
      Splitting decisions follow the custom function; blocks whose first element differs from 54 are subdivided, bypassing standard threshold logic.
## 16 — Non-Square Image (Invalid Input)
      I = rand(4,5);
      qtdecomp(I)
##
      Error : the image must be square.
## 17 — Invalid Dimension Limits (Invalid Input)
      I = eye(8,8);
      qtdecomp(I,0,[4 2])
##
      Error : the minimum block size cannot exceed the maximum block size.
## 18 — Large Uniform Image
      I = ones(64,64);
      S = full(qtdecomp(I))
##
      Minimal decomposition occurs; the image is represented using a single large block, and execution remains efficient.
## 19 — Unsigned Integer Image
      I = uint8(ones(4,4)*10);
      S = full(qtdecomp(I, 0.1))
##
      Integer image types are accepted; decomposition behaves consistently with floating-point inputs, and no unnecessary splitting occurs.
## 20 — Sparse Output Structure
      I = [
      1 1 2 2;
      1 1 2 2;
      3 3 4 4;
      3 3 4 4
      ];
      S = qtdecomp(I);
      disp(typeof(S))
##
      The output object is sparse; converting to full format correctly reconstructs the decomposition matrix.
