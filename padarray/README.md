# padarray

## Description:
`padarray` pads a 2-D or 3-D array along each of its dimensions, using either a constant fill value or a content-derived pattern.

Given an input array `A`, a padding amount per dimension (`padsize`), and optional fill/pattern/direction settings, the function returns a new array `B` that contains `A` surrounded (before, after, or both) by the requested border. The border may be a constant value (`padval`, default `0`), or one of four content-derived patterns — `circular` (periodic wrap), `replicate` (edge extension), `symmetric` (mirror including the boundary element), or `reflect` (mirror excluding the boundary element). If `sum(padsize) == 0`, `B` is returned identical to `A` with no padding applied.

## Calling Sequence:
```
B = padarray(A, padsize)
B = padarray(A, padsize, padval)
B = padarray(A, padsize, pattern)
B = padarray(A, padsize, padval_or_pattern, direction)
```

---
## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `A` | Matrix / Array | **Input:** 2-D matrix (`M×N`) or 3-D array (`M×N×P`). Real or complex, any Scilab numeric class. `ndims(A) > 3` is not supported. |
| `padsize` | Vector (Integer) | **Input:** Non-negative integer vector giving the padding amount per dimension: `[pr]` (rows only), `[pr pc]` (rows, columns), or `[pr pc pd]` (rows, columns, depth). |
| `padval` | Scalar | **Input (optional, default `0`):** Constant value used to fill the padded region. Ignored if `pattern` is supplied. |
| `pattern` | String | **Input (optional, default `""`, i.e. constant fill):** One of `"zeros"`, `"circular"`, `"replicate"`, `"symmetric"`, `"reflect"`. |
| `direction` | String | **Input (optional, default `"both"`):** One of `"pre"`, `"post"`, `"both"`. Controls which side(s) of each dimension receive padding. |
| `B` | Matrix / Array | **Output:** The padded array, of class/type identical to `A`. Its size along dimension `d` is `size(A,d) + pre_pad(d) + post_pad(d)`. |

`padval`, `pattern`, and `direction` are supplied as trailing, order-independent arguments (`varargin`); the function distinguishes them by type (string vs. scalar) rather than by position.

---
## Variable Reference

