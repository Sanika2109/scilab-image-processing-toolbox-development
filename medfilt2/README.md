# medfilt2

## Description:
`medfilt2` performs two-dimensional median filtering on a grayscale image.

Median filtering is a non-linear image enhancement technique commonly used to remove impulse noise (salt-and-pepper noise) while preserving image edges. For each pixel, the function replaces the pixel value with the median of the values within a specified neighborhood window.

The function supports multiple padding methods to handle image boundaries, including zero, replicate, circular, reflect, and symmetric padding.
## Calling Sequence:
```
median_filter = medfilt2(I) 
median_filter = medfilt2(I, windowsize) 
median_filter = medfilt2(I, windowsize, padopt)
```

---
## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `I` | Matrix / Image | Input grayscale or RGB image. RGB images are automatically converted to grayscale. |
| `windowsize` | Scalar / Vector | Size of the filtering neighborhood. Can be a scalar `(3)` or a two-element vector `([m n])`. Default: `[3 3]`. |
| `padopt` |  String | Padding method used at image boundaries. Default: `"zero"`. |
| `median_filter` |  Matrix| Output image after median filtering.  |

---

## Supported Padding Modes:

| Mode | Description |
| :--- |  :--- | 
| `"zeros"` | Pads image boundaries with zeros | 
| `"replicate"` |  Replicates border pixels|
| `"circular"` |  Wraps image values around boundaries|
| `"reflect"` |  Reflects image excluding edge pixels|
| `"symmetric"` |  Reflects image including edge pixels| 

---

## Variable Reference:

| Variable         | Scope         | Type             | Description                                                                                                                                                |
| ---------------- | ------------- | ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `I`             | Input | Matrix  |Input grayscale or RGB image.             |
| `windowsize` | Input        | Scalar / Vector         | Neighborhood dimensions for filtering.                                                                          |
| `padopt`           | Input         | String       | Selected padding mode.                           |
| `m`            | Local         | Integer      | Number of rows in filtering window.   |
| `n`            | Local         | Integer      | Number of columns in filtering window.  |
| `row`            | Local         | Integer      |Number of image rows.   |
| `col`            | Local         | Integer      | Number of image columns.   |
| `k1`            | Local         | Integer       | Vertical padding size `(floor(m/2))`.   |
| `k2`            | Local         | Integer       | Horizontal padding size `(floor(n/2))`.   |
| `padded`            | Local         | Matrix      |Padded image used during filtering.   |
| `window`            | Local         | Matrix      | Local neighborhood centered at current pixel.   |
| `values`            | Local         | Vector       | Flattened neighborhood values.  |
| `median_filter`            | Output         | Matrix       | Median-filtered image.   |

---
## Helper Functions:

| Function   | Type     | Purpose                                                                               |
| ---------- | -------- | ------------------------------------------------------------------------------------- |
| `argn()`   | Built-in | Determines the number of supplied arguments.|
| `error()`   | Built-in | Generates error messages for invalid inputs.|
| `ndims()`   | Built-in | Determines image dimensionality.|
| `rgb2gray()`  | Built-in | Converts RGB images to grayscale. |
| `size()`  | Built-in | Obtains image dimensions. |
| `floor()`  | Built-in | Computes padding sizes. |
| `modulo()`   | Built-in | Verifies odd-sized filtering windows.|
| `zeros()`   | Built-in | Creates output and zero-padded matrices.|
| `padarray()` | User-defined | Applies selected padding method.      |
| `median()`  | Built-in | Computes the median of neighborhood values. |
| `matrix()`  | Built-in | Converts neighborhoods into vectors. |
---
## Algorithm:

```text
Start 
│ 
├─ Receive input image I 
│ 
├─ Convert RGB image to grayscale if necessary 
│ 
├─ Validate image dimensions 
│ 
├─ Determine window size 
│ 
├─ Verify window dimensions are odd 
│ 
├─ Compute required padding 
│ 
├─ Apply selected padding method 
│ 
├─ For each image pixel 
│   │ 
│   ├─ Extract local neighborhood 
│   ├─ Convert neighborhood to vector  
│   ├─ Compute median value 
│   └─ Assign median to output pixel 
│ 
└─ Return filtered image

```
                  
---
## Time & Space Complexity:

Let:

`Image Size = M × N`

`Window Size = m × n`



**Time Complexity:** 

For each pixel, the median is computed from an `m × n` neighborhood:

`O(M × N × m × n)`

For the commonly used 3×3 window:

`O(M × N)`

**Space Complexity:** 

`O(M × N)` 

Additional memory is required for:

* Padded image
* Output image

---


## Mathematical Foundation:

### Neighborhood Definition
For a pixel located at:
`(x,y)`

a neighborhood window of size:
`m × n`

is extracted around the pixel.

### Median Operation
Let:

`W = {w₁,w₂,...,wₖ}`

be the set of all pixels in the neighborhood, where:

`k = m × n`

The filtered pixel value is:

`I'(x,y) = median(W)`

### Example
Consider a 3×3 neighborhood:

`[10 12 11;
  9 200 13;
 10 11 12]`

After sorting:

`[9 10 10; 11 11 12; 12 13 200]`

Median value:

`11`

Therefore:

`I'(x,y) = 11`

The noisy value `200` does not significantly affect the result.

### Output Range

The median value is always one of the neighborhood values:

`min(W) ≤ I'(x,y) ≤ max(W)`

Thus the filtered image remains within the intensity range of the original image.

### Noise Reduction Characteristics

Median filtering is particularly effective against:
* Salt-and-pepper noise
* Impulse noise
* Isolated outlier pixels

Unlike averaging filters, median filtering preserves edges while removing noise.



---
## Test Cases:

