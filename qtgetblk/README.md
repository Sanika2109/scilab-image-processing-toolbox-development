# qtgetblk

## Description:
`qtgetblk` extracts all blocks of a specified size from an image, given its quadtree decomposition matrix.

It is the companion-retrieval function for quadtree decomposition: where `qtdecomp` partitions an image into a hierarchy of square blocks and records each block's top-left corner and size in a sparse matrix `S`, `qtgetblk` scans `S` for every entry equal to a requested block size `dim`, and returns the actual pixel content of those blocks from the original image `I`, along with (optionally) their locations.

## Calling Sequence:
```
vals = qtgetblk(I, S, dim)
[vals, idx] = qtgetblk(I, S, dim)
[vals, r, c] = qtgetblk(I, S, dim)
```

---
## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `I` | Matrix | **Input:** `2-D` image (the original image that was quadtree-decomposed). |
| `S` | Matrix (Sparse) | **Input:** Quadtree decomposition matrix, as returned by `qtdecomp`. A nonzero entry `S(r,c) = dim` marks `(r,c)` as the top-left corner of a `dim×dim` block. |
| `dim` | Double | **Input:** Block size to extract. Only blocks whose recorded size in `S` exactly equals `dim` are returned. |
| `vals` | 3-D Array | **Output:** Stack of extracted `dim×dim` blocks, one per page along the third dimension. Empty (`[]`) if no block of size `dim` exists. |
| `idx` | Column Vector | **Output (2-output form only):** Linear (column-major) indices into `I` of each block's top-left corner. |
| `r`, `c` | Column Vectors | **Output (3-output form only):** Row and column subscripts into `I` of each block's top-left corner. |

---
## Variable Reference

| Variable | Scope | Type | Description |
| --- | --- | --- | --- |
| `rhs` | Main | Integer | Number of input arguments supplied (`argn(2)`); must equal `3`. |
| `lhs` | Main | Integer | Number of output arguments requested (`argn(1)`); must be `1`, `2`, or `3`. |
| `idx_all` | Main | Column Vector (Integer) | Linear indices of every nonzero entry in `S`, from `find(S)`. |
| `i`, `j` | Main | Column Vectors (Integer) | Row and column subscripts of every nonzero entry in `S`, reconstructed from `idx_all` since Scilab's `find()` returns only linear indices (unlike Octave's three-output `find`). |
| `v` | Main | Column Vector (Double) | Block-size values at every nonzero position of `S` (i.e. `S(idx_all)`). |
| `idx` | Main | Column Vector (Integer) | Positions within `i`, `j`, `v` where the recorded block size equals `dim`. |
| `r`, `c` | Main | Column Vectors (Integer) | Row and column coordinates of the matching blocks' top-left corners (`i(idx)`, `j(idx)`). |
| `vals` | Main | 3-D Array (Double) | Preallocated `dim×dim×length(idx)` array that receives each extracted block. |
| `varargout` | Main | List | Variable-length output list; populated with `vals` and, depending on `lhs`, either `(r, c)` or a combined linear index. |

---
## Helper Functions

| Function | Type | Purpose |
| --- | --- | --- |
| `argn()` | Built-in | Determines the number of input arguments (`argn(2)`) and requested output arguments (`argn(1)`) supplied to the function. |
| `error()` | Built-in | Raises an error and halts execution when the input/output argument count is invalid. |
| `find()` | Built-in | Returns the linear indices of all nonzero entries in `S` (and, applied to `v == dim`, the positions of matching block-size entries). |
| `modulo()` | Built-in | Used with `size(S,1)` to recover the 1-based row subscript `i` from each linear index. |
| `floor()` | Built-in | Used with integer division to recover the 1-based column subscript `j` from each linear index. |
| `zeros()` | Built-in | Preallocates the `dim×dim×length(idx)` output array `vals` before the extraction loop. |
| `size()` | Built-in | Retrieves dimensions of `S` (for index reconstruction) and of `I` (for the linear-index formula in the 2-output case). |
| `length()` | Built-in | Counts the number of matching blocks (`length(idx)`), used to size `vals` and drive the extraction loop. |

---
## Time & Space Complexity:

Let `M × N` be the size of `S` (and of `I`), and `k` be the number of nonzero entries in `S` (i.e. the total number of quadtree blocks of all sizes).

Time Complexity: `O(M·N + k·dim²)` — `find(S)` and the index reconstruction scan all of `S` once (`O(M·N)`); extracting `length(idx)` blocks of size `dim×dim` each costs `O(dim²)` per block, so the extraction loop is `O(k·dim²)` in the worst case (when every nonzero entry of `S` matches `dim`).

