# normxcorr2

## Description:
`normxcorr2` computes the normalized 2-D cross-correlation between a template `a` and an image `b`, producing a correlation map `c` with values in `[-1, 1]`. Higher values indicate greater similarity, with `1` representing a perfect match, `0` no linear correlation, and negative values indicating inverse correlation. The output is larger than the input image because full cross-correlation is computed, similar to `conv2(..., "full")`.

For each offset, both the template and the overlapping image region are mean-subtracted and normalized by their root-mean-square norms. If the local image region has zero variance, the corresponding output value is set to `0`.

## Calling Sequence:
```
c = normxcorr2(a, b)
```
## Dependencies

The function depends on the following external file:

| File | Purpose |
|--------|---------|
| `postpad.sci` | The function resizes an array by padding or truncating it along a specified dimension (default `0`). |

The dependency file must be loaded before executing `normxcorr2.sci`. The test script does this automatically:

```scilab
base = get_absolute_file_path("normxcorr2_test.sce");
exec(base + "../postpad/postpad.sci", -1);
exec(base + "normxcorr2.sci", -1);
```
---
## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `a` | Matrix | **Input:** Template matrix (the pattern to search for). Must have no dimension larger than the corresponding dimension of `b`. Internally converted to `double`. |
| `b` | Matrix | **Input:** Image matrix (the signal to search within). Internally converted to `double`. |
| `c` | Double Matrix | **Output:** Normalized cross-correlation map. Size is `(rows(b) + rows(a) - 1) × (cols(b) + cols(a) - 1)`. All values lie in `[-1, 1]`; positions with zero local variance in `b` are set to `0`. |

---
## Variable Reference

| Variable | Scope | Type | Description |
| --- | --- | --- | --- |
| `rhs` | Main | Integer | Number of input arguments supplied (`argn(2)`); must equal `2`. |
| `a` | Main | Matrix (Double) | Template, converted to `double` and mean-subtracted (`a = a - mean(a(:))`). |
| `b` | Main | Matrix (Double) | Image, converted to `double` and mean-subtracted (`b = b - mean(b(:))`). |
| `a1` | Main | Matrix (Double) | Matrix of ones with the same size as `a`; used as the kernel for the local-sum convolutions that compute the per-offset variance of `b`. |
| `ar` | Main | Matrix (Double) | Template `a` with all elements reversed in linear (column-major) order and reshaped to `size(a)`, equivalent to rotating `a` by 180°. Used as the convolution kernel so that `conv2(b, conj(ar))` computes correlation rather than convolution. |
| `c` | Main | Matrix (Double) | Raw (unnormalized) cross-correlation map, set initially by `conv2(b, conj(ar))`; later overwritten with the normalized values and returned. |
| `b` (reassigned) | Main | Matrix (Double) | Reused after the first `conv2` call to hold the local variance map of `b` under the template footprint: `conv2(b^2, a1) - conv2(b, a1)^2 / prod(size(a))`. |
| `idx` (first use) | Main | Vector (Integer) | Linear indices of entries in the variance map `b` that are negative (due to floating-point rounding); those entries are clamped to `0` before taking the square root. |
| `a` (reassigned) | Main | Double | Reused after the variance step to hold `sumsq(a(:))` — the total squared energy of the mean-subtracted template, used as the denominator scalar. |
| `idx` (second use) | Main | Vector (Integer) | Linear indices of entries in `c` that are `Inf` or `NaN` (arising from division by zero when the local variance is zero); those entries are set to `0`. |
| `s` | `sumsq` | Double | Accumulated sum of squares, `sum(x(:).^2)`, returned as the squared norm of the input vector. |

---
## Helper Functions

