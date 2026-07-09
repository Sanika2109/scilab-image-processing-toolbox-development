# padarray
## Description
- The padarray function pads a 2-D or 3-D array along each of its dimensions, using either a constant fill value or a content-derived pattern.
- The number of arguments passed must be between 2 and 4.
- The input can be a 2-D matrix (M×N) or 3-D array (M×N×P), real or complex, of any Scilab numeric class. `ndims(A) > 3` is not supported.
- The border may be a constant value (`padval`, default `0`), or one of four content-derived patterns: `circular` (periodic wrap), `replicate` (edge extension), `symmetric` (mirror including the boundary element), or `reflect` (mirror excluding the boundary element). If `sum(padsize) == 0`, the output equals the input with no padding applied.
## Calling Sequence
```
B = padarray(A, padsize)
B = padarray(A, padsize, padval)
B = padarray(A, padsize, pattern)
B = padarray(A, padsize, padval_or_pattern, direction)
```
## Parameters
`A` - A 2-D matrix (M×N) or 3-D array (M×N×P). Real or complex, any Scilab numeric class.

`padsize` - A non-negative integer vector giving the padding amount per dimension: `[pr]` (rows only), `[pr pc]` (rows, columns), or `[pr pc pd]` (rows, columns, depth).

`padval` - (Optional, default `0`) Constant value used to fill the padded region. Ignored if `pattern` is supplied.

`pattern` - (Optional, default `""`, i.e. constant fill) One of `"zeros"`, `"circular"`, `"replicate"`, `"symmetric"`, `"reflect"`.

`direction` - (Optional, default `"both"`) One of `"pre"`, `"post"`, `"both"`. Controls which side(s) of each dimension receive padding.

`B` - Output. The padded array, of class/type identical to `A`.
# Examples
`A = [1 2; 3 4]` is used as the base matrix unless otherwise noted.
## 1 — Default Zero Padding (Both)
      disp(padarray(A,[1 1]))
##
      0   0   0   0
      0   1   2   0
      0   3   4   0
      0   0   0   0
## 2 — Explicit Zeros Padding (PRE)
      disp(padarray(A,[2 1],"zeros","pre"))
##
      0   0   0
      0   0   0
      0   1   2
      0   3   4
## 3 — Constant Padding (POST)
      disp(padarray(A,[1 2],5,"post"))
##
      1   2   5   5
      3   4   5   5
      5   5   5   5
## 4 — Complex Padding (%i) (BOTH)
      disp(padarray(A,[1 1],%i,"both"))
##
      i   i   i   i
      i   1   2   i
      i   3   4   i
      i   i   i   i
## 5 — Circular Padding (Large Padding)
      disp(padarray(A,[4 5],"circular","both"))
##
      2   1   2   1   2   1   2   1   2   1   2   1
      4   3   4   3   4   3   4   3   4   3   4   3
      2   1   2   1   2   1   2   1   2   1   2   1
      4   3   4   3   4   3   4   3   4   3   4   3
      2   1   2   1   2   1   2   1   2   1   2   1
      4   3   4   3   4   3   4   3   4   3   4   3
      2   1   2   1   2   1   2   1   2   1   2   1
      4   3   4   3   4   3   4   3   4   3   4   3
      2   1   2   1   2   1   2   1   2   1   2   1
      4   3   4   3   4   3   4   3   4   3   4   3
## 6 — Replicate Padding (PRE)
      disp(padarray(A,[2 2],"replicate","pre"))
##
      1   1   1   2
      1   1   1   2
      1   1   1   2
      3   3   3   4
## 7 — Symmetric Padding (POST)
      disp(padarray(A,[2 2],"symmetric","post"))
##
      1   2   2   1
      3   4   4   3
      3   4   4   3
      1   2   2   1
## 8 — Rectangular Matrix
      B = [1 2 3;
           4 5 6];
      disp(padarray(B,[2 1],"replicate","both"))
##
      1   1   2   3   3
      1   1   2   3   3
      1   1   2   3   3
      4   4   5   6   6
      4   4   5   6   6
      4   4   5   6   6
## 9 — Row Vector
      R = [1 2 3 4];
      disp(padarray(R,[0 3],9,"both"))
##
      9   9   9   1   2   3   4   9   9   9
## 10 — Column Vector
      C = [1; 2; 3; 4];
      disp(padarray(C,[3],8,"both"))
##
      8
      8
      8
      1
      2
      3
      4
      8
      8
      8
## 11 — Single Element Matrix
      disp(padarray(5,[2 2],"replicate"))
##
      5   5   5   5   5
      5   5   5   5   5
      5   5   5   5   5
      5   5   5   5   5
      5   5   5   5   5
## 12 — int16 Input
      I = int16([10 20; 30 40]);
      disp(padarray(I,[1 1],int16(-5),"both"))
##
      -5   -5   -5   -5
      -5   10   20   -5
      -5   30   40   -5
      -5   -5   -5   -5
## 13 — 3D Constant Padding
      X(:,:,1) = [1 2; 3 4];
      X(:,:,2) = [5 6; 7 8];
      Y = padarray(X,[1 1 1],0)
##
      Output Size: [4 4 4]

      Slice 1:            Slice 2:            Slice 3:            Slice 4:
      0  0  0  0           0  0  0  0           0  0  0  0           0  0  0  0
      0  0  0  0           0  1  2  0           0  5  6  0           0  0  0  0
      0  0  0  0           0  3  4  0           0  7  8  0           0  0  0  0
      0  0  0  0           0  0  0  0           0  0  0  0           0  0  0  0
## 14 — 3D Circular Padding (Depth Only)
      Y = padarray(X,[0 0 2],"circular")
##
      Output Size: [2 2 6]

      Slice 1: [1 2; 3 4]     Slice 3: [1 2; 3 4]     Slice 5: [1 2; 3 4]     Slice 6: [5 6; 7 8]
## 15 — Mixed Padding Sizes (Rows Only)
      disp(padarray(A,[3 0],"symmetric","both"))
##
      3   4
      3   4
      1   2
      1   2
      3   4
      3   4
      1   2
      1   2
