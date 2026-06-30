# stretchlim

## Description:
`stretchlim` computes lower and upper intensity limits for an image, suitable for use as contrast-stretching limits with functions such as `imadjust`.

For each color channel (or each plane of a multi-dimensional image), the function sorts all pixel values and selects two order statistics — by default, the values at the `1st` and `99th` percentiles — as the low and high limits. Pixels below the low limit and above the high limit are treated as the bottom `1%` and top `1%` of outliers respectively, so that subsequent contrast stretching is not skewed by a small number of extreme pixel values. The fraction of pixels excluded at each end is configurable via the `tol` argument. The returned limits are always normalized to `[0, 1]`, regardless of the original image's numeric class.

## Calling Sequence:
```
low_high = stretchlim(img)
low_high = stretchlim(img, tol)
```
## Dependencies

The function depends on the following external file:

| File | Purpose |
|--------|---------|
| `postpad.sci` | The function resizes an array by padding or truncating it along a specified dimension (default `0`). |

The dependency file must be loaded before executing `stretchlim.sci`. The test script does this automatically:

```scilab
base = get_absolute_file_path("stretchlim_test.sce");
exec(base + "../postpad/postpad.sci", -1);
exec(base + "stretchlim.sci", -1);
```
---
## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `img` | Matrix | **Input:** Grayscale image (`M×N`), RGB image (`M×N×3`), or higher-dimensional image stack (`M×N×P×...`). Must satisfy `isimage()` — class `constant` (double), `boolean`, `uint8`, `uint16`, or `int16`, with no zero-length dimension. |
| `tol` | Double / Vector | **Input (optional, default `[0.01 0.99]`):** Either a scalar `t` in `[0, 0.5]`, interpreted as `[t, 1-t]`, or an explicit 2-element vector `[low_frac, high_frac]` in `[0, 1]` with `low_frac ≤ high_frac`. Specifies the fraction of pixels to exclude from the low end and the cumulative fraction to include up to the high end. |
| `low_high` | Double Matrix | **Output:** `2 × C` matrix, where `C` is the number of planes/channels in `img`. Row 1 holds the low limit and row 2 holds the high limit for each channel, both normalized to `[0, 1]`. |

---
## Variable Reference

| Variable | Scope | Type | Description |
| --- | --- | --- | --- |
| `rhs` | Main | Integer | Number of input arguments supplied (`argn(2)`); must be `1` or `2`. |
| `img_type` | Main | String | The original Scilab type of `img` (`"constant"`, `"boolean"`, `"uint8"`, `"uint16"`, `"int16"`), saved before the image is reshaped, and later used to select the correct normalization formula. |
| `sz` | Main | Vector (Integer) | Size of `img`, padded with `postpad()` to at least 3 elements (so `sz(3)` always exists, even for a 2-D grayscale image). |
| `plane_length` | Main | Integer | Number of pixels per plane, `sz(1) * sz(2)`. |
| `img` (reassigned) | Main | Matrix | Reshaped via `matrix()` into a `plane_length × C` matrix, where each column holds all pixels of one channel/plane in linear order. |
| `lo_idx`, `hi_idx` | Main | Integer | 1-based rank positions within each sorted column corresponding to the low and high tolerance fractions: `lo_idx = floor(tol(1) * plane_length) + 1`, `hi_idx = ceil(tol(2) * plane_length)`, both clamped to `[1, plane_length]`. |
| `sorted` | Main | Matrix | Each column of `img` sorted in ascending order via `gsort(..., "g", "i")`, used to look up the values at `lo_idx` and `hi_idx`. |
| `low_high` | Main | Matrix (2×C) | The accumulated low/high limit pairs, one column per channel, before and after normalization. |
| `equal_cols` | Main | Boolean Vector | Marks channels where the computed low and high limits are identical (e.g. a constant-valued channel), which would otherwise produce a zero-width stretch. |

---
## Helper Functions

