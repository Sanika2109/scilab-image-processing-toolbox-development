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
```scilab
I = 1;
S = full(qtdecomp(I))
```

**Output**

```text
1.
```

---

## 2 — Odd-Sized Identity Matrix (5×5)

```scilab
I = eye(5,5);
S = full(qtdecomp(I))
```

**Output**

```text
5.   0.   0.   0.   0.
0.   0.   0.   0.   0.
0.   0.   0.   0.   0.
0.   0.   0.   0.   0.
0.   0.   0.   0.   0.
```

---

## 3 — Even-Sized Identity Matrix (6×6)

```scilab
I = eye(6,6);
S = full(qtdecomp(I))
```

**Output**

```text
3.   0.   0.   3.   0.   0.
0.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.
3.   0.   0.   3.   0.   0.
0.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.
```

---

## 4 — Power-of-Two Identity Matrix (8×8)

```scilab
I = eye(8,8);
S = full(qtdecomp(I))
```

**Output**

```text
1.   1.   2.   0.   4.   0.   0.   0.
1.   1.   0.   0.   0.   0.   0.   0.
2.   0.   1.   1.   0.   0.   0.   0.
0.   0.   1.   1.   0.   0.   0.   0.
4.   0.   0.   0.   1.   1.   2.   0.
0.   0.   0.   0.   1.   1.   0.   0.
0.   0.   0.   0.   2.   0.   1.   1.
0.   0.   0.   0.   0.   0.   1.   1.
```

---

## 5 — Near-Uniform Image

```scilab
I = ones(8,8);
I(4:5,4:5) = 3;
S = full(qtdecomp(I))
```

**Output**

```text
2.   0.   2.   0.   2.   0.   2.   0.
0.   0.   0.   0.   0.   0.   0.   0.
2.   0.   1.   1.   1.   1.   2.   0.
0.   0.   1.   1.   1.   1.   0.   0.
2.   0.   1.   1.   1.   1.   2.   0.
0.   0.   1.   1.   1.   1.   0.   0.
2.   0.   2.   0.   2.   0.   2.   0.
0.   0.   0.   0.   0.   0.   0.   0.
```

---

## 6 — Uniform Zero Image

```scilab
I = zeros(8,8);
S = full(qtdecomp(I))
```

**Output**

```text
8.   0.   0.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
```

---

## 7 — Checkerboard Pattern

```scilab
I = [
0 1 0 1;
1 0 1 0;
0 1 0 1;
1 0 1 0
];
S = full(qtdecomp(I))
```

**Output**

```text
1.   1.   1.   1.
1.   1.   1.   1.
1.   1.   1.   1.
1.   1.   1.   1.
```

## 8 — Threshold = 0

```scilab
I = [
1 1 1 1;
1 1 1 1;
1 1 2 2;
1 1 2 2
];
S = full(qtdecomp(I,0))
```

**Output**

```text
2.   0.   2.   0.
0.   0.   0.   0.
2.   0.   2.   0.
0.   0.   0.   0.
```

---

## 9 — Threshold = 1

```scilab
I = [
1 1 1 1;
1 1 1 1;
1 1 2 2;
1 1 2 2
];
S = full(qtdecomp(I,1))
```

**Output**

```text
4.   0.   0.   0.
0.   0.   0.   0.
0.   0.   0.   0.
0.   0.   0.   0.
```

---

## 10 — Minimum Block Size Restriction

```scilab
I = [
1  1  2  2  3  3  4  4;
1  1  2  2  3  3  4  4;
5  5  6  6  7  7  8  8;
5  5  6  6  7  7  8  8;
9  9 10 10 11 11 12 12;
9  9 10 10 11 11 12 12;
13 13 14 14 15 15 16 16;
13 13 14 14 15 15 16 16
];
S = full(qtdecomp(I,0,2))
```

**Output**

```text
4.   0.   0.   0.   4.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
4.   0.   0.   0.   4.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
```

**Block uniqueness check**

```text
0.
```

---

## 11 — Minimum and Maximum Block Size Constraints

```scilab
I = [
1 1 1 1 2 2 2 2;
1 1 1 1 2 2 2 2;
1 1 1 1 2 2 2 2;
1 1 1 1 2 2 2 2;
3 3 3 3 4 4 4 4;
3 3 3 3 4 4 4 4;
3 3 3 3 4 4 4 4;
3 3 3 3 4 4 4 4
];
S = full(qtdecomp(I,0,[2 4]))
```

