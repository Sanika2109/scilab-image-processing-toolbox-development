# phantom

## Description:
`phantom` generates a standard Shepp-Logan head phantom, widely used to test and benchmark image reconstruction and tomography algorithms (such as CT and MRI). It creates the image by summing a set of ellipses, each defined by its intensity, size, position, and rotation. Overlapping ellipses combine their intensities, allowing negative-valued ellipses to subtract from previously added regions. The ellipse set can be one of the built-in models (`"shepp-logan"` or `"modified shepp-logan"`), a user-supplied `N×6` ellipse matrix, or omitted (defaulting to the modified Shepp-Logan model). The output image size defaults to `256×256` but can be specified independently.

## Calling Sequence:
```
head            = phantom()
head            = phantom(model)
head            = phantom(E)
head            = phantom(n)
head            = phantom(model, n)
head            = phantom(E, n)
[head, ellipses] = phantom(...)
```

---
## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `model` | String | **Input (optional):** `"shepp-logan"` (classic, high-contrast) or `"modified shepp-logan"` (default, softer contrast). Case-insensitive. |
| `E` | Matrix | **Input (optional):** Custom ellipse matrix, `N×6`, one row per ellipse: `[I  a  b  x0  y0  phi]`. |
| `n` | Integer | **Input (optional, default `256`):** Output image size; produces an `n×n` image. May be given alone, or as the second argument after `model`/`E`. |
| `head` | Matrix | **Output:** The generated `n×n` phantom image. |
| `ellipses` | Matrix | **Output:** The `N×6` ellipse matrix actually used to build `head` — either the resolved named model or the user-supplied `E`. |

Only one of `model`, `E`, or `n` may be given as the *first* argument; if `n` is given first, no second argument is allowed. If a first argument of `model` or `E` is given, a second argument (if present) must be `n`.

### Ellipse Matrix Columns

| Column | Symbol | Meaning |
| :---: | :---: | --- |
| 1 | `I` | Intensity added within the ellipse. |
| 2 | `a` | Semi-axis length along the ellipse's unrotated x-direction, in normalized coordinates `[-1, 1]`. |
| 3 | `b` | Semi-axis length along the unrotated y-direction. |
| 4 | `x0` | Horizontal center offset. |
| 5 | `y0` | Vertical center offset. |
| 6 | `phi` | Rotation angle in degrees, counter-clockwise from horizontal. |

---
## Variable Reference

| Variable | Scope | Type | Description |
| --- | --- | --- | --- |
| `rhs` | Main | Integer | Number of input arguments supplied (`argn(2)`); must be `0`, `1`, or `2`. |
| `ellipses` | Main | Matrix | The ellipse set to render; defaults to `mod_shepp_logan()`, overwritten by a named model or a user-supplied `E`. |
| `n` | Main | Integer | Output image size; defaults to `256`, overwritten by a numeric integer scalar argument. |
| `in` | Main | Any | The first trailing argument (`varargin(1)`), inspected to decide whether it is a model name, an ellipse matrix, or `n`. |
| `head` | Main | Matrix | The output image, initialized as `zeros(n,n)` and accumulated ellipse-by-ellipse. |
| `xvals` | Main | Row Vector | `n` evenly spaced values spanning `[-1, 1]`, the normalized coordinate axis. |
| `xgrid` | Main | Matrix | `xvals` replicated into `n` identical rows (`repmat`); gives the horizontal coordinate of every pixel. |
| `i` | Main | Integer | Loop index over rows of `ellipses` (i.e. over individual ellipses). |
| `I`, `a2`, `b2`, `x0`, `y0`, `phi` | Main | Scalar | Per-ellipse parameters read from row `i` of `ellipses`; `a2`/`b2` are the squared semi-axes, `phi` is converted from degrees to radians. |
| `x`, `y` | Main | Matrix | Per-pixel offsets from the ellipse center (`xgrid - x0`, and the vertically-flipped transpose of `xgrid` minus `y0`). |
| `cos_p`, `sin_p` | Main | Scalar | `cos(phi)`, `sin(phi)`, used to rotate pixel offsets into the ellipse's own axis frame. |
| `locs` | Main | Column Vector (Integer) | Linear indices of pixels satisfying the rotated-ellipse membership inequality for the current ellipse. |