| Function | Type | Purpose |
| --- | --- | --- |
| `argn()` | Built-in | Determines the number of input arguments supplied (`argn(2)`); used to default `tol` and validate the argument count. |
| `error()` | Built-in | Raises an error and halts execution for invalid argument counts, non-image inputs, or malformed `tol` values. |
| `postpad()` | User-defined | Pads `size(img)` to at least 3 dimensions so the image can always be addressed as `[rows, cols, planes, ...]`, even for 2-D grayscale input. |
| `matrix()` | Built-in | Reshapes `img` from its original multi-dimensional shape into a `plane_length × C` matrix, one column per channel/plane. |
| `gsort()` | Built-in | Sorts each column of the reshaped image in ascending numeric order (`"g", "i"`), used to find the order-statistic values at `lo_idx` and `hi_idx`. |
| `min()`, `max()` | Built-in | Used directly (row-wise, `"r"`) as a fast path when the tolerance spans the entire pixel range (`lo_idx == 1` and `hi_idx == plane_length`), avoiding the cost of a full sort. |
| `repmat()` | Built-in | Broadcasts the fallback limits `[0; 1]` across every constant-valued channel identified by `equal_cols`. |
| `numel(x)` | Helper (local) | Returns the total number of elements in `x` (`size(x, "*")`), used to validate that `tol`, when supplied as a vector, has exactly 2 elements. |
| `isnumeric(x)` | Helper (local) | Returns `%t` if `x`'s type is one of `"constant"`, `"int8"`–`"uint64"`, or `"sparse"`; used to validate that `tol` is numeric. |
| `isimage(img)` | Helper (local) | Returns `%t` if `img`'s type is one of `"constant"`, `"boolean"`, `"uint8"`, `"uint16"`, or `"int16"`, **and** every dimension of `img` is non-zero; used to validate the primary input. |

---

## Time & Space Complexity:

Let `M × N` be the spatial dimensions of `img` and `C` be the number of channels/planes.

Time Complexity: `O(M·N·C · log(M·N))` in the general case — each of the `C` channels is independently sorted via `gsort` (`O(plane_length · log(plane_length))`), where `plane_length = M·N`. When the tolerance spans the full pixel range (`lo_idx == 1` and `hi_idx == plane_length`), the function instead uses `min`/`max`, reducing this to `O(M·N·C)`.

Space Complexity: `O(M·N·C)` — dominated by the reshaped image matrix and, in the general path, the fully sorted copy (`sorted`) of each channel.

---
## Mathematical Foundation

### Order-Statistic Selection

For a channel with `plane_length = M·N` pixels and tolerance pair `(t_lo, t_hi)`, the rank positions selected from the sorted (ascending) pixel values are:

```text
lo_idx = floor(t_lo · plane_length) + 1
hi_idx = ceil(t_hi · plane_length)

low  = sorted_pixels(lo_idx)
high = sorted_pixels(hi_idx)
```

both clamped to the valid index range `[1, plane_length]`.

### Saturation Limits as a Special Case

When `t_lo = 0` and `t_hi = 1`, the formulas above reduce to `lo_idx = 1` and `hi_idx = plane_length`, i.e. the minimum and maximum pixel values. The implementation detects this case directly (avoiding an unnecessary full sort) and computes:

```text
low  = min(pixels)
high = max(pixels)
```

### Normalization by Source Class

The raw selected values are scaled into `[0, 1]` according to the original image's numeric class:

```text
boolean:           low_high = low_high                       (already 0 or 1)
uint8:             low_high = low_high / 255
uint16:            low_high = low_high / 65535
int16:             low_high = (low_high + 32768) / 65535
double ("constant"): low_high = low_high                       (assumed already in [0,1])
```

The `int16` formula reflects the convention that signed 16-bit pixel values span `[-32768, 32767]`, which is shifted and rescaled to occupy `[0, 1]`.

### Degenerate (Constant-Valued) Channels

If a channel's selected low and high limits are equal (e.g. the channel is uniform, or the tolerance window collapses to a single repeated value), the resulting stretch would have zero width. To avoid this, such channels are explicitly replaced with the full-range limits:

```text
if low(k) = high(k):  [low(k); high(k)] ← [0; 1]
```

### Output Range

```text
0 ≤ low_high(1,k) ≤ low_high(2,k) ≤ 1     for every channel k
```

---
## Test Cases:

The following test cases cover all the valid cases and error conditions. Run the test script:

```scilab
exec('stretchlim_test.sce', -1);
```

