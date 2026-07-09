# qtsetblk
## Description
- The qtsetblk function replaces blocks of a specified size in an image with new pixel values, using a quadtree decomposition matrix to locate those blocks.
- The number of arguments passed must be equal to 4.
- It is the companion-write function to `qtgetblk`: it copies each page of `vals` into the corresponding `dim×dim` region of the output image `J`. All pixels that do not belong to a matching block are copied from `I` unchanged. If no block of size `dim` exists in `S`, `J` is returned as an unmodified copy of `I`.
## Calling Sequence
`J = qtsetblk(I, S, dim, vals)`
## Parameters
`I` - A 2-D image whose blocks are to be replaced (the original image that was quadtree-decomposed).

`S` - A quadtree decomposition matrix, as returned by `qtdecomp`. A nonzero entry `S(r,c) = dim` marks `(r,c)` as the top-left corner of a `dim×dim` block.

`dim` - Block size to replace. Only blocks whose recorded size in `S` exactly equals `dim` are affected.

`vals` - Stack of replacement blocks. Must be `dim×dim×k` where `k ≥` the number of matching blocks in `S`. Pages are written in column-major traversal order of `S`.

`J` - Output. Copy of `I` with every matching `dim×dim` block replaced by the corresponding page of `vals`.
# Examples
## 1 — Replace a Single 2×2 Block at an Interior Position
      I = [10 11 12 13;
           20 21 22 23;
           30 31 32 33;
           40 41 42 43];
      S = zeros(4,4);
      S(3,3) = 2;
      vals = [100 101;
              102 103];
      J = qtsetblk(I, S, 2, vals)
##
      J =
          10   11   12   13
          20   21   22   23
          30   31  100  101
          40   41  102  103
## 2 — Replace Four 2×2 Quadrants
      I = [10 11 12 13;
           20 21 22 23;
           30 31 32 33;
           40 41 42 43];
      S = zeros(4,4);
      S(1,1) = 2;  S(1,3) = 2;
      S(3,1) = 2;  S(3,3) = 2;
      vals(:,:,1) = [101 102; 103 104];
      vals(:,:,2) = [201 202; 203 204];
      vals(:,:,3) = [301 302; 303 304];
      vals(:,:,4) = [401 402; 403 404];
      J = qtsetblk(I, S, 2, vals)
##
      J =
         101  102  301  302
         103  104  303  304
         201  202  401  402
         203  204  403  404
## 3 — Replace a Single 1×1 Block (Individual Pixel)
      I = [11 12 13 14 15;
           21 22 23 24 25;
           31 32 33 34 35;
           41 42 43 44 45;
           51 52 53 54 55];
      S = zeros(5,5);
      S(3,3) = 1;
      vals = 999;
      J = qtsetblk(I, S, 1, vals)
##
      J =
          11   12   13   14   15
          21   22   23   24   25
          31   32  999   34   35
          41   42   43   44   45
          51   52   53   54   55
## 4 — Replace a 4×4 Block Inside a Larger Image
      I = [11 12 13 14 15 16;
           21 22 23 24 25 26;
           31 32 33 34 35 36;
           41 42 43 44 45 46;
           51 52 53 54 55 56;
           61 62 63 64 65 66];
      S = zeros(6,6);
      S(2,2) = 4;
      vals = [100 101 102 103;
              110 111 112 113;
              120 121 122 123;
              130 131 132 133];
      J = qtsetblk(I, S, 4, vals)
##
      J =
          11   12   13   14   15   16
          21  100  101  102  103   26
          31  110  111  112  113   36
          41  120  121  122  123   46
          51  130  131  132  133   56
          61   62   63   64   65   66
## 5 — Replace a Central 2×2 Block in a Larger Image
      I = [11 12 13 14 15 16;
           21 22 23 24 25 26;
           31 32 33 34 35 36;
           41 42 43 44 45 46;
           51 52 53 54 55 56;
           61 62 63 64 65 66];
      S = zeros(6,6);
      S(3,3) = 2;
      vals = [100 101;
              102 103];
      J = qtsetblk(I, S, 2, vals)
##
      J =
          11   12   13   14   15   16
          21   22   23   24   25   26
          31   32  100  101   35   36
          41   42  102  103   45   46
          51   52   53   54   55   56
          61   62   63   64   65   66
## 6 — Mixed Decomposition Sizes, Replace Only dim = 2
      I = [ 1  2  3  4  5  6  7  8;
            9 10 11 12 13 14 15 16;
           17 18 19 20 21 22 23 24;
           25 26 27 28 29 30 31 32;
           33 34 35 36 37 38 39 40;
           41 42 43 44 45 46 47 48;
           49 50 51 52 53 54 55 56;
           57 58 59 60 61 62 63 64];
      S = zeros(8,8);
      S(1,1) = 4;   // not replaced
      S(1,5) = 2;   // replaced
      S(5,1) = 2;   // replaced
      S(7,7) = 1;   // not replaced
      vals(:,:,1) = [100 101; 102 103];
      vals(:,:,2) = [200 201; 202 203];
      J = qtsetblk(I, S, 2, vals)
##
      J =
           1    2    3    4  200  201    7    8
           9   10   11   12  202  203   15   16
          17   18   19   20   21   22   23   24
          25   26   27   28   29   30   31   32
         100  101   35   36   37   38   39   40
         102  103   43   44   45   46   47   48
          49   50   51   52   53   54   55   56
          57   58   59   60   61   62   63   64
## 7 — No Matching Blocks
      I = [11 12 13 14 15 16;
           21 22 23 24 25 26;
           31 32 33 34 35 36;
           41 42 43 44 45 46;
           51 52 53 54 55 56;
           61 62 63 64 65 66];
      S = zeros(6,6);
      S(1,1) = 4;
      S(5,5) = 1;
      vals = [100 101;
              102 103];
      J = qtsetblk(I, S, 2, vals)
##
      J is identical to I. No entry in S equals dim = 2, so the supplied vals is never read.
## 8 — Empty Decomposition Matrix
      I = [1 2 3;
           4 5 6;
           7 8 9];
      S = zeros(3,3);
      vals = [99 98;
              97 96];
      J = qtsetblk(I, S, 2, vals)
##
      J is identical to I. S contains no nonzero entries, so the function returns immediately.
## 9 — Extra Pages in vals Are Silently Ignored
      I = [11 12 13 14;
           21 22 23 24;
           31 32 33 34;
           41 42 43 44];
      S = zeros(4,4);
      S(2,2) = 2;
      vals(:,:,1) = [100 101; 102 103];
      vals(:,:,2) = [999 999; 999 999];
      vals(:,:,3) = [ -1  -1;  -1  -1];
      J = qtsetblk(I, S, 2, vals)
##
      J =
          11   12   13   14
          21  100  101   24
          31  102  103   34
          41   42   43   44
## 10 — Insufficient Pages in vals (Invalid Input)
      I = [1  2  3  4;
           5  6  7  8;
           9 10 11 12;
          13 14 15 16];
      S = zeros(4,4);
      S(1,1) = 2;
      S(3,3) = 2;    // 2 matching blocks
      vals(:,:,1) = [100 101;
                     102 103];   // only 1 page supplied
      J = qtsetblk(I, S, 2, vals)
##
      Error : qtsetblk: k (vals 3rd dimension) is not equal to number of blocks.
