# qtsetblk

## Description:
`qtsetblk` replaces blocks of a specified size in an image with new pixel values, using a quadtree decomposition matrix to locate those blocks.

It is the companion-write function to `qtgetblk`: where `qtgetblk` reads pixel content out of the blocks identified by `qtdecomp`, `qtsetblk` writes new pixel content back into exactly those same blocks. Given the original image `I`, the decomposition matrix `S`, a target block size `dim`, and a stack of replacement pages `vals`, the function copies each page of `vals` into the corresponding `dim×dim` region of the output image `J`. All pixels that do not belong to a matching block are copied from `I` to `J` without modification. If no block of size `dim` exists in `S`, `J` is returned as an unmodified copy of `I`.

## Calling Sequence:
```
J = qtsetblk(I, S, dim, vals)
```

---
## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `I` | Matrix | **Input:** `2-D` image whose blocks are to be replaced (the original image that was quadtree-decomposed). |
| `S` | Matrix (Sparse) | **Input:** Quadtree decomposition matrix, as returned by `qtdecomp`. A nonzero entry `S(r,c) = dim` marks `(r,c)` as the top-left corner of a `dim×dim` block. |
| `dim` | Double | **Input:** Block size to replace. Only blocks whose recorded size in `S` exactly equals `dim` are affected. |
| `vals` | 3-D Array | **Input:** Stack of replacement blocks. Must be `dim×dim×k` where `k ≥` the number of matching blocks in `S`. Pages are written in column-major traversal order of `S`. |
| `J` | Matrix | **Output:** Copy of `I` with every matching `dim×dim` block replaced by the corresponding page of `vals`. |

---
## Variable Reference

| Variable | Scope | Type | Description |
| --- | --- | --- | --- |
| `rhs` | Main | Integer | Number of input arguments supplied (`argn(2)`); must equal exactly `4`. |
| `idx_all` | Main | Column Vector (Integer) | Linear indices of every nonzero entry in `S`, from `find(S)`. |
| `ii`, `ji` | Main | Column Vectors (Integer) | Row and column subscripts of every nonzero entry in `S`, reconstructed from `idx_all` since Scilab's `find()` returns only linear indices. |
| `v` | Main | Column Vector (Double) | Block-size values at every nonzero position of `S` (i.e. `S(idx_all)`). |
| `idx` | Main | Column Vector (Integer) | Positions within `ii`, `ji`, `v` where the recorded block size equals `dim`. |
| `ie`, `je` | Main | Column Vectors (Integer) | Ending row and column coordinates of each matching block: `ie = ii + dim - 1`, `je = ji + dim - 1`. Together with `ii`/`ji`, they define the slice `I(ii(b):ie(b), ji(b):je(b))` replaced in the loop. |
| `J` | Main | Matrix | Output image, initialized as a copy of `I` (`J = I`), then updated in-place within the replacement loop. |
| `b` | Main | Integer | Loop counter over matching blocks, `1` to `length(idx)`; used to index `ii`, `ie`, `ji`, `je`, and the pages of `vals`. |

---
## Helper Functions