| Function | Type | Purpose |
| --- | --- | --- |
| `argn()` | Built-in | Determines the number of input arguments supplied (`argn(2)`); used to enforce exactly two inputs. |
| `error()` | Built-in | Raises an error and halts execution when the argument count is not two. |
| `warning()` | Built-in | Issues a non-fatal warning when `a` appears larger than `b` in any dimension, suggesting the arguments may have been swapped. |
| `ndims()` | Built-in | Returns the number of dimensions of each argument; used in the swap-detection check. |
| `postpad()` | Built-in | Zero-pads the size vector of `a` to the same length as `ndims(b)` before comparing dimensions, ensuring the check works for mismatched ranks. |
| `size()` | Built-in | Returns dimension sizes; used for the swap check, for `prod(size(a))` (template area), and for `matrix(c, size(c))` (shape restoration). |
| `double()` | Built-in | Converts `a` and `b` to `double` precision before arithmetic. |
| `mean()` | Built-in | Computes the mean of all elements (`mean(a(:))`); used to mean-subtract both inputs. |
| `ones()` | Built-in | Creates `a1`, the all-ones kernel of the same size as `a`. |
| `matrix()` | Built-in | Reshapes `a($:-1:1)` (a linear reversal of `a`) back into `size(a)` to produce the 180°-rotated kernel `ar`; also restores `c`'s shape after element-wise operations. |
| `conv2()` | Built-in | Performs full 2-D convolution. Called three times: once for the raw correlation (`conv2(b, conj(ar))`), once for the sum of squared image values (`conv2(b.^2, a1)`), and once for the local image sum (`conv2(b, a1)`). |
| `find()` | Built-in | Locates negative entries in the variance map (for clamping) and `Inf`/`NaN` entries in the output (for zeroing). |
| `isinf()`, `isnan()` | Built-in | Detect non-finite values in `c` after the division step, so they can be replaced by `0`. |
| `prod()` | Built-in | Computes the total number of elements in `a` (`prod(size(a))`), i.e. the template area, used in the variance formula. |
| `sqrt()` | Built-in | Computes the per-position normalization denominator `sqrt(b * a)` where `b` is the local variance map and `a` is the template squared norm. |
| `sumsq(x)` | Helper (local) | Returns `sum(x(:).^2)`, the sum of squares of all elements of `x`. Used to compute the squared `L2` norm of the mean-subtracted template. |

---

## Time & Space Complexity:

Let `M × N` be the size of image `b` and `P × Q` be the size of template `a`.

Time Complexity: `O((M+P)(N+Q) · log((M+P)(N+Q)))` — dominated by the three `conv2` calls. Each `conv2` operates on inputs of size up to `(M+P-1) × (N+Q-1)` and is internally computed via FFT, giving the stated log-linear complexity. For small templates relative to the image, this is effectively `O(MN · log(MN))`.

Space Complexity: `O((M+P)(N+Q))` — the output correlation map has size `(M+P-1) × (N+Q-1)`, and each intermediate convolution result occupies the same footprint.

---
## Mathematical Foundation

### Mean Subtraction

Both inputs are mean-subtracted before processing:

```text
ã = a - mean(a)
b̃ = b - mean(b)
```

This makes the correlation invariant to additive intensity offsets, so a bright version of the template matches a dark version of the same pattern equally well.

### Raw Cross-Correlation

The unnormalized cross-correlation at offset `(s, t)` is:

```text
C(s,t) = Σ_{i,j}  b̃(s+i, t+j) · ã(i,j)
```

In practice, this is computed as `conv2(b̃, conj(ã_rotated))` using the relation between correlation and convolution (rotating the kernel by 180° turns convolution into correlation).

### Local Variance of the Image

The denominator requires the energy of the image region aligned with the template at each offset. Using the kernel of ones `a1`:

```text
Σ b̃²  (local)  =  conv2(b̃², a1) − conv2(b̃, a1)² / |a|
```

where `|a| = prod(size(a))` is the number of template pixels. This identity computes the sum of squared deviations within each template-sized window of `b̃` efficiently using two convolutions.

### Normalization Formula

The normalized cross-correlation is:

```text
c(s,t) = C(s,t) / sqrt( Σ_local b̃² · sumsq(ã) )
```

where `sumsq(ã) = Σ_{i,j} ã(i,j)²` is the squared L2 norm of the template.

### Handling Degenerate Cases

When the local image region under the template is uniform (all pixels identical), its variance is zero, causing a `0/0` or `x/0` division. These produce `NaN` or `Inf` in the raw output. The function replaces all such entries with `0`. Floating-point rounding can also cause the variance map to dip slightly below zero; any negative variance entries are clamped to `0` before the square root is taken.

### Output Size

Following `conv2` full-mode convention:

```text
rows(c) = rows(b) + rows(a) - 1
cols(c) = cols(b) + cols(a) - 1
```

### Output Range

```text
-1 ≤ c(s,t) ≤ 1
```