| Variable | Scope | Type | Description |
| --- | --- | --- | --- |
| `rhs` | Main | Integer | Number of input arguments supplied (`argn(2)`); must be between `2` and `4`. |
| `padsize` (reassigned) | Main | Row Vector | The validated `padsize` input, reshaped to a row vector via `matrix(padsize,1,-1)`. |
| `padval` | Main | Scalar | The fill value used for constant padding; defaults to `0`, overwritten by a scalar trailing argument. |
| `pattern` | Main | String | The selected padding pattern (`""`, `"circular"`, `"replicate"`, `"symmetric"`, `"reflect"`); `""` means constant fill. |
| `direction` | Main | String | The selected padding side (`"pre"`, `"post"`, `"both"`); defaults to `"both"`. |
| `fancy_pad` | Main | Boolean | `%t` when `pattern <> ""`, i.e. a content-derived (non-constant) padding mode is active. |
| `pre`, `post` | Main | Boolean | Whether padding is applied before / after the array along each dimension, derived from `direction`. |
| `s`, `dims` | Main | Vector / Integer | `size(A)` and its length, used to detect whether `A` is 2-D or 3-D. |
| `rows`, `cols`, `depth` | Main | Integer | Dimensions of `A` (`depth = 1` for 2-D input). |
| `pr`, `pc`, `pd` | Main | Integer | Padding amount requested for the row, column, and depth dimensions, taken from `padsize`. |
| `top`, `left`, `front` | Main | Integer | Pre-padding amounts actually applied (`pr`/`pc`/`pd` if `pre`, else `0`). |
| `bottom`, `right`, `back` | Main | Integer | Post-padding amounts actually applied (`pr`/`pc`/`pd` if `post`, else `0`). |
| `outRows`, `outCols`, `outDepth` | Main | Integer | Final dimensions of `B`. |
| `B` | Main | Matrix / Array | Output array; allocated as `padval*ones(...)` (or `zeros(...)` in the post-only fast path) and then populated. |
| `circular`, `replicate`, `symmetric`, `reflect` | Main | Boolean | Flags selecting which fancy-padding branch executes, derived from `pattern`. |
| `rowCut`, `colCut`, `depthCut` | Main | Integer | (`reflect` only) `rows-1`, `cols-1`, `depth-1` — the mirror period base excluding the boundary element. |
| `rowComplete`, `colComplete`, `depthComplete` | Main | Integer | Number of full tiling cycles needed to cover the requested padding (`floor(padAmount / cycleLength)`). |
| `rowBits`, `colBits`, `depthBits` | Main | Integer | Remaining partial-cycle padding after full cycles (`modulo(padAmount, cycleLength)`). |
| `rowPairSize`, `colPairSize`, `depthPairSize` | Main | Integer | (`symmetric`/`reflect`) Length of one (original, flipped) tile pair, used to batch two tiling cycles per loop iteration. |
| `rowPairComplete`, `colPairComplete`, `depthPairComplete` | Main | Integer | Number of complete (original, flipped) pairs. |
| `rowUnpaired`, `colUnpaired`, `depthUnpaired` | Main | Boolean/Integer | Whether one unpaired (odd) tiling cycle remains after full pairs are placed. |
| `row_source`, `col_source`, `depth_source` | Main | Matrix / Array | (`symmetric`/`reflect`) Current in-place original-orientation block along that dimension, used as a copy source. |
| `row_flipped`, `col_flipped`, `depth_flipped` | Main | Matrix / Array | The `flipdim()` mirror of the corresponding `*_source` block. |
| `rowBlock`, `colBlock`, `depthBlock` | Main | Matrix / Array | A concatenated (`cat`) pair of source + flipped blocks, tiled repeatedly to fill full pair cycles in one assignment. |
| `source_part`, `flipped_part` | Main | Matrix / Array | (`reflect` only) `row_source`/`row_flipped` etc. with the boundary row/column/plane excluded, per reflect's boundary-exclusion rule. |

---
## Helper Functions

| Function | Type | Purpose |
| --- | --- | --- |
| `argn()` | Built-in | Determines the number of input arguments supplied (`argn(2)`); used to validate argument count. |
| `isvector()`, `isreal()` | Built-in | Validate that `padsize` is a real vector before further processing. |
| `int()` | Built-in | Used with an equality check (`padsize <> int(padsize)`) to confirm `padsize` contains only integers. |
| `error()` | Built-in | Raises an error and halts execution for invalid argument counts, malformed `padsize`, unrecognized options, unsupported array dimensionality, or illegal reflect-padding on singleton dimensions. |
| `matrix()` | Built-in | Reshapes `padsize` into a row vector regardless of its original orientation. |
| `sum()` | Built-in | Detects the early-exit case where `sum(padsize) == 0` (no padding requested). |
| `length()`, `size()` | Built-in | Determine the number of elements in `padsize`/`varargin`, and the dimensions of `A`. |
| `type()`, `convstr()` | Built-in | Identify whether a trailing argument is a string (`type(arg)==10`) and normalize it to lowercase before matching against known option keywords. |
| `zeros()`, `ones()` | Built-in | Allocate the output array `B`, either as an all-zero array (fast path) or as `padval*ones(...)` for arbitrary fill values. |
| `floor()`, `modulo()` | Built-in | Compute the number of full tiling cycles and the leftover partial-cycle length needed for circular/replicate/symmetric/reflect modes. |
| `flipdim()` | Built-in | Mirrors a block of the array along a given dimension; the core primitive behind `symmetric` and `reflect` padding. |
| `cat()` | Built-in | Concatenates a source block and its flipped counterpart along a dimension to build a repeatable (original, flipped) tile pair. |