| Function | Type | Purpose |
| --- | --- | --- |
| `argn()` | Built-in | Determines the number of input arguments supplied to the function (`argn(2)`). |
| `error()` | Built-in | Raises an error and halts execution for wrong argument count or insufficient pages in `vals`. |
| `find()` | Built-in | Returns linear indices of all nonzero entries in `S`; also used to find positions where `v == dim`. |
| `modulo()` | Built-in | Recovers 1-based row subscripts `ii` from column-major linear indices (equivalent to Octave's `rem()` for non-negative values). |
| `floor()` | Built-in | Recovers 1-based column subscripts `ji` from column-major linear indices via integer division. |
| `size()` | Built-in | Retrieves the number of rows of `S` (for subscript reconstruction) and the third dimension of `vals` (for the page-count validation). |
| `length()` | Built-in | Counts the number of matching blocks (`length(idx)`), used for validation and to drive the replacement loop. |

---

## Time & Space Complexity:

Let `M × N` be the size of `I` (and `S`), `k` be the number of nonzero entries in `S`, and `m` = `length(idx)` be the number of matching blocks of size `dim`.

Time Complexity: `O(M·N + m·dim²)` — `find(S)` and the subscript reconstruction scan all of `S` once (`O(M·N)`); each of the `m` block replacements copies a `dim×dim` slice (`O(dim²)` each), giving `O(m·dim²)` for the replacement loop.

Space Complexity: `O(M·N)` — dominated by the output image `J`, which is a full copy of `I`. The index vectors `ii`, `ji`, `v` are `O(k)`, bounded by the number of blocks.

---
## Mathematical Foundation

`qtsetblk` performs structured write-back into a subset of an image's pixel regions identified by a prior quadtree decomposition. Its correctness rests on the same indexing conventions used by `qtgetblk`.

### Quadtree Decomposition Matrix

```text
S(r,c) = d   if (r,c) is the top-left corner of a d×d block
S(r,c) = 0   otherwise
```

### Linear-to-Subscript Index Recovery

Scilab's `find(S)` returns only column-major linear indices; row and column subscripts are reconstructed as:

```text
ii = mod(idx_all - 1, rows(S)) + 1
ji = floor((idx_all - 1) / rows(S)) + 1
```

### Block Selection and Replacement

```text
match = { k : v(k) = dim }
ii = ii(match),  ji = ji(match)
ie = ii + dim - 1,  je = ji + dim - 1

for b = 1 .. length(match):
    J( ii(b) : ie(b),  ji(b) : je(b) ) = vals(:, :, b)
```

### Replacement Order

Block replacement follows the column-major traversal order of `S` produced by `find(S)` — columns are processed before rows within the same column. Page `b` of `vals` is always written to the block whose top-left corner appears at position `b` in this traversal, regardless of the spatial order in which the blocks appear in the image.

### Output Range

```text
J(r,c) = vals(r-ii(b)+1, c-ji(b)+1, b)   if (r,c) lies within matching block b
J(r,c) = I(r,c)                            otherwise
```

All pixels outside every matching block are copied verbatim from `I`, so:

```text
J = I   when length(match) = 0
```

---
## Difference Between `qtgetblk` and `qtsetblk`

Both functions operate on a quadtree decomposition matrix `S` and a target block size `dim`, but in opposite directions.

| Function | Direction | Purpose |
| --- | --- | --- |
| `qtgetblk(I, S, dim)` | Read | Extracts the pixel content of all `dim×dim` blocks identified by `S` from image `I`. |
| `qtsetblk(I, S, dim, vals)` | Write | Replaces the pixel content of all `dim×dim` blocks identified by `S` in image `I` with the pages of `vals`. |

Used together, they form a read-modify-write cycle:

```scilab
[vals, r, c] = qtgetblk(I, S, dim);   // read
vals = process(vals);                  // modify
J    = qtsetblk(I, S, dim, vals);     // write back
```

**Recommendation:** Always use `qtgetblk` and `qtsetblk` with the same `S` and `dim` to guarantee that block positions and page ordering are consistent between the read and write steps.

---
## Test Cases:

The following 10 test cases cover all required valid, invalid, and boundary cases. Run the test script:

```scilab
exec('qtsetblk.sce', -1);
```

### Test Case: 1 — Replace a Single 2×2 Block at an Interior Position

Verifies that a single `2×2` block positioned in the interior of a `4×4` image is replaced correctly, and that all other pixels remain unchanged.

```scilab
I = [10 11 12 13;
     20 21 22 23;
     30 31 32 33;
     40 41 42 43];

S = zeros(4,4);
S(3,3) = 2;

vals = [100 101;
        102 103];

J = qtsetblk(I, S, 2, vals)
```

**Expected output:**

```
J =
    10   11   12   13
    20   21   22   23
    30   31  100  101
    40   41  102  103
```

`S(3,3) = 2` marks a single `2×2` block whose top-left corner is at row `3`, column `3`. The replacement block `vals` is written into `J(3:4, 3:4)`, overwriting `32`, `33`, `42`, `43` with `100`, `101`, `102`, `103`. All other pixels are copied unchanged from `I`.

---

### Test Case: 2 — Replace Four 2×2 Quadrants

Verifies that all four quadrants of a `4×4` image are replaced with distinct values, and that the page-to-quadrant mapping follows column-major traversal order of `S`.

```scilab
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
```

**Expected output:**

```
J =
   101  102  301  302
   103  104  303  304
   201  202  401  402
   203  204  403  404
```

`find(S)` traverses `S` in column-major order, encountering the four nonzero entries as `(1,1)`, `(3,1)`, `(1,3)`, `(3,3)`. Page assignment follows this order:

| Page | Position in `S` | Quadrant filled |
|---|---|---|
| 1 (`101`–`104`) | `(1,1)` | Top-left |
| 2 (`201`–`204`) | `(3,1)` | Bottom-left |
| 3 (`301`–`304`) | `(1,3)` | Top-right |
| 4 (`401`–`404`) | `(3,3)` | Bottom-right |

The bottom-left quadrant receives page 2 and the top-right quadrant receives page 3, even though `S(1,3)` was assigned before `S(3,1)` in the script. Column-major traversal, not assignment order, determines page mapping.

---

### Test Case: 3 — Replace a Single 1×1 Block (Individual Pixel)

Verifies that `dim = 1` targets a single pixel and replaces it with the scalar value in `vals`, leaving all surrounding pixels unchanged.

```scilab
I = [11 12 13 14 15;
     21 22 23 24 25;
     31 32 33 34 35;
     41 42 43 44 45;
     51 52 53 54 55];

S = zeros(5,5);
S(3,3) = 1;

vals = 999;

J = qtsetblk(I, S, 1, vals)
```

**Expected output:**

```
J =
    11   12   13   14   15
    21   22   23   24   25
    31   32  999   34   35
    41   42   43   44   45
    51   52   53   54   55
```

`S(3,3) = 1` marks a single `1×1` block at row `3`, column `3`. The replacement writes `999` into `J(3,3)`, overwriting the original value `33`. All 24 surrounding pixels are copied unchanged from `I`.

---

### Test Case: 4 — Replace a 4×4 Block Inside a Larger Image

Verifies that a `4×4` replacement block positioned off the top-left corner is written into the correct rows and columns of the output, with all border pixels left unchanged.

```scilab
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
```

**Expected output:**

```
J =
    11   12   13   14   15   16
    21  100  101  102  103   26
    31  110  111  112  113   36
    41  120  121  122  123   46
    51  130  131  132  133   56
    61   62   63   64   65   66
```

`S(2,2) = 4` marks a `4×4` block whose top-left corner is at row `2`, column `2`, covering `J(2:5, 2:5)`. The replacement block is written into this region, giving `ie = 2 + 4 - 1 = 5` and `je = 2 + 4 - 1 = 5`. The first row, last row, first column, and last column of `J` (which lie outside the block) are copied unchanged from `I`.

---

### Test Case: 5 — Replace a Central 2×2 Block in a Larger Image

Verifies that a `2×2` block positioned in the interior of a `6×6` image is replaced correctly, with all surrounding pixels left unchanged.

```scilab
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
```

**Expected output:**

```
J =
    11   12   13   14   15   16
    21   22   23   24   25   26
    31   32  100  101   35   36
    41   42  102  103   45   46
    51   52   53   54   55   56
    61   62   63   64   65   66
```

`S(3,3) = 2` marks a block covering `J(3:4, 3:4)`. The four pixels at those positions — originally `33`, `34`, `43`, `44` — are replaced by `100`, `101`, `102`, `103` respectively. All 32 surrounding pixels are copied unchanged from `I`.

---

### Test Case: 6 — Mixed Decomposition Sizes, Replace Only `dim = 2`

Verifies that only the blocks with size `2` are replaced when `S` contains entries of multiple different sizes, and that the column-major traversal order determines which page of `vals` fills each block.

```scilab
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
```

**Expected output:**

```
J =
     1    2    3    4  200  201    7    8
     9   10   11   12  202  203   15   16
    17   18   19   20   21   22   23   24
    25   26   27   28   29   30   31   32
   100  101   35   36   37   38   39   40
   102  103   43   44   45   46   47   48
    49   50   51   52   53   54   55   56
    57   58   59   60   61   62   63   64
```

Column-major traversal of `S` finds the two `dim = 2` entries in the order `(5,1)` (column 1) then `(1,5)` (column 5). Page 1 (`100`–`103`) is therefore written to the block at rows 5–6, cols 1–2, and page 2 (`200`–`203`) is written to the block at rows 1–2, cols 5–6. The `4×4` block at `S(1,1)` and the `1×1` block at `S(7,7)` do not match `dim = 2` and are left unchanged.

---

### Test Case: 7 — No Matching Blocks

Verifies that the original image is returned unchanged when no entry in `S` equals `dim`.

```scilab
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
```

**Expected output:** `J` is identical to `I`.

`S` contains entries of sizes `4` and `1`, but `dim = 2` finds no match. `idx` is empty, so the function returns immediately with `J = I` without entering the replacement loop. The supplied `vals` is never read.

---

### Test Case: 8 — Empty Decomposition Matrix

Verifies that the original image is returned unchanged when `S` contains no nonzero entries at all.

```scilab
I = [1 2 3;
     4 5 6;
     7 8 9];

S = zeros(3,3);

vals = [99 98;
        97 96];

J = qtsetblk(I, S, 2, vals)
```

**Expected output:** `J` is identical to `I`.

`find(S)` returns no indices, so `ii`, `ji`, and `v` are all set to `[]`. The subsequent `find(v == dim)` also returns empty, and the function returns `J = I` immediately. The supplied `vals` is never read.

---

### Test Case: 9 — Extra Pages in `vals` Are Silently Ignored

Verifies that `vals` with more pages than there are matching blocks is accepted without error, and that only the first page is used.

```scilab
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
```

**Expected output:**

```
J =
    11   12   13   14
    21  100  101   24
    31  102  103   34
    41   42   43   44
```

Only one block exists in `S` at `(2,2)`, so only page 1 (`100`–`103`) is written into `J(2:3, 2:3)`. The validation `size(vals, 3) < length(idx)` checks for too few pages, not too many: `3 < 1` is false, so no error is raised. Pages 2 and 3 are never accessed and have no effect on the output.

---

### Test Case: 10 — Error: Insufficient Pages in `vals`

Verifies that the function raises a descriptive error when `vals` has fewer pages than there are matching blocks.

```scilab
I = [1  2  3  4;
     5  6  7  8;
     9 10 11 12;
    13 14 15 16];

S = zeros(4,4);
S(1,1) = 2;
S(3,3) = 2;    // 2 matching blocks

vals(:,:,1) = [100 101;
               102 103];   // only 1 page supplied

try
    J = qtsetblk(I, S, 2, vals);
catch
    disp(lasterror());
end
```

**Expected output:** Error — `"qtsetblk: k (vals 3rd dimension) is not equal to number of blocks."`

Two entries in `S` match `dim = 2`, but `vals` has only one page. The check `size(vals, 3) < length(idx)` evaluates as `1 < 2`, which is true, so the function raises an error before any block is replaced. Neither block in `I` is modified.

---

### Test Results

The file `qtsetblk_Test_Results.pdf` contains the output generated for each test case, including:
* Input image matrix and decomposition matrix.
* Output blocks.
* Error generated for invalid inputs.

---
## Compatibility Notes

This function is a Scilab translation of GNU Octave's `qtsetblk` function (from the Octave `image` package) and preserves the same calling signature and block-replacement semantics.

### Important Differences from GNU Octave

* **`find()` reconstruction of `(ii, ji)`.** Octave's `find(S)` can return three outputs `[row, col, val]` directly. Scilab's `find()` returns only linear indices, so this implementation manually reconstructs row (`ii`) and column (`ji`) subscripts via `modulo()` and `floor()`, and looks up values as `S(idx_all)`. This is functionally equivalent but depends on column-major linear indexing being consistent between the two environments.

* **`rem()` replaced by `modulo()`.** The row-subscript recovery uses Scilab's `modulo()` in place of Octave's `rem()`. For the non-negative integer offsets used here the two behave identically, but they differ in sign for negative operands.

* **Error message for insufficient `vals` pages.** The check `size(vals, 3) < length(idx)` raises `"qtsetblk: k (vals 3rd dimension) is not equal to number of blocks."` The phrase "is not equal to" is a slight misnomer: the actual condition tested is strictly less than (`<`), not not-equal-to (`<>`). A `vals` with more pages than matching blocks is silently accepted, and the extra pages are ignored.

* **No type or shape validation on `S`, `dim`, or `vals`.** The function does not verify that `S` has the same dimensions as `I`, that `dim` is a positive integer, or that `vals` has the right first two dimensions (`dim × dim`). Passing a malformed `S` (wrong size relative to `I`), a non-integer `dim`, or a `vals` whose first two dimensions differ from `dim` will not produce a descriptive error — it will either silently succeed (with incorrect pixel values) or fail with a generic indexing error when the replacement slice is assigned.

* **Block replacement is in-place on `J`, not `I`.** `J = I` initializes the output as a shallow copy; the loop then updates `J` directly. Scilab's copy-on-write semantics ensure `I` is not modified.

---
### Recommended Usage

`qtsetblk` is intended to be used together with `qtdecomp` and `qtgetblk` as part of a read-modify-write pipeline:

```scilab
// Build the decomposition
S = qtdecomp(I, threshold);

// Read blocks of a given size
[vals, r, c] = qtgetblk(I, S, dim);

// Process blocks (e.g. normalize, zero out, substitute)
for k = 1:size(vals, 3)
    vals(:,:,k) = process(vals(:,:,k));
end

// Write modified blocks back into the image
J = qtsetblk(I, S, dim, vals);
```

* Always use the same `S` and `dim` for `qtgetblk` and `qtsetblk` — any mismatch in `S` or `dim` between the two calls will silently write replacement blocks to incorrect positions.
* If `vals` is produced by `qtgetblk`, its page count is guaranteed to match the number of matching blocks, so the `size(vals,3) < length(idx)` error cannot occur.
* Supplying more pages in `vals` than there are matching blocks is permitted; the extra pages are simply ignored.
* To zero out all blocks of a given size without reading first, pass `zeros(dim, dim, nnz(S==dim))` directly as `vals`.

---
## References

[1] GNU Octave Image Package Documentation — `qtsetblk`.

[2] MATLAB Image Processing Toolbox Documentation — `qtsetblk`, `qtgetblk`, `qtdecomp`.