---
## Helper Functions

| Function | Type | Purpose |
| --- | --- | --- |
| `argn()` | Built-in | Determines the number of input arguments supplied (`argn(2)`); used to validate argument count and select the parsing branch. |
| `error()` | Built-in | Raises an error for too many arguments, an unrecognized model name, or an unrecognized/invalid first or second argument. |
| `typeof()`, `convstr()` | Built-in | Detect whether the first argument is a string, and normalize it to lowercase for case-insensitive model-name matching. |
| `ndims()`, `size()` | Built-in | Confirm a candidate ellipse matrix is 2-D with exactly 6 columns, and read the number of ellipse rows for the main loop. |
| `isscalar()`, `ceil()` | Built-in | Confirm a candidate `n`/second argument is a scalar and an integer (`ceil(x)==x`). |
| `isnumeric()` | User-defined (local) | Returns `%t` if `x`'s type is one of `"constant"`, `"int8"`–`"uint64"`, or `"sparse"`; used to validate the first argument (as `E`/`n`) and the second argument (`n`). Scilab has no built-in `isnumeric()`. |
| `zeros()`, `repmat()` | Built-in | Allocate the blank output image and build the replicated coordinate grid `xgrid`. |
| `flipdim()` | Built-in | Flips the transposed coordinate grid vertically to build the y-coordinate grid with `+1` at the top row. |
| `cos()`, `sin()` | Built-in | Compute the rotation components used to align pixel offsets with each ellipse's own axis frame. |
| `find()` | Built-in | Locates all pixels satisfying the rotated-ellipse membership inequality, returned as linear indices. |
| `shepp_logan()` | User-defined (local) | Returns the classic Shepp-Logan `10×6` ellipse matrix (higher-contrast intensities). |
| `mod_shepp_logan()` | User-defined (local) | Returns the modified Shepp-Logan `10×6` ellipse matrix (softer-contrast intensities); the function's default ellipse set. |

---

## Time & Space Complexity:

Let `n` be the output image size (`n×n`) and `K` the number of ellipses.

**Time Complexity:** `O(K·n²)` — each of the `K` ellipses is processed over the entire `n×n` image grid.

**Space Complexity:** `O(n²)` — dominated by the image and temporary coordinate grids; the ellipse matrix requires only `O(K)` space.

---
## Mathematical Foundation

### Coordinate Grid Construction

```text
xvals(j) = -1 + (j-1)·2/(n-1)            for j = 1..n
xgrid(i,j) = xvals(j)                     // varies along columns -> x-coordinate
ygrid(i,j) = xvals(n-i+1)                 // varies along rows, flipped -> y-coordinate, +1 at top row
```

`ygrid` is built as `flipdim(xgrid', 1)`: transposing `xgrid` makes it vary by row instead of column, and flipping the row order places `y = +1` at the image's top row and `y = -1` at the bottom, matching the phantom's usual mathematical orientation.

### Rotated Ellipse Membership Test

For each ellipse, pixel offsets `(x, y) = (xgrid - x0, ygrid - y0)` are rotated into the ellipse's own (unrotated) axis frame:

```text
x' =  x·cos(phi) + y·sin(phi)
y' =  y·cos(phi) - x·sin(phi)
```

A pixel belongs to the ellipse when:

```text
(x'^2)/a^2 + (y'^2)/b^2 <= 1
```

### Intensity Accumulation (Superposition)

Ellipses are processed in row order, and their intensities are *added* — not overwritten — at every pixel they cover:

```text
head(p) = sum of I_k over every ellipse k whose region contains pixel p
```

This additive rule is what lets a later, smaller ellipse (often with negative `I`) carve out or soften a region created by an earlier, larger one — the mechanism behind the classic Shepp-Logan skull/ventricle structure.