---

### Test Case: 1 — `uint8` Ramp, Default Tolerance

Verifies the default `tol = [0.01 0.99]` on a full `uint8` intensity ramp spanning every value from `0` to `255`.

```scilab
I = uint8(0:255);
low_high = stretchlim(I)
```

**Expected output:**

```
low_high =
   0.0078
   0.9922
```

With `plane_length = 256`: `lo_idx = floor(0.01×256)+1 = 3`, `hi_idx = ceil(0.99×256) = 254`. Since the ramp contains each integer value exactly once in ascending order, the 3rd-smallest value is `2` and the 254th-smallest value is `253`. Normalizing by `255` gives `low = 2/255 ≈ 0.0078` and `high = 253/255 ≈ 0.9922`.

---

### Test Case: 2 — Scalar Tolerance `0.05`

Verifies that a scalar `tol` is expanded to `[0.05, 0.95]` and applied to the same `uint8` ramp, excluding a larger fraction of pixels at each end than the default.

```scilab
I = uint8(0:255);
low_high = stretchlim(I, 0.05)
```

**Expected output:**

```
low_high =
   0.0471
   0.9529
```

The scalar `tol = 0.05` expands to `[0.05, 0.95]`. With `plane_length = 256`: `lo_idx = floor(0.05×256)+1 = 13`, `hi_idx = ceil(0.95×256) = 244`. The 13th-smallest value is `12` and the 244th-smallest value is `243`; normalized by `255`, these give `low ≈ 0.0471` and `high ≈ 0.9529` — a tighter exclusion than Test Case 1's `1%` default.

---

### Test Case: 3 — Custom Tolerance `[0.20 0.80]` on a Four-Block Image

Verifies a wide custom tolerance on an image with four distinct intensity blocks of equal pixel count.

```scilab
I = uint8([
     10 * ones(10,10), ...
    100 * ones(10,10), ...
    200 * ones(10,10), ...
    250 * ones(10,10)
]);

low_high = stretchlim(I, [0.20 0.80])
```

**Expected output:**

```
low_high =
   0.0392
   0.9804
```

The image is `10×40` with `plane_length = 400` pixels, split into four equal blocks of `100` pixels each (`10`, `100`, `200`, `250`). With `tol = [0.20, 0.80]`: `lo_idx = floor(0.20×400)+1 = 81`, `hi_idx = ceil(0.80×400) = 320`. Sorted ascending, the first `100` entries are `10`, the next `100` are `100`, the next `100` are `200`, and the last `100` are `250`. Position `81` falls within the first block (`value = 10`), and position `320` falls within the third block (`value = 200`). Normalizing by `255` gives `low = 10/255 ≈ 0.0392` and `high = 200/255 ≈ 0.9804`.

---

### Test Case: 4 — Constant `uint8` Image

Verifies that a completely uniform image triggers the degenerate-channel correction, returning the full `[0, 1]` range instead of a zero-width stretch.

```scilab
I = uint8(100 * ones(20,20));
low_high = stretchlim(I)
```

**Expected output:**

```
low_high =
   0
   1
```

All `400` pixels equal `100`. With the default tolerance, `lo_idx = 5` and `hi_idx = 396` both select the value `100`, giving `low = high = 100/255 ≈ 0.3922` before the degenerate check. Since `low_high(1,1) == low_high(2,1)`, the `equal_cols` correction overrides this to `[0; 1]`.

---

### Test Case: 5 — Double-Precision Image with Four Intensity Blocks

Verifies correct handling of a `double`-class image with four distinct intensity levels already in `[0, 1]`, where no class-based rescaling is applied.

```scilab
I = [
    0.10 * ones(10,10), ...
    0.40 * ones(10,10), ...
    0.70 * ones(10,10), ...
    0.95 * ones(10,10)
];

low_high = stretchlim(I)
```

**Expected output:**

```
low_high =
   0.10
   0.95
```

The image is `10×40` with `plane_length = 400`, divided into four equal blocks of `100` pixels (`0.10`, `0.40`, `0.70`, `0.95`). With the default tolerance: `lo_idx = floor(0.01×400)+1 = 5`, `hi_idx = ceil(0.99×400) = 396`. Both positions fall within the first and last blocks respectively (since each block spans `100` consecutive sorted positions), giving `low = 0.10` and `high = 0.95` directly, with no rescaling since the source class is `double`.