The following 15 test cases cover valid inputs, boundary conditions, padding modes, noise removal behavior, and error handling. Run them after loading the function first with `exec('padarray_test.sci', -1)` and then with `exec('medfilt2_test.sce', -1)`.

### Test Case: 1 — Default Parameters

Verifies the default behavior of the function using a 3×3 median filter with zero padding.

```scilab
A = imread("cameraman.jpeg");
B = medfilt2(double(A));
```

**Expected output:** `Image is smoothed using a default 3×3 median filter.`

---
### Test Case: 2 — Square Window [5×5]

Verifies filtering with a larger square neighborhood.

```scilab
B = medfilt2(double(A), [5 5], "replicate");
```

**Expected output:** `Stronger noise reduction and smoothing than the default filter.`

---
### Test Case: 3 — Rectangular Window [3×5]

Verifies support for rectangular filtering windows.

```scilab
B = medfilt2(double(A), [3 5], "replicate");
```

**Expected output:** `Filtering is applied using a 3×5 neighborhood.`

---
### Test Case: 4 — Rectangular Window [5×7]

Verifies operation with a larger rectangular window.

```scilab
B = medfilt2(double(A), [5 7], "replicate");
```

**Expected output:** `Increased smoothing with greater loss of fine detail.`

---
### Test Case: 5 — Zero Padding

Verifies boundary handling using zero padding.

```scilab
A = [10 20 30;
     40 50 60;
     70 80 90];

B = medfilt2(double(A), [3 3], "zero");
```

**Expected output:** `Border pixels are influenced by zeros surrounding the image.`


---
### Test Case: 6 — Replicate Padding

Verifies border extension by repeating edge pixels.

```scilab
B = medfilt2(double(A), [3 3], "replicate");
```

**Expected output:** `Border values are preserved better than with zero padding.`

---
### Test Case: 7 — Circular Padding

Verifies circular boundary wrapping.

```scilab
B = medfilt2(double(A), [3 3], "circular");
```

**Expected output:** `Pixels beyond one edge are obtained from the opposite edge.`

---
### Test Case: 8 — Symmetric Padding

Verifies symmetric reflection including boundary pixels.
```scilab
B = medfilt2(double(A), [3 3], "symmetric");
```

**Expected output:** `Border regions are mirrored including edge values.`

---
### Test Case: 9 — Reflect Padding

Verifies reflection excluding boundary pixels.

```scilab
B = medfilt2(double(A), [3 3], "reflect");
```

**Expected output:** `Border regions are mirrored without duplicating edge pixels.`

---
### Test Case: 10 — Salt-and-Pepper Noise Removal

Verifies the primary application of median filtering.

```scilab
A = imread("cameraman.jpeg");
B = medfilt2(double(A), [3 3], "replicate");
```

**Expected output:** `Impulse noise is reduced while preserving edges.`

---
### Test Case: 11 — Extreme Noise Pixel

Verifies removal of an isolated outlier.

```scilab
A = [10 20 30;
     40 255 50;
     60 70 80];

B = medfilt2(double(A), [3 3], "replicate");
```

**Expected output:** `The extreme value 255 is replaced by the neighborhood median.`

---
### Test Case: 12 — Filter Larger Than Image

Verifies behavior when the filtering window exceeds image dimensions.

```scilab
A = [10 20;
     30 40];

B = medfilt2(double(A), [5 5], "replicate");
```

**Expected output:** `Filtering completes successfully due to padding.`

---
### Test Case: 13 — Single Pixel Image

Verifies operation on the smallest possible image.

```scilab
A = 150;

B = medfilt2(double(A), [3 3], "replicate");
```

**Expected output:** `Output remains unchanged.`

---
### Test Case: 14 — Invalid Padding Option

Verifies error handling for unsupported padding modes.

```scilab
B = medfilt2(A,[3 3],"abc");
```

**Expected output:** `Error message generated.`

---
### Test Case: 15 — Even Window Size

Verifies validation of median-filter window dimensions.

```scilab
B = medfilt2(A,[4 4],"replicate");
```

**Expected output:** `Error message generated.`

---
### Test Results

The file `medfilt2_Test_Results.pdf` contains the results obtained from executing all test cases, including:

* Original input images or matrices.
* Filtered outputs generated by `medfilt2()`.
* Error handling outputs for invalid test cases.
* Additional test cases for observation


---

## Compatibility Notes

This implementation follows the behavior of GNU Octave's `medfilt2` function.

### Supported Features

* Scalar window sizes (e.g., `3`)
* Rectangular windows (e.g., `[3 5]`)
* RGB image support through grayscale conversion
* Multiple padding modes:
  * Zero
  * Replicate
  * Circular
  * Reflect 
  * Symmetric 

### Important Differences
* Window dimensions must be odd.
* Empty images are rejected.
* Input images must be grayscale or RGB.
* Padding behavior depends on the user-defined `padarray()` implementation. 
Therefore, loading `padarray()` first is essential for `medfilt2()` to work.

---

### Recommended Usage
**Default 3×3 Median Filter:**
```scilab
B = medfilt2(I);
```
**5×5 Median Filter:**
```scilab
B = medfilt2(I,[5 5]);
```
**Replicate Padding:**
```scilab
B = medfilt2(I,[3 3],"replicate");
```
**Circular Padding:**
```scilab
B = medfilt2(I,[3 3],"circular");
```
**Reflect Padding:**
```scilab
B = medfilt2(I,[3 3],"reflect");
```
**Symmetric Padding:**
```scilab
B = medfilt2(I,[3 3],"symmetric");
```




---

## References

[1] MATLAB Image Processing Toolbox Documentation

[2] GNU Octave Image Package Documentation