---
## Test Cases:

The following 10 test cases (Test 10 containing 5 sub-cases) cover the default model, both named models, custom ellipse matrices, image-size overrides, geometric edge cases, and invalid-input handling. Run the test script:

```scilab
exec('phantom_test.sce', -1);
```

### Test Case: 1 — Default Phantom

Verifies the zero-argument call, which uses the modified Shepp-Logan model at the default size `n = 256`.

```scilab
[head,E] = phantom();
```

**Expected output:**

```
Image Size: 256   256
Image Sum:  ≈ 8044.0
Mean Intensity: ≈ 0.1227
Output: E = the built-in 10x6 modified Shepp-Logan ellipse matrix
```

With no arguments, `ellipses = mod_shepp_logan()` and `n = 256` (both defaults). `head`'s total intensity is the accumulated sum over all 10 (overlapping) ellipses; mean intensity is `sum(head)/n²`.

---

### Test Case: 2 — Small Image (N = 8)

Verifies image-size override with `n = 8`, small enough to inspect every pixel directly.

```scilab
head = phantom(8);
```

**Expected output:**

```
Image Size: 8   8
Image Sum:  7.6

0     0     0     0     0     0     0     0
0     0     1     0.2   0.2   1     0     0
0     0     0.2   0.3   0.3   0.2   0     0
0     0     0.2   0     0.2   0.2   0     0
0     0     0.2   0     0     0.2   0     0
0     0     0.2   0.2   0.2   0.2   0     0
0     0     1     0.2   0.2   1     0     0
0     0     0     0     0     0     0     0
```

`in` is a numeric integer scalar (`64.5`-style checks pass for `8`), so `n = 8` and the default `mod_shepp_logan()` ellipse set is used. Two interior cells that are mathematically exactly `0` (from `1 - 0.8 - 0.2`) may print as a tiny negative floating-point residue (`≈ -5.5e-17`) rather than a clean `0`, due to normal floating-point summation order — not an error in the padding/accumulation logic.

---

### Test Case: 3 — 90 Degree Rotation

Verifies a single custom ellipse rotated by `90°`, centered at the origin.

```scilab
E = [1 0.55 0.20 0 0 90];
[head,ell] = phantom(E,128);
```

**Expected output:**

```
Image Size: 128   128
Image Sum: 1400
Center Pixel (64,64): 1
Non-zero Pixels: 1400
```

Since the single ellipse has intensity `1`, every covered pixel contributes exactly `1`, so `sum(head)` equals the non-zero pixel count. Rotating by `90°` swaps the effective orientation of the `a`/`b` semi-axes in image space but does not change the ellipse's area or pixel footprint; the origin-centered ellipse covers the image center, so `head(64,64) = 1`.

---

### Test Case: 4 — Shepp-Logan Phantom

Verifies the classic (unmodified) `"shepp-logan"` named model.

```scilab
[head,E] = phantom("shepp-logan");
```

**Expected output:**

```
Image Size: 256   256
Minimum Intensity: 0
Maximum Intensity: 1
Output: E = the built-in 10x6 classic Shepp-Logan ellipse matrix
```

`"shepp-logan"` matches the first `select` case, so `ellipses = shepp_logan()` (higher-contrast intensities than the modified model). Despite the classic model's larger per-ellipse intensities (e.g. `-0.98`), the cumulative superposition of all 10 ellipses still bottoms out at `0` and tops out at `1` for this particular parameter set.

---

### Test Case: 5 — Negative Intensity Ellipse

Verifies a single ellipse with negative intensity against a zero background.

```scilab
E = [-0.8 0.40 0.30 0 0 0];
[head,ell] = phantom(E,128);
```

**Expected output:**

```
Image Size: 128   128
Minimum Intensity: -0.8
Maximum Intensity: 0
Image Sum: -1212.8
```

With only one ellipse of intensity `-0.8`, every interior pixel is set to `-0.8` and every exterior pixel remains at the initial background value `0`. The maximum is therefore the untouched background (`0`), the minimum is the ellipse fill (`-0.8`), and `sum(head) = -0.8 × (interior pixel count) = -1212.8`.