A value of `1` indicates a perfect normalized match (template and local region are identical up to a positive scale factor and additive offset); a value of `-1` indicates a perfect inverse match; `0` indicates no linear correlation or a degenerate (uniform) local region.

---
## Test Cases:

The following 10 test cases cover all varied inputs and edge case conditions. Run the test script:

```scilab
exec('normxcorr2_test.sce', -1);
```

### Test Case: 1 — Basic Matching Template

Verifies that a `2×2` template embedded at a known position in a `3×3` image produces a peak of `1.0` at the corresponding offset in the correlation map.

```scilab
A = [1 2;
     3 4];

B = [0 0 0;
     1 2 0;
     3 4 0];

C = normxcorr2(A, B);
disp(C);
```

**Expected output:**

```
C =                          (4×4)
  -0.7746  -0.8944  -0.8944  -0.2582
   0.1861   0.9439   0.2582   0.4472
   0.7735   1.0000  -0.1348   0.4472
  -0.2582  -0.7679  -0.5698   0.7746
```

The output size is `(3+2-1) × (3+2-1) = 4×4`. The template `A` matches the `2×2` region at rows `2–3`, cols `1–2` of `B`, producing the peak value of `1.0` at position `(3,2)`. The remaining values reflect partial overlaps at all other offsets.

---

### Test Case: 2 — Rectangular Template

Verifies that a non-square `2×3` template produces the correct output shape and high correlation values where the template best aligns with rows of the image.

```scilab
A = [1 2 3;
     4 5 6];

B = [ 1  2  3  4;
      5  6  7  8;
      9 10 11 12];

C = normxcorr2(A, B);
disp(C);
```

**Expected output:**

```
C =                                           (4×6)
  -0.6547  -0.8014  -0.7667  -0.7282  -0.3719  -0.1309
  -0.0485   0.3107   0.9939   0.9939   0.8374   0.5797
   0.5797   0.8374   0.9939   0.9939   0.3107  -0.0485
  -0.1309  -0.3719  -0.7282  -0.7667  -0.8014  -0.6547
```

The output size is `(3+2-1) × (4+3-1) = 4×6`. The template `A = [1 2 3; 4 5 6]` shares a consistent arithmetic progression with all horizontal windows of `B`, so the top correlation values `≈ 0.9939` appear at positions `(2,3)`, `(2,4)`, `(3,3)`, and `(3,4)` — the offsets where the template aligns with columns `1–3` and `2–4` in rows `1–2` and `2–3` of `B`.

---

### Test Case: 3 — Floating-Point Inputs

Verifies that non-integer, floating-point L\*a\*b\* values are handled correctly and that the output is normalized to `[-1, 1]` regardless of input magnitude.

```scilab
A = [0.5 1.5;
     2.5 3.5];

B = [1.1 2.2 3.3;
     4.4 5.5 6.6;
     7.7 8.8 9.9];

C = normxcorr2(A, B);
disp(C);
```

**Expected output:**

```
C =                          (4×4)
  -0.7746  -0.8141  -0.7746  -0.2582
   0.0682   0.9899   0.9899   0.7182
   0.7182   0.9899   0.9899   0.0682
  -0.2582  -0.7746  -0.8141  -0.7746
```

`B` is a linearly scaled version of a uniform-increment grid (`B = 1.1 × [1 2 3; 4 5 6; 7 8 9]`), and `A` has the same relative structure as the top-left `2×2` sub-block. The normalization removes scaling differences, so the high-correlation region `≈ 0.9899` appears at all four `2×2` interior windows of `B` where the linear trend of `A` partially matches. The output size is `(3+2-1) × (3+2-1) = 4×4`.

---

### Test Case: 4 — Negative Values

Verifies that inputs containing negative values are handled correctly and that the cross-correlation remains normalized to `[-1, 1]`.

```scilab
A = [-1 -2;
      3  4];

B = [-4 -3 -2;
     -1  0  1;
      2  3  4];

C = normxcorr2(A, B);
disp(C);
```

**Expected output:**

```
C =                          (4×4)
  -0.6794  -0.9337  -0.9058  -0.4529
   0.5383   0.9303   0.9303   0.5399
   0.8099   0.9303   0.9303   0.3589
  -0.6794  -0.9813  -0.9886  -0.4529
```

