# histeq

## Description:
`histeq` performs histogram equalization on a grayscale image.

Histogram equalization is a contrast-enhancement technique that redistributes image intensity values so that the resulting histogram becomes more uniform. This improves visibility in images whose pixel intensities occupy only a small portion of the available intensity range.

If an RGB image is provided, it is first converted to grayscale before equalization.
## Calling Sequence:
```
equi_hist = histeq(Img)
equi_hist = histeq(Img, numBins)
```

---
## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `Img` | Matrix | **Input:** Grayscale or RGB image. |
| `numBins` | Integer | **Input (Optional):** Number of histogram bins used during equalization. Default: `64`. |
| `equi_hist` |  Matrix | Histogram-equalized image with intensity values in the range `[0-1]`. |

---
## Variable Reference

| Variable         | Scope         | Type             | Description                                                                                                                                                |
| ---------------- | ------------- | ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Img`             | Input / Local | Matrix  |Input image. RGB images are converted to grayscale.               |
| `numBins` | Input / Local        | Integer         | Number of histogram bins used during equalization.                                                                           |
| `row`           | Local         | Integer       | Number of rows in the image.                                 |
| `col`            | Local         | Integer      | Number of columns in the image.    |
| `minIntensity`            | Local         | Double       | Minimum intensity value in the image.   |
| `maxIntensity`            | Local         | Double       | Maximum intensity value in the image   |
| `normalizedImg`            | Local         | Matrix       | Image normalized to the range `[0,1]`   |
| `binIndices`            | Local         | Matrix      | Histogram bin assigned to each pixel.   |
| `histCount`            | Local         | Vector       | Number of pixels in each histogram bin.  |
| `cdf`            | Local         | Double       | Maximum intensity value in the image   |
| `equi_hist`            | Output         | Matrix      | Histogram-equalized image. |
---
## Helper Functions

| Function   | Type     | Purpose                                                                               |
| ---------- | -------- | ------------------------------------------------------------------------------------- |
| `ndims()`  | Built-in | Determines image dimensionality. |
| `rgb2gray()`  | Built-in | Converts RGB images to grayscale. |
| `argn()`   | Built-in | Determines the number of input arguments supplied to the function.|
| `isempty()`   | Built-in | Checks for empty input images.|
| `double()` | Built-in | Converts input arrays to double precision before arithmetic operations.      |
| `size()`  | Built-in | Obtains image dimensions. |
| `min()`  | Built-in | Finds minimum intensity value.   |
| `max()`  | Built-in | Finds maximum intensity value.|
| `floor()`   | Built-in | Assigns pixels to histogram bins.|
| `zeros()`   | Built-in | Initializes histogram counts.|
| `sum()`   | Built-in | Counts pixels belonging to each bin.|
| `cumsum()`   | Built-in | Computes cumulative histogram.|
| `matrix()`   | Built-in | Reshapes equalized pixel values into image form.|

---

## Time & Space Complexity:

Time Complexity: O(M × N + B)

where:
* `M × N` = image size.
* `B` = number of histogram bins

Since `B = 64` by default, complexity is effectively O(M × N).

Space Complexity: O(M × N + B)

---


## Mathematical Foundation

Histogram equalization redistributes image intensities using the cumulative distribution function (CDF) of the image histogram.

### Image Normalization
Pixel values are first normalized:

`I_norm(x,y) = (I(x,y) - I_min) / (I_max - I_min)`

where:

* `I_min` = minimum image intensity

* `I_max` = maximum image intensity


### Histogram Computation
The normalized image is divided into `numBins` bins.

For each bin:

`H(k) = Number of pixels assigned to bin k`

### Cumulative Distribution Function

The cumulative histogram is:

`CDF(k) = (1 / (M * N)) * Σ(H(i)),  i = 0 to k`

where:

* `M * N` = total number of pixels

### Intensity Mapping

Each pixel is assigned a new intensity using the CDF:

`I_eq(x,y) = CDF(bin(x,y))`

This produces an equalized image whose intensities lie within:

`0 <= I_eq(x,y) <= 1`

---

### Output Range

|Condition	| Output |
| :--- | :--- | 
Empty image	|Empty matrix
Constant image|	Original image returned unchanged
General image|	Equalized image in range `[0,1]`



---
### Difference between Histogram Stretching and Histogram Equalization

|Method	|Purpose|
| :--- | :--- |
Contrast Stretching	|Expands intensity range linearly.
Histogram Equalization	|Redistributes intensities using the image histogram.

Histogram equalization generally provides stronger contrast enhancement than simple linear stretching.

---
## Test Cases:

The following 6 test cases validate histogram equalization under different image characteristics and histogram-bin configurations. Run the test script: 

```scilab
exec('histeq_test.sce', -1);
```

### Test Case: 1 — Bright Image

Verifies that histogram equalization improves contrast in an image whose pixel intensities are concentrated near the higher end of the intensity range.

```scilab
A = imread("bright_img.jpg");
B = histeq(A);
```

**Expected output:** 
* Contrast is enhanced.
* Histogram becomes more evenly distributed.
* Bright regions become more distinguishable.

**Observation:**
```
The original histogram is concentrated near high intensity values.  
After equalization, the histogram spreads across a wider range, 
improving contrast in bright regions.
```

---
### Test Case: 2 — Dark Image

Verifies that histogram equalization improves visibility in images whose intensities are concentrated near zero.

```scilab
A = imread("dark_image.jpeg");
B = histeq(A);
```

**Expected output:** 
* Dark regions become more visible.
* Contrast increases.
* Histogram spreads over a wider intensity range.

**Observation:**
```
The histogram shifts from low intensities to a broader distribution, 
making dark details more visible.
```

---
### Test Case: 3 — Low Contrast Image

Verifies contrast enhancement for images having a narrow intensity distribution.

```scilab
A = imread("lc_image.jpg");
B = histeq(A);
```

**Expected output:** 
* Significant contrast improvement.
* Details previously hidden become visible.
* Histogram becomes more uniformly distributed.

**Observation:**
```
The narrow histogram expands significantly after equalization, 
resulting in noticeable contrast enhancement.
```

---
### Test Case: 4 — Very Few Histogram Bins

Verifies behavior when the number of histogram bins is extremely small.

```scilab
A = imread("grayscale_img.jpg");
B = histeq(A,4);
```

**Expected output:** 
* Equalization completes successfully.
* Output image may exhibit intensity quantization.
* Histogram contains only a few dominant intensity levels.

**Observation:**
```
The output image exhibits visible quantization 
because only four histogram levels are available.
```

---
### Test Case: 5 — Very Large Number of Histogram Bins

Verifies behavior when the number of histogram bins greatly exceeds the default value.

```scilab
A = imread("grayscale_img.jpg");
B = histeq(A,512);
```

**Expected output:** 
* Equalization completes successfully.
* Histogram mapping becomes more detailed.
* Output image remains normalized to the range `[0,1]`.

**Observation:**
```
A large number of bins provides
finer intensity mapping and smoother equalization.
```

---
### Test Case: 6 — Adequate Number of Histogram Bins

Verifies histogram equalization using a moderate number of bins.

```scilab
A = imread("grayscale_img.jpg");
B = histeq(A,128);
```

**Expected output:** 
* Contrast enhancement is achieved.
* Histogram becomes more evenly distributed.
* Visual quality improves compared to the original image.

**Observation:**
```
The histogram is redistributed effectively 
while maintaining smooth intensity transitions.
```
---
### Test Results

The file `histeq_Test_Results.pdf` contains the output generated for each test case, including:

* Original input image.
* Histogram-equalized image.
* Histogram before equalization.
* Histogram after equalization.
* Additional test cases for visual observations

---

## Compatibility Notes

This implementation follows the behavior of GNU Octave's `histeq` function.

### Important Notes

* RGB images are automatically converted to grayscale.
* Default number of bins is `64`.
* Output intensities are normalized to the range `[0,1]`.
* Constant images are returned unchanged.
* Empty images return an empty matrix.
---

### Recommended Usage

```scilab
Img = imread("image.jpg");

Equalized = histeq(Img);

imshow(Equalized);
```
Using a custom number of bins:
```scilab
Equalized = histeq(Img, 128);
```

---

## References

[1] MATLAB Image Processing Toolbox Documentation

[2] GNU Octave Image Package Documentation