Space Complexity: `O(k + dim²·length(idx))` — for the `i`, `j`, `v` index vectors (`O(k)`) and the output array `vals` (`O(dim²·length(idx))`).

---

## Mathematical Foundation

`qtgetblk` does not perform numerical computation itself; it performs structured retrieval against the result of a prior quadtree decomposition. Its correctness rests on the indexing relationships below.

### Quadtree Decomposition Matrix

```text
S(r,c) = d   if (r,c) is the top-left corner of a d×d block
S(r,c) = 0   otherwise
```

`S` is sparse: only the top-left corner of each block carries a nonzero value, and that value equals the block's side length.

### Linear-to-Subscript Index Recovery

Scilab's `find(S)` returns only column-major linear indices, so the row and column subscripts must be recovered manually:

```text
i = mod(idx_all - 1, rows(S)) + 1
j = floor((idx_all - 1) / rows(S)) + 1
```

This reproduces, in Scilab, the same `(i, j, v) = find(S)` three-output behavior available natively in Octave/MATLAB.

### Block Selection

```text
match = { k : v(k) = dim }
r = i(match),  c = j(match)
```

### Block Extraction

For each matching corner `(r(k), c(k))`:

```text
vals(:, :, k) = I( r(k) : r(k)+dim-1,  c(k) : c(k)+dim-1 )
```

i.e. the `dim×dim` sub-image whose top-left pixel is `(r(k), c(k))`.

### Linear Index Formula (2-output form)

```text
idx(k) = (c(k) - 1) * rows(I) + r(k)
```

This is the standard column-major linear-index formula, identical to Octave/MATLAB's `sub2ind`, and is the inverse of the `(i, j)` recovery step above.

### Output Range

```text
size(vals) = [dim, dim, length(idx)]     if any block of size dim exists
vals = []                                 otherwise (and idx/r,c likewise empty)
0 ≤ length(idx) ≤ nnz(S)
```

---
## Test Cases:

The following test cases assume a quadtree decomposition matrix `S` has already been produced (e.g. by `qtdecomp`) for a given image `I`. Run the test script: 

```scilab
exec('qtgetblk_test.sce', -1);
```

### Test Case: 1 — Single 4×4 Block

Verifies that a single full-image block is extracted correctly when `S` contains exactly one entry marking the entire image.

```scilab
I = magic(4);
S = zeros(4,4);
S(1,1) = 4;
[B, r, c] = qtgetblk(I, S, 4)
```

**Expected output:**

```
B(:,:,1) =
  16   2   3  13
   5  11  10   8
   9   7   6  12
   4  14  15   1

r = 1
c = 1
```

`S(1,1) = 4` marks the top-left corner of a single `4×4` block covering the entire image. `B` is `4×4×1` and its only page reproduces `I` in full. `r` and `c` are both `1`, confirming the block's top-left corner is at row `1`, column `1`.

---

### Test Case: 2 — Four 2×2 Quadrants

Verifies that all four equal quadrants of a `4×4` image are extracted in column-major order when `S` marks each quadrant as a separate `2×2` block.

```scilab
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
```

**Expected output:**

```
Block 1 — B(:,:,1):         Block 2 — B(:,:,2):
   1   2                        9  10
   3   4                       11  12

Block 3 — B(:,:,3):         Block 4 — B(:,:,4):
   5   6                       13  14
   7   8                       15  16

r = [1; 3; 1; 3]
c = [1; 1; 3; 3]
```

`find(S)` traverses `S` in column-major order, so the four entries are encountered in the sequence `(1,1)`, `(3,1)`, `(1,3)`, `(3,3)` — columns first, then rows within each column. This makes the bottom-left quadrant (Block 2) appear before the top-right quadrant (Block 3) in the output stack, even though `S(1,3)` was assigned before `S(3,1)` in the code.

---

### Test Case: 3 — Mixed Block Sizes

Verifies that only the blocks matching the requested `dim` are returned when `S` contains entries of multiple different sizes.

```scilab
I = matrix(1:64, 8, 8);

S = zeros(8,8);
S(1,1) = 4;
S(1,5) = 2;
S(5,1) = 2;
S(7,7) = 1;

[B, r, c] = qtgetblk(I, S, 2)
```

**Expected output:**

```
B is 2×2×2

Block 1 — B(:,:,1):     (top-left at row 5, col 1)
    5  13
    6  14

Block 2 — B(:,:,2):     (top-left at row 1, col 5)
   33  41
   34  42

r = [5; 1]
c = [1; 5]
```