---

### Test Case: 6 — Ellipse Partially Outside Image

Verifies an ellipse whose center is offset far enough that part of its mathematical extent lies beyond the sampled `[-1, 1]` domain.

```scilab
E = [1 0.40 0.30 0.80 0 0];
[head,ell] = phantom(E,128);
```

**Expected output:**

```
Image Size: 128   128
Image Sum: 1240
Non-zero Pixels: 1240
```

The ellipse (center `x0 = 0.80`, semi-axis `a = 0.40`) mathematically extends to `x = 1.20`, beyond the grid's maximum coordinate of `1`. No explicit clipping logic is needed: the coordinate grid simply never samples points past `±1`, so only the in-domain portion of the ellipse is counted. As in Test Case 3, unit intensity means `sum(head)` equals the non-zero pixel count.

---

### Test Case: 7 — Rotated and Shifted Ellipses

Verifies two independently rotated, off-center, non-overlapping ellipses.

```scilab
E = [ 1.0  0.35 0.15 -0.30  0.20  30;
     -0.5  0.20 0.10  0.30 -0.20 -45];
[head,ell] = phantom(E,256);
```

**Expected output:**

```
Image Size: 256   256
Image Sum: 2169
Center Pixel (128,128): 0
```

Both ellipses are shifted away from the origin in opposite directions and do not reach the image center, so `head(128,128) = 0`. `sum(head)` combines the positive contribution of the first ellipse (`+1.0` per pixel) and the negative contribution of the second (`-0.5` per pixel) over their respective (disjoint) footprints.

---

### Test Case: 8 — Overlapping Ellipses

Verifies two ellipses of identical size and center but different intensities, which therefore overlap completely.

```scilab
E = [1.0 0.40 0.40 0 0 0;
     0.7 0.40 0.40 0 0 0];
[head,ell] = phantom(E,101);
```

**Expected output:**

```
Image Size: 101   101
Maximum Intensity: 1.7
Non-zero Pixels: 1255
Image Sum: 2133.5
```

Because both ellipses share identical size, center, and rotation, their footprints coincide exactly: every covered pixel receives both intensities (`1.0 + 0.7 = 1.7`), and no pixel receives only one. This is confirmed by `sum(head) = 1255 × 1.7 = 2133.5`, i.e. every non-zero pixel has the same combined value.

---

### Test Case: 9 — Ellipses Completely Outside Image

Verifies an ellipse whose entire extent lies outside the sampled `[-1, 1]` domain.

```scilab
E = [1.0 0.20 0.20 3 3 0];
[head,ell] = phantom(E,128);
```

**Expected output:**

```
Image Size: 128   128
Image Sum: 0
Non-zero Pixels: 0
```

With center `(3, 3)` and semi-axes of only `0.20`, the ellipse never comes within range of the `[-1, 1]` coordinate grid, so the membership inequality is never satisfied for any pixel; `head` remains entirely `0`.

---

### Test Case: 10 — Invalid Inputs

Verifies that malformed calls are rejected with the function's specific error messages, and that no image is computed in any of these cases.

#### Case 1 — Invalid Model

```scilab
phantom("brain");
```

**Expected output:** Error — `"phantom: unknown MODEL"`

`"brain"` matches neither `"shepp-logan"` nor `"modified shepp-logan"`, so the `select` statement's `else` branch raises an error. Note that the format string passed to `msprintf` has no `%s` placeholder, so the offending model name (`"brain"`) is never actually inserted into the displayed message, despite being passed as an argument.

#### Case 2 — Invalid Ellipse Matrix

```scilab
phantom(rand(4,5));
```

**Expected output:** Error — `"phantom: first argument must either be MODEL, E, or N"`

A `4×5` numeric matrix fails the ellipse-matrix check (`size(in,2) == 6` requires exactly 6 columns) and is not a scalar, so it matches none of the three accepted first-argument forms (`model`, `E`, `n`).