Both `A` and `B` contain negative values. After mean subtraction, the normalization formula treats all values identically regardless of sign. The output size is `(3+2-1) × (3+2-1) = 4×4`. No value exceeds `1.0` in magnitude, confirming the normalization is correct for mixed-sign inputs.

---

### Test Case: 5 — Single-Pixel Template

Verifies that a `1×1` template produces an all-zero output because a scalar is constant after mean subtraction, making the denominator zero everywhere.

```scilab
A = [5];

B = [1 2 3;
     4 5 6;
     7 8 9];

C = normxcorr2(A, B);
disp(C);
```

**Expected output:**

```
C =               (3×3)
   0   0   0
   0   0   0
   0   0   0
```

`A - mean(A) = 5 - 5 = 0`, so `sumsq(A(:)) = 0`. The denominator is zero at every offset, producing `NaN` or `Inf` in the raw division. The cleanup step (`c(isnan(c) | isinf(c)) = 0`) replaces all non-finite entries with `0`. The output size is `(3+1-1) × (3+1-1) = 3×3`, matching the image dimensions.

---

### Test Case: 6 — Template Equals Image (Self-Correlation)

Verifies that correlating a template with an identical same-size image produces a peak of exactly `1.0` at the central offset.

```scilab
A = [2 1;
     4 3];

B = [2 1;
     4 3];

C = normxcorr2(A, B);
disp(C);
```

**Expected output:**

```
C =                          (3×3)
  -0.2582  -0.5477  -0.7746
   0.4472   1.0000   0.4472
  -0.7746  -0.5477  -0.2582
```

The output size is `(2+2-1) × (2+2-1) = 3×3`. The peak of `1.0` occurs at the centre `(2,2)`, corresponding to zero offset where `A` and `B` are perfectly aligned. The surrounding values reflect partial overlaps at non-zero offsets where only fractions of `A` and `B` coincide.

---

### Test Case: 7 — Template Larger Than Image (Warning)

Verifies that when the template `A` is larger than the image `B` in every dimension, a non-fatal warning is issued but computation still completes.

```scilab
A = [1 2 3;
     4 5 6;
     7 8 9];

B = [1 2;
     3 4];

C = normxcorr2(A, B);
disp(C);
```

**Expected output:**

```
WARNING: normxcorr2: TEMPLATE larger than IMG. Arguments may be swapped.

C =                                    (4×4)
  -0.5477  -0.5853  -0.4052  -0.2739
   0.0418   0.4041   0.4041   0.2923
   0.2923   0.4041   0.4041   0.0418
  -0.2739  -0.4052  -0.5853  -0.5477
```

`postpad(size(A), ndims(B))` pads `A`'s size vector to `[3, 3]`; comparing element-wise with `size(B) = [2, 2]` shows `3 > 2` in both dimensions, triggering the `warning()`. The function then continues normally. The output size is `(2+3-1) × (2+3-1) = 4×4`. In practice the correlation has no single strong peak because `A` and `B` do not share a meaningful aligned relationship.

---

### Test Case: 8 — Constant Template (Zero Variance)

Verifies that a uniform template of ones produces an all-zero output because the mean-subtracted template is identically zero.

```scilab
A = ones(2,2);

B = [1 2 3;
     4 5 6;
     7 8 9];

C = normxcorr2(A, B);
disp(C);
```

**Expected output:**

```
C =               (4×4)
   0   0   0   0
   0   0   0   0
   0   0   0   0
   0   0   0   0
```

`A - mean(A(:)) = ones(2,2) - 1 = zeros(2,2)`, so `sumsq(A(:)) = 0`. Both numerator and denominator are zero for every offset, producing `NaN` everywhere before the cleanup step replaces all non-finite entries with `0`. The output size is `(3+2-1) × (3+2-1) = 4×4`.

---

### Test Case: 9 — Larger Image with Repeated Pattern

Verifies that a template matching a periodically repeating pattern in a larger image produces multiple peaks of `1.0` at every aligned offset, and `-1.0` at anti-phase offsets.

```scilab
A = [1 2;
     3 4];

B = [1 2 1 2;
     3 4 3 4;
     1 2 1 2;
     3 4 3 4];

C = normxcorr2(A, B);
disp(C);
```

**Expected output:**