**Output**

```text
4.   0.   0.   0.   4.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
4.   0.   0.   0.   4.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
```

---

## 12 — Regression Matrix A

```scilab
S = full(qtdecomp(A))
```

**Output**

```text
1.   1.   1.   1.   1.   1.   1.   1.
1.   1.   1.   1.   1.   1.   1.   1.
1.   1.   1.   1.   1.   1.   1.   1.
1.   1.   1.   1.   1.   1.   1.   1.
1.   1.   2.   0.   4.   0.   0.   0.
1.   1.   0.   0.   0.   0.   0.   0.
1.   1.   1.   1.   0.   0.   0.   0.
1.   1.   1.   1.   0.   0.   0.   0.
```

---

## 13 — Regression Matrix A with Threshold = 5

```scilab
S = full(qtdecomp(A,5))
```

**Output**

```text
4.   0.   0.   0.   2.   0.   1.   1.
0.   0.   0.   0.   0.   0.   1.   1.
0.   0.   0.   0.   2.   0.   2.   0.
0.   0.   0.   0.   0.   0.   0.   0.
1.   1.   2.   0.   4.   0.   0.   0.
1.   1.   0.   0.   0.   0.   0.   0.
2.   0.   2.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
```

---

## 14 — Regression Matrix A with Threshold = 10

```scilab
S = full(qtdecomp(A,10))
```

**Output**

```text
4.   0.   0.   0.   2.   0.   2.   0.
0.   0.   0.   0.   0.   0.   0.   0.
0.   0.   0.   0.   2.   0.   2.   0.
0.   0.   0.   0.   0.   0.   0.   0.
1.   1.   2.   0.   4.   0.   0.   0.
1.   1.   0.   0.   0.   0.   0.   0.
2.   0.   2.   0.   0.   0.   0.   0.
0.   0.   0.   0.   0.   0.   0.   0.
```

## 15 — Function Handle Criterion

```scilab
function y = first_eq(B, varargin)
    y = squeeze(B(1,1,:) <> 54);
    y = y(:);
endfunction

S = full(qtdecomp(A, first_eq))
```

**Output**

```text
1.   1.   1.   1.   4.   0.   0.   0.
1.   1.   1.   1.   0.   0.   0.   0.
1.   1.   1.   1.   0.   0.   0.   0.
1.   1.   1.   1.   0.   0.   0.   0.
1.   1.   1.   1.   1.   1.   1.   1.
1.   1.   1.   1.   1.   1.   1.   1.
1.   1.   1.   1.   1.   1.   1.   1.
1.   1.   1.   1.   1.   1.   1.   1.
```

---

## 16 — Non-Square Image (Invalid Input)

```scilab
I = rand(4,5);
qtdecomp(I)
```

**Output**

```text
Error:
qtdecomp: I should be square.
```

---

## 17 — Invalid Dimension Limits (Invalid Input)

```scilab
I = eye(8,8);
qtdecomp(I,0,[4 2])
```

**Output**

```text
Error:
qtdecomp: mindim must be smaller than maxdim.
```

---

## 18 — Large Uniform Image

```scilab
I = ones(64,64);
S = full(qtdecomp(I))
```

**Output**

```text
64.   0.   0.   0.   0.   0.   0.   0.
0.    0.   0.   0.   0.   0.   0.   0.
0.    0.   0.   0.   0.   0.   0.   0.
0.    0.   0.   0.   0.   0.   0.   0.
0.    0.   0.   0.   0.   0.   0.   0.
0.    0.   0.   0.   0.   0.   0.   0.
0.    0.   0.   0.   0.   0.   0.   0.
0.    0.   0.   0.   0.   0.   0.   0.
```

---

## 19 — Unsigned Integer Image

```scilab
I = uint8(ones(4,4)*10);
S = full(qtdecomp(I,0.1))
```

**Output**

```text
4.   0.   0.   0.
0.   0.   0.   0.
0.   0.   0.   0.
0.   0.   0.   0.
```

---

## 20 — Sparse Output Structure

```scilab
I = [
1 1 2 2;
1 1 2 2;
3 3 4 4;
3 3 4 4
];

S = qtdecomp(I);
disp(typeof(S))
full(S)
```

**Output**

```text
sparse

2.   0.   2.   0.
0.   0.   0.   0.
2.   0.   2.   0.
0.   0.   0.   0.
```

The output of `qtdecomp` is a sparse matrix. Use `full()` to display the complete decomposition matrix.