---

### Test Case: 6 — Skewed Histogram with Unequal Block Widths

Verifies correct order-statistic selection when the four intensity blocks have unequal pixel counts, producing a skewed (non-uniform) histogram.

```scilab
I = uint8([
     20 * ones(20,5), ...
     80 * ones(20,15), ...
    180 * ones(20,20), ...
    240 * ones(20,10)
]);

low_high = stretchlim(I)
```

**Expected output:**

```
low_high =
   0.0784
   0.9412
```

The image is `20×50` with `plane_length = 1000`, composed of four blocks of unequal pixel counts: `100` pixels at `20`, `300` pixels at `80`, `400` pixels at `180`, and `200` pixels at `240`. With the default tolerance: `lo_idx = floor(0.01×1000)+1 = 11`, `hi_idx = ceil(0.99×1000) = 990`. Position `11` falls within the first block (`100` pixels, value `20`), and position `990` falls within the last block (the final `200` positions, `801`–`1000`, value `240`). Normalizing by `255` gives `low = 20/255 ≈ 0.0784` and `high = 240/255 ≈ 0.9412`.

---

### Test Case: 7 — `uint16` Full-Range Image

Verifies correct order-statistic selection and `/65535` normalization on a large `uint16` image spanning the full `16`-bit intensity range.

```scilab
I = matrix(uint16(0:65535), 256, 256);
low_high = stretchlim(I)
```

**Expected output:**

```
low_high =
   0.0100
   0.9900
```

The image contains all `65536` values from `0` to `65535` exactly once, reshaped into `256×256`. With `plane_length = 65536`: `lo_idx = floor(0.01×65536)+1 = 656`, `hi_idx = ceil(0.99×65536) = 64881`. Since the values are sorted ascending in linear order, the 656th-smallest value is `655` and the 64881st-smallest value is `64880`. Normalizing by `65535` gives `low = 655/65535 ≈ 0.0100` and `high = 64880/65535 ≈ 0.9900`.

---

### Test Case: 8 — `int16` Image with Four Intensity Regions

Verifies the signed-`int16` normalization formula `(value + 32768) / 65535` on an image with unequal-width intensity blocks spanning both negative and positive values.

```scilab
I = int16([
   -25000 * ones(20,5), ...
   -5000  * ones(20,15), ...
    5000  * ones(20,20), ...
    25000 * ones(20,10)
]);

low_high = stretchlim(I)
```

**Expected output:**

```
low_high =
   0.1185
   0.8815
```

The image is `20×50` with `plane_length = 1000`, composed of the same block-count structure as Test Case 6: `100` pixels at `-25000`, `300` at `-5000`, `400` at `5000`, and `200` at `25000`. With the default tolerance: `lo_idx = 11` and `hi_idx = 990`, falling within the first block (value `-25000`) and the last block (value `25000`) respectively. Applying the `int16` normalization: `low = (-25000 + 32768)/65535 ≈ 0.1185` and `high = (25000 + 32768)/65535 ≈ 0.8815`.

---

### Test Case: 9 — RGB Image with Distinct Per-Channel Distributions

Verifies that each channel of a 3-channel `uint8` image is processed independently, including a constant blue channel that triggers the degenerate-channel correction.

```scilab
I = zeros(16,16,3,"uint8");
I(:,:,1) = matrix(uint8(0:255), 16, 16);
I(:,:,2) = matrix(uint8(255:-1:0), 16, 16);
I(:,:,3) = uint8(128 * ones(16,16));

low_high = stretchlim(I)
```

**Expected output:**

```
low_high =
   0.0078   0.0078   0
   0.9922   0.9922   1
```

Each channel has `plane_length = 256`, giving `lo_idx = 3` and `hi_idx = 254`, as in Test Case 1. The red channel is an ascending ramp `0..255`, so `low = 2/255 ≈ 0.0078` and `high = 253/255 ≈ 0.9922`. The green channel is a descending ramp `255..0`, containing the same set of values in different spatial positions, so it produces identical limits to the red channel after sorting. The blue channel is constant at `128`, so `low = high = 128/255` before correction, triggering the `equal_cols` fallback to `[0; 1]`.