---

## Time & Space Complexity:

Let `rows × cols × depth` be the size of `A`, and let `outRows × outCols × outDepth` be the size of the padded output `B`.

Time Complexity: `O(outRows × outCols × outDepth)` — constructing the padded output and filling it (including all padding modes) is linear in the size of the output array.

Space Complexity: `O(outRows × outCols × outDepth)` — dominated by the output array `B`; any temporary arrays used for padding are at most proportional to the output size and do not change the asymptotic complexity.

---
## Mathematical Foundation

`padarray` builds the padded region of each dimension from one of five index-mapping rules, applied independently to the row, column, and depth axes.

### Output Dimension Resolution

```text
pre_pad  = p   if pre,   else 0
post_pad = p   if post,  else 0
outN     = N + pre_pad + post_pad
```

where `N` is the original size and `p` is the requested pad amount (`pr`/`pc`/`pd`) along that dimension.

### Constant Padding

```text
B(i) = padval           for i outside [pre_pad+1, pre_pad+N]
B(i) = A(i - pre_pad)    otherwise
```

### Circular Padding (periodic wrap)

```text
B(i) = A( mod(i - pre_pad - 1, N) + 1 )
```

Implemented as `floor(p/N)` full copies of `A` tiled consecutively, plus a partial copy of length `modulo(p,N)` taken from the near edge of `A`.

### Replicate Padding (edge extension)

```text
B(i) = A(1)   for i ≤ pre_pad
B(i) = A(N)   for i > pre_pad + N
```

### Symmetric Padding (mirror, boundary included)

Periodic with period `2N`, repeating the boundary element itself:

```text
A(1), A(2), ..., A(N), A(N), A(N-1), ..., A(1), A(1), A(2), ...
```

Built from repeated `(original, flipped)` tile pairs of combined length `2N`, plus a partial tile for any remaining padding shorter than `N`.

### Reflect Padding (mirror, boundary excluded)

Periodic with period `2(N-1)`, mirroring about a point just outside the edge without repeating the boundary element:

```text
..., A(3), A(2), A(1), A(2), A(3), ..., A(N-1), A(N), A(N-1), ..., A(2), A(1), A(2), ...
```

Undefined for `N = 1` (a singleton dimension has no adjacent element to mirror), which the implementation rejects explicitly before computing any tiling.

---
## Test Cases:

The following 15 test cases cover all supported padding modes, directions, and array shapes. Run the test script:

```scilab
exec('padarray_test.sce', -1);
```

`A = [1 2; 3 4]` is used as the base matrix unless otherwise noted.

### Test Case: 1 — Default Zero Padding (Both)

Verifies default constant (zero) padding on both sides.

```scilab
disp(padarray(A,[1 1]));
```

**Expected output:**

```
0   0   0   0
0   1   2   0
0   3   4   0
0   0   0   0
```

With `pr = pc = 1` and `direction = "both"` (default), `top = left = bottom = right = 1`. The output is `zeros(4,4)` with `A` placed at rows `2:3`, columns `2:3`.

---

### Test Case: 2 — Explicit Zeros Padding (PRE)

Verifies that the `"zeros"` option combines correctly with `direction = "pre"`.

```scilab
disp(padarray(A,[2 1],"zeros","pre"));
```

**Expected output:**

```
0   0   0
0   0   0
0   1   2
0   3   4
```

With `pr = 2`, `pc = 1`, `pre = %t`, `post = %f`: `top = 2`, `left = 1`, `bottom = right = 0`. `B = zeros(4,3)` with `A` placed at rows `3:4`, columns `2:3`; no padding appears below or to the right.

---

### Test Case: 3 — Constant Padding (POST)

Verifies a non-zero `padval` combined with `direction = "post"`.

```scilab
disp(padarray(A,[1 2],5,"post"));
```

**Expected output:**

```
1   2   5   5
3   4   5   5
5   5   5   5
```

