# qtgetblk
## Description
- The qtgetblk function extracts all blocks of a specified size from an image, given its quadtree decomposition matrix.
- The number of input arguments passed must be equal to 3; the number of output arguments requested must be 1, 2, or 3.
- It is the companion-retrieval function for `qtdecomp`: it scans the decomposition matrix `S` for every entry equal to a requested block size `dim`, and returns the actual pixel content of those blocks from the original image `I`, along with (optionally) their locations.
## Calling Sequence
```
vals = qtgetblk(I, S, dim)
[vals, idx] = qtgetblk(I, S, dim)
[vals, r, c] = qtgetblk(I, S, dim)
```
## Parameters
`I` - A 2-D image (the original image that was quadtree-decomposed).

`S` - A quadtree decomposition matrix, as returned by `qtdecomp`. A nonzero entry `S(r,c) = dim` marks `(r,c)` as the top-left corner of a `dim×dim` block.

`dim` - Block size to extract. Only blocks whose recorded size in `S` exactly equals `dim` are returned.

`vals` - Output. Stack of extracted `dim×dim` blocks, one per page along the third dimension. Empty (`[]`) if no block of size `dim` exists.

`idx` - Output (2-output form only). Linear (column-major) indices into `I` of each block's top-left corner.

`r`, `c` - Output (3-output form only). Row and column subscripts into `I` of each block's top-left corner.
# Examples
## 1 — Single 4×4 Block
      I = magic(4);
      S = zeros(4,4);
      S(1,1) = 4;
      [B, r, c] = qtgetblk(I, S, 4)
##
      B(:,:,1) =
        16   2   3  13
         5  11  10   8
         9   7   6  12
         4  14  15   1

      r = 1
      c = 1
## 2 — Four 2×2 Quadrants
      I = [ 1  2  5  6;
            3  4  7  8;
            9 10 13 14;
           11 12 15 16];
      S = zeros(4,4);
      S(1,1) = 2;
      S(1,3) = 2;
      S(3,1) = 2;
      S(3,3) = 2;
      [B, r, c] = qtgetblk(I, S, 2)
##
      Block 1 — B(:,:,1):         Block 2 — B(:,:,2):
         1   2                        9  10
         3   4                       11  12

      Block 3 — B(:,:,3):         Block 4 — B(:,:,4):
         5   6                       13  14
         7   8                       15  16

      r = [1; 3; 1; 3]
      c = [1; 1; 3; 3]
## 3 — Mixed Block Sizes
      I = matrix(1:64, 8, 8);
      S = zeros(8,8);
      S(1,1) = 4;
      S(1,5) = 2;
      S(5,1) = 2;
      S(7,7) = 1;
      [B, r, c] = qtgetblk(I, S, 2)
##
      B is 2×2×2

      Block 1 — B(:,:,1):     (top-left at row 5, col 1)
          5  13
          6  14

      Block 2 — B(:,:,2):     (top-left at row 1, col 5)
         33  41
         34  42

      r = [5; 1]
      c = [1; 5]
## 4 — Corner 1×1 Blocks
      I = magic(4);
      S = zeros(4,4);
      S(1,1) = 1;
      S(1,4) = 1;
      S(4,1) = 1;
      S(4,4) = 1;
      [B, r, c] = qtgetblk(I, S, 1)
##
      B is 1×1×4

      B(:,:,1) = 16    (pixel at row 1, col 1)
      B(:,:,2) = 4     (pixel at row 4, col 1)
      B(:,:,3) = 13    (pixel at row 1, col 4)
      B(:,:,4) = 1     (pixel at row 4, col 4)

      r = [1; 4; 1; 4]
      c = [1; 1; 4; 4]
## 5 — Central 2×2 Block
      I = matrix(1:36, 6, 6);
      S = zeros(6,6);
      S(3,3) = 2;
      [B, r, c] = qtgetblk(I, S, 2)
##
      B(:,:,1) =
        15  21
        16  22

      r = 3
      c = 3
## 6 — No Matching Block Size
      I = magic(4);
      S = zeros(4,4);
      S(1,1) = 4;
      [B, r, c] = qtgetblk(I, S, 2)
##
      B = []
      r = []
      c = []
## 7 — Empty Decomposition Matrix
      I = magic(4);
      S = zeros(4,4);
      [B, r, c] = qtgetblk(I, S, 2)
##
      B = []
      r = []
      c = []
## 8 — Scattered 2×2 Blocks
      I = matrix(1:64, 8, 8);
      S = zeros(8,8);
      S(1,5) = 2;
      S(5,1) = 2;
      S(5,5) = 2;
      [B, r, c] = qtgetblk(I, S, 2)
##
      r = [5; 1; 5]
      c = [1; 5; 5]

      Block 1 — B(:,:,1):     (top-left at row 5, col 1)
          5  13
          6  14

      Block 2 — B(:,:,2):     (top-left at row 1, col 5)
         33  41
         34  42

      Block 3 — B(:,:,3):     (top-left at row 5, col 5)
         37  45
         38  46
## 9 — Two-Output Form (Linear Indices)
      I = matrix(1:16, 4, 4);
      S = zeros(4,4);
      S(1,1) = 2;
      S(3,3) = 2;
      [B, idx] = qtgetblk(I, S, 2)
##
      B is 2×2×2

      Block 1 — B(:,:,1):     (top-left at row 1, col 1)
         1  5
         2  6

      Block 2 — B(:,:,2):     (top-left at row 3, col 3)
         11  15
         12  16

      idx = [1; 11]
## 10 — One-Output Form
      I = matrix(1:16, 4, 4);
      S = zeros(4,4);
      S(1,1) = 2;
      B = qtgetblk(I, S, 2)
##
      B(:,:,1) =
         1  5
         2  6
## 11 — Invalid Number of Input Arguments
      try
          qtgetblk();
      catch
          disp(lasterror());
      end
##
      Error : qtgetblk: Wrong number of input/output arguments.