#### Case 3 — Invalid Numeric Input

```scilab
phantom(64.5);
```

**Expected output:** Error — `"phantom: first argument must either be MODEL, E, or N"`

`64.5` is numeric and scalar but fails the integer check `ceil(in) == in`, and it also doesn't have 6 columns to qualify as an ellipse matrix, so it matches none of the accepted forms.

#### Case 4 — Invalid Second Argument

```scilab
phantom("shepp-logan","abc");
```

**Expected output:** Error — `"phantom: N must be numeric scalar"`

The first argument is a valid model name, but the second argument `"abc"` is not numeric, failing the required check for the trailing `n` argument.

#### Case 5 — Too Many Inputs

```scilab
phantom(64,64,64);
```

**Expected output:** Error — `"phantom: Wrong number of input arguments."`

Three arguments exceed the function's maximum of two (`rhs > 2`); this check happens immediately, before any individual argument is inspected.

---

### Test Results

The file `phantom_Test_Results.pdf` contains the output generated for each test case, including:
* Input image matrix parameters.
* Output blocks.
* Error generated for invalid inputs.
  
---

## Compatibility Notes

This function mirrors the behavior of Octave's Image Processing Toolbox `phantom` function, including the `model`/`E`/`n` argument forms, the two named ellipse sets, and the `[head, ellipses] = phantom(...)` output signature.

### Important Differences from Octave

* **`isnumeric()` is a locally defined helper.** Scilab has no built-in `isnumeric()`; a local helper checks `typeof(x)` against a fixed list of numeric type strings, used to validate `E`, `n`, and the second (`n`) argument.

* **The "unknown MODEL" error does not include the offending name.** The call `msprintf("phantom: unknown MODEL", in)` supplies `in` as an argument, but the format string contains no `%s` (or similar) placeholder to consume it, so the invalid model string is silently dropped from the displayed error — a minor formatting inconsistency inherited from the original message construction, not a functional issue with input rejection.

* **`flipdim()` instead of `flip()`.** Octave's `flip(X,dim)` corresponds to Scilab's `flipdim(X,dim)`, used here to orient the y-coordinate grid.

* **No structural validation of a custom `E`'s numeric contents.** Any `2-D` numeric matrix with exactly 6 columns is accepted as an ellipse matrix regardless of whether its values are physically sensible (e.g. zero or negative axis lengths); this matches Octave's equally permissive behavior.

* **Model-name matching is case-insensitive but not whitespace/hyphen-tolerant.** `convstr(in,"l")` lowercases the input before comparison, but the accepted strings must still match `"shepp-logan"` / `"modified shepp-logan"` exactly (including the hyphen and space); no fuzzy matching is performed.

---
### Recommended Usage

```scilab
// Standard test image for reconstruction/CT algorithms
head = phantom();                          // 256x256 modified Shepp-Logan
imshow(head, []);

// Classic (higher-contrast) reference phantom
head = phantom("shepp-logan");

// Custom resolution
head = phantom(512);

// Custom synthetic test geometry
E = [1 0.5 0.3 0 0 0; -0.5 0.2 0.1 0.1 0.1 45];
[head, ellipses] = phantom(E, 256);
```

* Use the default (`modified shepp-logan`) model for most reconstruction-algorithm sanity checks; it has lower dynamic range and is easier to visualize than the classic model.
* Use a custom `E` to construct minimal synthetic test cases (e.g. a single ellipse) when isolating a specific geometric or intensity edge case, as in Test Cases 3–9 above.
* Request the second output (`ellipses`) whenever the exact parameters used to build `head` need to be inspected or reused, rather than re-deriving them from a model name.
* Remember that `n` can only be supplied as the sole argument, or as the second argument after `model`/`E` — `phantom(n1, n2)` is always rejected.

---
## References

[1] Octave Image Processing Toolbox Documentation — `phantom`.

[2] Shepp, L. A., & Logan, B. F. (1974). *The Fourier Reconstruction of a Head Section*. IEEE Transactions on Nuclear Science, 21(3), 21–43.