With `pr = 1`, `pc = 2`, `pre = %f`, `post = %t`: `bottom = 1`, `right = 2`. Since `padval = 5 ≠ 0` and no `pattern` is set, `B = 5*ones(3,4)` with `A` placed at rows `1:2`, columns `1:2`.

---

### Test Case: 4 — Complex Padding (`%i`) (BOTH)

Verifies that a complex `padval` is accepted and applied on both sides.

```scilab
disp(padarray(A,[1 1],%i,"both"));
```

**Expected output:**

```
i   i   i   i
i   1   2   i
i   3   4   i
i   i   i   i
```

Same geometry as Test Case 1, but `padval = %i` instead of `0`, demonstrating that `padval` is not restricted to real scalars.

---

### Test Case: 5 — Circular Padding (Large Padding)

Verifies circular (wrap-around) padding when the requested padding exceeds the array's own dimensions.

```scilab
disp(padarray(A,[4 5],"circular","both"));
```

**Expected output:**

```
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
```

With `rows = cols = 2`, `pr = 4`, `pc = 5`: row tiling needs `rowComplete = floor(4/2) = 2` full copies on each side (`rowBits = 0`), giving `outRows = 10` rows that simply repeat `A`'s two-row pattern. Column tiling needs `colComplete = floor(5/2) = 2` full copies plus `colBits = modulo(5,2) = 1` partial column on each side, giving `outCols = 12`. Since `A`'s columns repeat with period 2, the result is the periodic sequence `...,2,1,2,1,...` on odd output rows and `...,4,3,4,3,...` on even output rows — equivalent to wrapping `A` infinitely and windowing a `10×12` region out of it.

---

### Test Case: 6 — Replicate Padding (PRE)

Verifies edge-value replication with `direction = "pre"`.

```scilab
disp(padarray(A,[2 2],"replicate","pre"));
```

**Expected output:**

```
1   1   1   2
1   1   1   2
1   1   1   2
3   3   3   4
```

With `pr = pc = 2`, `pre`-only: `top = left = 2`. Rows `1:2` first replicate row `3` (`[1,2]`, the top edge of `A`); columns `1:2` then replicate the current column `3` — which, after row-filling, holds `[1,1,1,3]` — giving the top-left corner block of `1`s and the bottom-left value `3`.

---

### Test Case: 7 — Symmetric Padding (POST)

Verifies boundary-inclusive mirror padding with `direction = "post"`.

```scilab
disp(padarray(A,[2 2],"symmetric","post"));
```

**Expected output:**

```
1   2   2   1
3   4   4   3
3   4   4   3
1   2   2   1
```

With `pr = pc = 2`, `post`-only: `bottom = right = 2`, and `A` is placed at the origin (rows `1:2`, cols `1:2`). Since `pr = rows = 2` and `pc = cols = 2` exactly, `rowComplete = colComplete = 1` with no remainder, so the padded region is a single flipped copy of `A` — reproducing `A`'s rows/columns in reverse order, including the boundary values.

---

### Test Case: 8 — Rectangular Matrix

Verifies replicate padding on a non-square `2×3` matrix, padded on both sides.

```scilab
B = [1 2 3;
     4 5 6];
disp(padarray(B,[2 1],"replicate","both"));
```

**Expected output:**

```
1   1   2   3   3
1   1   2   3   3
1   1   2   3   3
4   4   5   6   6
4   4   5   6   6
4   4   5   6   6
```

With `pr = 2`, `pc = 1`, both sides: the top two and bottom two output rows replicate `B`'s first (`[1,2,3]`) and last (`[4,5,6]`) row respectively; the leftmost and rightmost output columns then replicate the (now row-padded) first and last columns, confirming that row padding is applied before column padding within a single fancy-padding pass.

---

### Test Case: 9 — Row Vector

Verifies constant padding along the column dimension only, applied to a `1×4` row vector.

```scilab
R = [1 2 3 4];
disp(padarray(R,[0 3],9,"both"));
```