`S` contains entries of sizes `4`, `2`, `2`, and `1`. Only the two entries equal to `2` are matched, at positions `(5,1)` and `(1,5)`. Column-major traversal of `S` encounters `(5,1)` before `(1,5)`, so `r = [5; 1]` and `c = [1; 5]`. The `4×4` block at `(1,1)` and the `1×1` block at `(7,7)` are silently ignored.

---

### Test Case: 4 — Corner 1×1 Blocks

Verifies that `dim = 1` extracts individual pixels and that both coordinate vectors and the pixel values themselves are correct.

```scilab
I = magic(4);

S = zeros(4,4);
S(1,1) = 1;
S(1,4) = 1;
S(4,1) = 1;
S(4,4) = 1;

[B, r, c] = qtgetblk(I, S, 1)
```

**Expected output:**

```
B is 1×1×4

B(:,:,1) = 16    (pixel at row 1, col 1)
B(:,:,2) = 4     (pixel at row 4, col 1)
B(:,:,3) = 13    (pixel at row 1, col 4)
B(:,:,4) = 1     (pixel at row 4, col 4)

r = [1; 4; 1; 4]
c = [1; 1; 4; 4]
```

Each `1×1` "block" is simply the single pixel at its recorded top-left corner. Column-major order places `(1,1)` and `(4,1)` (column 1) before `(1,4)` and `(4,4)` (column 4), so the left-column corners appear first in both `r`/`c` and the page ordering of `B`.

---

### Test Case: 5 — Central 2×2 Block

Verifies correct extraction when the only matching block sits in the interior of a larger image, rather than at the top-left corner.

```scilab
I = matrix(1:36, 6, 6);

S = zeros(6,6);
S(3,3) = 2;

[B, r, c] = qtgetblk(I, S, 2)
```

**Expected output:**

```
B(:,:,1) =
  15  21
  16  22

r = 3
c = 3
```

`matrix(1:36, 6, 6)` fills the `6×6` image in column-major order, so the `2×2` sub-block starting at `(3,3)` contains the values at positions `I(3,3)=15`, `I(4,3)=16`, `I(3,4)=21`, `I(4,4)=22`. Only one block is matched, so `B` is `2×2×1`, `r = 3`, and `c = 3`.

---

### Test Case: 6 — No Matching Block Size

Verifies that all requested outputs are returned as empty (`[]`) when `S` contains no entry equal to `dim`.

```scilab
I = magic(4);

S = zeros(4,4);
S(1,1) = 4;

[B, r, c] = qtgetblk(I, S, 2)
```

**Expected output:**

```
B = []
r = []
c = []
```

`S` has a single entry of size `4`, and `dim = 2` does not match. `idx` is empty, so the function assigns `[]` to every requested output via the `for i = 1:lhs` loop.

---

### Test Case: 7 — Empty Decomposition Matrix

Verifies that all outputs are empty when `S` contains no nonzero entries at all.

```scilab
I = magic(4);
S = zeros(4,4);

[B, r, c] = qtgetblk(I, S, 2)
```

**Expected output:**

```
B = []
r = []
c = []
```

`find(S)` returns no indices, so `i`, `j`, and `v` are all immediately set to `[]`. The subsequent `find(v == dim)` also returns empty, and every requested output is assigned `[]`.

---

### Test Case: 8 — Scattered 2×2 Blocks

Verifies that multiple non-adjacent `2×2` blocks scattered across a large image are all extracted in column-major order with correct pixel content.

```scilab
I = matrix(1:64, 8, 8);

S = zeros(8,8);
S(1,5) = 2;
S(5,1) = 2;
S(5,5) = 2;

[B, r, c] = qtgetblk(I, S, 2)
```

**Expected output:**

```
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
```

Column-major traversal of `S` finds the three entries in the order `(5,1)`, `(1,5)`, `(5,5)` — column 1 first, then columns 5 in row order. The extracted pixel values match the column-major fill of `matrix(1:64, 8, 8)`.

---

### Test Case: 9 — Two-Output Form (Linear Indices)

Verifies that requesting exactly two outputs returns the block stack and a linear-index vector rather than separate `r`/`c` vectors.

```scilab
I = matrix(1:16, 4, 4);

S = zeros(4,4);
S(1,1) = 2;
S(3,3) = 2;

[B, idx] = qtgetblk(I, S, 2)
```

**Expected output:**

```
B is 2×2×2

Block 1 — B(:,:,1):     (top-left at row 1, col 1)
   1  5
   2  6

Block 2 — B(:,:,2):     (top-left at row 3, col 3)
   11  15
   12  16

idx = [1; 11]
```