---

### Test Case: 10 — Error: Invalid Tolerance (`TOL(1) > TOL(2)`)

Verifies that an explicit 2-element tolerance vector with an inverted ordering raises a descriptive error.

```scilab
try
    stretchlim(uint8(0:255), [0.8 0.2]);
catch
    disp(lasterror());
end
```

**Expected output:**

```
stretchlim: TOL(1) must not exceed TOL(2)
```

`tol = [0.8, 0.2]` has both elements individually within `[0, 1]`, but `tol(1) = 0.8` exceeds `tol(2) = 0.2`, violating the required `tol(1) ≤ tol(2)` ordering. The validation check explicitly rejects this combination before any pixel data is processed.

---

### Test Results
The file `stretchlim_Test_Results.pdf` contains the results obtained from executing all test cases, including:

* Input image matrix.
* Output low and high values.
* Error handling outputs for invalid arguments.
* Additional test cases with actual images.
---
## Compatibility Notes

This function is a Scilab translation of GNU Octave's `stretchlim` function (from the Octave `image` package) and preserves the same default tolerance, order-statistic selection, and per-channel normalization behavior.

### Important Differences from GNU Octave

* **`isimage()` and `isnumeric()` are locally defined helpers.** Octave provides `isnumeric()` natively; Scilab does not, so a local helper checks `typeof(x)` against a fixed list of numeric type strings. `isimage()` is similarly a local helper combining a type check with a non-empty-dimension check, since Scilab has no direct equivalent of Octave's image-class validation.

* **`gsort(..., "g", "i")` for ascending sort.** Octave's `sort()` defaults to ascending order directly; Scilab's `gsort()` defaults to **descending** order, so the explicit `"i"` (increasing) flag is required to match Octave's behavior. Omitting this flag would silently reverse the order-statistic selection.

* **`postpad()` dependency for shape normalization.** The function relies on the external `postpad.sci` to pad `size(img)` to at least 3 dimensions, ensuring a 2-D grayscale image can be addressed uniformly alongside 3-D (RGB) and 4-D (image stack) inputs without special-casing the 2-D case throughout the function body.

* **Error message wording for unsupported class.** The final `else` branch in the class-normalization `select` statement raises `"im2double: IMG is of unsupported class"` rather than `"stretchlim: ..."`. This appears to be inherited/copied from a related `im2double`-style helper and is a minor naming inconsistency rather than a functional issue.

* **Clamping order.** Class normalization is applied before clamping to `[0,1]`, and the degenerate-channel (`equal_cols`) check is applied after clamping. This ordering matters: a channel whose values clamp to identical limits only after the `[0,1]` clip will still correctly trigger the `equal_cols` correction, since the comparison happens on the already-clamped values.

---
### Recommended Usage

```scilab
// Typical contrast-stretching workflow
img = imread("photo.jpg");
low_high = stretchlim(img);                 // default 1%-99% tolerance
img_stretched = imadjust(img, low_high, []);

// Tighter tolerance (exclude more outliers) for noisy images
low_high = stretchlim(img, [0.02 0.98]);

// Use the full saturation range (no outlier exclusion)
low_high = stretchlim(img, [0 1]);
```

* Use the default tolerance (`[0.01 0.99]`) for most natural images; it provides robust contrast stretching without being overly sensitive to a few extreme pixels (e.g. sensor noise or specular highlights).
* For images with a small number of pixels (e.g. small crops or patches), the default tolerance may reduce to the full saturation range automatically, since `lo_idx` and `hi_idx` can collapse to `1` and `plane_length` respectively — this is expected and matches Octave's behavior.
* `stretchlim`'s output is intended to be passed directly as the second argument to `imadjust()`; the two functions are designed to be used together.
* For images with a uniform or near-uniform channel (e.g. a solid-color background), expect that channel's limits to fall back to `[0, 1]` rather than failing or producing a degenerate stretch.

---
## References

[1] GNU Octave Image Package Documentation — `stretchlim`.

[2] MATLAB Image Processing Toolbox Documentation — `stretchlim`, `imadjust`.