**Expected output:**

```
9   9   9   1   2   3   4   9   9   9
```

With `pr = 0`, `pc = 3`, `padval = 9`: since `rows = 1` already matches `R`'s row dimension, no row padding is added, and 3 constant columns are appended on each side of the 4 original elements.

---

### Test Case: 10 — Column Vector

Verifies constant padding using a single-element `padsize`, applied to a `4×1` column vector.

```scilab
C = [1; 2; 3; 4];
disp(padarray(C,[3],8,"both"));
```

**Expected output:**

```
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
```

A scalar `padsize = [3]` is interpreted as `pr = 3`, `pc = 0`, `pd = 0` (`length(padsize)==1` branch), so only the row dimension is padded, with `padval = 8` on both sides.

---

### Test Case: 11 — Single Element Matrix

Verifies replicate padding of a `1×1` scalar input.

```scilab
disp(padarray(5,[2 2],"replicate"));
```

**Expected output:**

```
5   5   5   5   5
5   5   5   5   5
5   5   5   5   5
5   5   5   5   5
5   5   5   5   5
```

With `rows = cols = 1`, every replicated row and column copies the single element `5`, giving a uniform `5×5` matrix (default `direction = "both"` since only a pattern, no direction, is supplied).

---

### Test Case: 12 — `int16` Input

Verifies that the input's integer class is preserved through padding, using an `int16`-typed `padval`.

```scilab
I = int16([10 20; 30 40]);
disp(padarray(I,[1 1],int16(-5),"both"));
```

**Expected output:**

```
-5   -5   -5   -5
-5   10   20   -5
-5   30   40   -5
-5   -5   -5   -5
```

`padval = int16(-5)` is matched by the `size(arg,"*")==1` branch in argument parsing rather than the string branch, and `B = padval*ones(...)` inherits the `int16` class throughout.

---

### Test Case: 13 — 3D Constant Padding

Verifies zero padding across all three dimensions of a `2×2×2` array.

```scilab
X(:,:,1) = [1 2; 3 4];
X(:,:,2) = [5 6; 7 8];
Y = padarray(X,[1 1 1],0);
```

**Expected output:**

```
Output Size: [4 4 4]

Slice 1:            Slice 2:            Slice 3:            Slice 4:
0  0  0  0           0  0  0  0           0  0  0  0           0  0  0  0
0  0  0  0           0  1  2  0           0  5  6  0           0  0  0  0
0  0  0  0           0  3  4  0           0  7  8  0           0  0  0  0
0  0  0  0           0  0  0  0           0  0  0  0           0  0  0  0
```

With `pr = pc = pd = 1` on both sides, `outDepth = 2 + 1 + 1 = 4`. The two original slices land at depth indices `2` and `3` (`front+1:front+depth = 2:3`), each surrounded by the same `4×4` zero border seen in Test Case 1; the new first and last depth slices are entirely zero.

---

### Test Case: 14 — 3D Circular Padding (Depth Only)

Verifies circular padding restricted to the depth dimension of the same `2×2×2` array.

```scilab
Y = padarray(X,[0 0 2],"circular");
```

**Expected output:**

```
Output Size: [2 2 6]

Slice 1: [1 2; 3 4]     Slice 3: [1 2; 3 4]     Slice 5: [1 2; 3 4]     Slice 6: [5 6; 7 8]
```

With `pr = pc = 0`, `pd = 2`, `depth = 2`: `depthComplete = floor(2/2) = 1` with `depthBits = 0`, so exactly one full wrapped copy of the two original slices is placed before (slices `1–2`) and after (slices `5–6`) the original data (slices `3–4`), reproducing the `[X(:,:,1), X(:,:,2)]` pair on every side.

---

### Test Case: 15 — Mixed Padding Sizes (Rows Only)

Verifies symmetric padding applied to only one dimension, where the requested padding exceeds the array's row count and does not divide it evenly.