With two requested outputs, `varargout(2)` is computed as `(c - 1) * size(I, 1) + r`. For corner `(r=1, c=1)`: `(1-1)*4 + 1 = 1`. For corner `(r=3, c=3)`: `(3-1)*4 + 3 = 11`. These are the standard column-major linear indices of each block's top-left pixel within `I`.

---

### Test Case: 10 — One-Output Form

Verifies that requesting a single output returns only the block stack, with no coordinate information.

```scilab
I = matrix(1:16, 4, 4);

S = zeros(4,4);
S(1,1) = 2;

B = qtgetblk(I, S, 2)
```

**Expected output:**

```
B(:,:,1) =
   1  5
   2  6
```

With `lhs = 1`, the function assigns only `varargout(1) = vals`. The coordinate branches (`lhs == 2` and `lhs == 3`) are both skipped, so no `r`, `c`, or `idx` are computed or returned.

---

### Test Case: 11 — Error: Invalid Number of Input Arguments

Verifies that the function raises a descriptive error when called with the wrong number of arguments.

```scilab
try
    qtgetblk();
catch
    disp(lasterror());
end

```

**Expected output:**

```
qtgetblk: Wrong number of input/output arguments.
```

`qtgetblk` requires exactly three input arguments (`I`, `S`, `dim`). Calling it with zero inputs (or any count other than three) triggers the validation guard `rhs <> 3` immediately, raising `"qtgetblk: Wrong number of input/output arguments."` before any processing occurs. The same error is raised if more than three outputs are requested (`lhs > 3`).

---

### Test Results

The file `qtgetblk_Test_Results.pdf` contains the output generated for each test case, including:
* Input image matrix and decomposition matrix.
* Output blocks.
* Error generated for invalid inputs.

---

## Compatibility Notes

This function is a Scilab translation of GNU Octave's `qtgetblk` function (from the Octave `image` package) and preserves the same three calling forms (`vals`, `[vals, idx]`, `[vals, r, c]`).

### Important Differences from GNU Octave

* **`find()` reconstruction.** Octave's `find(S)` can return three outputs directly: `[i, j, v] = find(S)`. Scilab's `find()` returns only linear indices, so this implementation manually reconstructs `i` (row) and `j` (column) via `modulo()` and `floor()`, and looks up `v` separately as `S(idx_all)`. This is functionally equivalent but relies on `S` being addressed in column-major order, consistent with both languages' default linear-indexing convention.

* **`varargout` handling via `list()`.** Scilab does not support Octave's `nargout`-driven `varargout` cell array natively in the same way; this port uses Scilab's `list()`-backed `varargout(i)` assignment, which behaves equivalently in practice but is structurally different under the hood.

* **No type or shape validation on `S` or `dim`.** The function does not check that `S` has the same dimensions as `I`, nor that `dim` is a positive integer. Passing a malformed `S` (e.g. wrong size relative to `I`) or a non-integer/negative `dim` will not raise a descriptive error; it will either return empty outputs (if no entries equal `dim`) or fail later with an indexing error when extracting blocks.

* **Block extraction assumes in-bounds blocks.** If a nonzero entry in `S` is positioned such that `r(k)+dim-1` or `c(k)+dim-1` exceeds the dimensions of `I` (i.e. `S` is inconsistent with `I`'s size), the extraction step `I(r(k):r(k)+dim-1, c(k):c(k)+dim-1)` will raise an out-of-bounds indexing error rather than a `qtgetblk`-specific message.

* **Output count strictly limited to three.** Unlike some Octave conventions that silently ignore extra requested outputs, this implementation explicitly errors out (`lhs > 3`) rather than truncating.

---

### Recommended Usage

`qtgetblk` is intended to be used together with `qtdecomp`, which produces the `S` matrix it expects:

```scilab
S = qtdecomp(I, threshold);     // build the quadtree decomposition matrix
[vals, r, c] = qtgetblk(I, S, dim);  // retrieve all blocks of a given size
```

* Always pass the same `I` that was used to produce `S`; passing a differently-sized image will silently produce incorrect or out-of-bounds extractions.
* Use the 3-output form (`[vals, r, c]`) when you need to relate each extracted block back to its position for further processing (e.g. reconstructing or visualizing the decomposition); use the 2-output form (`[vals, idx]`) when a single linear index is more convenient (e.g. for direct indexing into `I` elsewhere).
* Check `vals` for emptiness (`vals == []`) before further processing if `dim` might not correspond to any block actually produced by the decomposition.

---

## References

[1] GNU Octave Image Package Documentation — `qtgetblk`.

[2] MATLAB Image Processing Toolbox Documentation — `qtgetblk`, `qtdecomp`.