```
C =                                           (5×5)
  -0.7746  -0.5477  -0.9129  -0.5477  -0.2582
   0.4472   1.0000   0.6000   1.0000   0.4472
  -0.7454  -0.6000  -1.0000  -0.6000  -0.7454
   0.4472   1.0000   0.6000   1.0000   0.4472
  -0.2582  -0.5477  -0.9129  -0.5477  -0.7746
```

The output size is `(4+2-1) × (4+2-1) = 5×5`. `B` tiles the pattern of `A` exactly, so the template aligns perfectly at offsets `(2,2)`, `(2,4)`, `(4,2)`, and `(4,4)`, all producing a peak of `1.0`. At offset `(3,3)`, the template aligns with an anti-phase repetition (shifted by one period), producing the minimum value of `−1.0`. The value `±0.6` at the remaining interior positions reflects partial alignment with the repeating structure.

---

### Test Case: 10 — Error: Invalid Number of Arguments

Verifies that calling `normxcorr2` with fewer than two arguments raises a descriptive error and halts execution immediately.

```scilab
try
    normxcorr2([1 2; 3 4]);
catch
    disp(lasterror());
end
```

**Expected output:**

```
normxcorr2: Wrong number of input arguments.
```

The function checks `rhs <> 2` at entry using `argn(2)`. Supplying only one argument gives `rhs = 1`, which fails the check and raises the error before any computation occurs. The same error is raised for zero arguments or three or more arguments.

---

### Test Results
The file `normxcorr2_Test_Results.pdf` contains the results obtained from executing all test cases, including:

* Input template and search image.
* Output correlation map.
* 3D Surface Plot and Contour Plot for visualization.
* Error handling outputs for invalid arguments.
---

## Compatibility Notes

This function is a Scilab translation of GNU Octave's `normxcorr2` function (from the Octave `image` package) and preserves the same output size convention, normalization formula, and degenerate-value handling.

### Important Differences from GNU Octave

* **`sumsq` is defined locally as a helper function.** Octave's `sumsq` built-in is available natively; Scilab does not have it, so a one-line helper `function s = sumsq(x); s = sum(x(:).^2); endfunction` is included in the same file.

* **Template rotation via `matrix(a($:-1:1), size(a))`.** In Octave, `a(::-1)` or `rot90(a,2)` is more idiomatic. The Scilab version flattens `a` to a vector in column-major order, reverses it, then reshapes to `size(a)`, which is equivalent to flipping both rows and columns (180° rotation), as required for cross-correlation.

* **No `"same"` or `"valid"` mode support.** The function always returns the full cross-correlation map. To obtain only the region where the template fully overlaps the image (equivalent to `"valid"` mode), extract the interior `(rows(b) - rows(a) + 1) × (cols(b) - cols(a) + 1)` sub-matrix from the output.

* **Negative variance entries are clamped, not treated as zero by default.** Floating-point subtraction in the variance formula can produce small negative values. The explicit `b(find(b < 0)) = 0` guard prevents `sqrt` from returning `NaN` or complex values in these cases.

* **Input type coercion.** Both `a` and `b` are explicitly converted to `double` via `double()` before any arithmetic. Integer-typed inputs (e.g. `uint8` images) are therefore handled transparently.

---
### Recommended Usage

```scilab
// Locate a template patch within a larger image
template = imread("template.jpg");
image    = imread("image.jpg");

// Convert to grayscale if needed
if ndims(template) == 3 then
    template = rgb2gray(template);
    image    = rgb2gray(image);
end

c = normxcorr2(double(template), double(image));

// Find peak location
[peak_r, peak_c] = find(c == max(c(:)));

// Convert full-mode peak back to top-left corner in the image
match_row = peak_r - size(template, 1) + 1;
match_col = peak_c - size(template, 2) + 1;

mprintf("Best match top-left: (%d, %d)\n", match_row, match_col);
```

* Always ensure `a` (template) is smaller than `b` (image) in every dimension to avoid the swap warning and obtain a meaningful correlation map.
* The output is larger than the input; use the peak-to-corner offset formula above to convert the peak position back to image coordinates.
* For binary or integer images, convert to `double` before calling to avoid type-conversion overhead inside the function.
* A peak value of `1.0` guarantees a perfect normalized match; values above `0.8` are typically considered strong matches in practice.

---
## References

[1] GNU Octave Image Package Documentation — `normxcorr2`.

[2] MATLAB Image Processing Toolbox Documentation — `normxcorr2`.