```scilab
disp(padarray(A,[3 0],"symmetric","both"));
```

**Expected output:**

```
3   4
3   4
1   2
1   2
3   4
3   4
1   2
1   2
```

With `pr = 3`, `rows = 2`: `rowComplete = floor(3/2) = 1` and `rowBits = modulo(3,2) = 1`. One full mirrored pair (`row_flipped = [3 4; 1 2]`) is placed immediately adjacent to `A` on each side, and the single remaining partial row on each side (`rowBits = 1`) continues the periodic mirror pattern outward, producing the repeating `[3,4],[3,4],[1,2],[1,2]` block structure shown above.

---

### Test Results

The file `padarray_Test_Results.pdf` contains the output generated for each of the 15 test cases above, including:
* Input array and requested `padsize`/`pattern`/`direction`.
* Output array (and, for 3-D cases, each depth slice).

---
## Compatibility Notes

This function follows the general contract of MATLAB's Image Processing Toolbox `padarray` / GNU Octave's `padarray` (from the Octave `image` package), including the `padsize`/`padval`/`pattern`/`direction` argument shape and the `"circular"`, `"replicate"`, `"symmetric"` pattern names.

### Important Differences from MATLAB / Octave

* **`"reflect"` is an Octave-style extension, not a MATLAB mode.** MATLAB's `padarray` only supports `"circular"`, `"replicate"`, and `"symmetric"`; it has no separate boundary-excluded mirror mode. This implementation follows Octave's `image` package, which adds `"reflect"` (mirror without repeating the boundary element) as distinct from `"symmetric"`.

* **`type(arg)==10` for string detection.** Scilab has no direct `ischar()` equivalent; trailing string arguments (pattern/direction keywords) are identified via Scilab's internal type code `10`, then lowercased with `convstr(...,"l")` before matching.

* **`modulo()`/`floor()` in place of built-in tiling helpers.** Rather than relying on a `repmat`-style helper, the implementation manually computes `floor(pad/cycle)` full tiling cycles and a `modulo(pad,cycle)` remainder for every fancy-padding mode, then fills each with explicit block-copy assignments.

* **`flipdim()` instead of `flip()`.** MATLAB's `flip(X,dim)` corresponds to Scilab's `flipdim(X,dim)`; the two share arguments but not the function name.

* **Post-only fast path.** When padding is `post`-only and either `padval == 0` or a fancy pattern is requested, `B` is allocated with `zeros(...)` and `A` is placed at the origin, rather than allocating `padval*ones(...)` and offsetting the placement — an internal optimization with no effect on the returned result.

* **Only 2-D and 3-D arrays are supported.** `ndims(A) > 3` raises an error; MATLAB's `padarray` supports arbitrary N-D arrays.

---
### Recommended Usage

```scilab
// Typical convolution/filtering pre-processing
img_padded = padarray(img, [1 1], "replicate");   // avoid inventing edge values
result = myFilter(img_padded);

// Periodic-boundary simulation
field_padded = padarray(field, [k k], "circular");

// Symmetric border for edge-aware operations (avoiding hard cutoffs)
img_padded = padarray(img, [2 2], "symmetric");

// Simple zero-padding before FFT-based processing
X_padded = padarray(X, [0 0 pd], 0, "post");
```

* Use `"replicate"` when the padded border should not introduce values outside the original data's range (common before local filtering).
* Use `"circular"` when the data is inherently periodic (e.g. FFT-based workflows, tiled textures).
* Use `"symmetric"` or `"reflect"` to avoid a sharp discontinuity at the border; prefer `"reflect"` when the boundary element should not be artificially duplicated.
* `"reflect"` requires every padded dimension to have more than one element — it raises an error on a singleton dimension.
* For simple constant borders (e.g. preparing a canvas for compositing), omit `pattern` and pass `padval` directly.

---
## References

[1] GNU Octave Image Package Documentation — `padarray`.

[2] MATLAB Image Processing Toolbox Documentation — `padarray`.
