# bwarea 

## Description:
`bwarea` computes the area of objects in a binary image using pixel neighborhood weighting. 

It calculates the area occupied by foreground regions using a weighted neighborhood method based on 2×2 pixel patterns. Unlike simple pixel counting, this approach provides a more accurate estimate of object area, especially for diagonal boundaries and irregular shapes.

## Calling Sequence:
```
area = bwarea(BW)
```

---
## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `BW` | Matrix | **Input:** `2-D` binary image. |
| `area` | Double | **Output:** Estimated area of all foreground objects in the binary image and may be non-integer. |

---
## Variable Reference

| Variable         | Scope         | Type             | Description                                                                                                                                                |
| ---------------- | ------------- | ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `bw`             | Input / Local | Matrix (Logical) | Input binary image. After preprocessing, all non-zero pixels are converted to foreground (`1`) and zero-valued pixels to background (`0`).                 |
| `binaryobj_area` | Output        | Double           | Final estimated area of all foreground objects in the binary image.                                                                                        |
| `four`           | Local         | 2×2 Matrix       | Kernel of ones used to count the number of foreground pixels in each 2×2 neighborhood.                                                                     |
| `two`            | Local         | 2×2 Matrix       | Diagonal kernel used to distinguish adjacent-pixel configurations from diagonal-pixel configurations.                                                      |
| `fours`          | Local         | Matrix           | Result of convolution between the binary image and the `four` kernel. Each element represents the number of foreground pixels in a local 2×2 neighborhood. |
| `twos`           | Local         | Matrix           | Result of convolution between the binary image and the `two` kernel. Used for identifying diagonal configurations.                                         |
| `Q1`             | Local         | Double           | Number of 2×2 neighborhoods containing exactly one foreground pixel.                                                                                       |
| `QA`             | Local         | Double           | Number of 2×2 neighborhoods containing exactly two adjacent foreground pixels.                                                                             |
| `QD`             | Local         | Double           | Number of 2×2 neighborhoods containing exactly two diagonally positioned foreground pixels.                                                                |
| `Q3`             | Local         | Double           | Number of 2×2 neighborhoods containing exactly three foreground pixels.                                                                                    |
| `Q4`             | Local         | Double           | Number of 2×2 neighborhoods completely filled with foreground pixels.                                                                                      |


---
## Helper Functions

| Function   | Type     | Purpose                                                                               |
| ---------- | -------- | ------------------------------------------------------------------------------------- |
| `argn()`   | Built-in | Determines the number of input arguments supplied to the function.                    |
| `error()`  | Built-in | Generates an error message and terminates execution when invalid input is detected.   |
| `ndims()`  | Built-in | Returns the number of dimensions of the input image. Used to ensure the image is 2-D. |
| `ones()`   | Built-in | Creates the 2×2 kernel of ones used for neighborhood analysis.                        |
| `double()` | Built-in | Converts the logical image to double precision before convolution.                    |
| `conv2()`  | Built-in | Performs two-dimensional convolution for pattern detection in 2×2 neighborhoods.      |
| `sum()`    | Built-in | Counts occurrences of specific neighborhood configurations.                           |

---
## Time & Space Complexity:

Time Complexity: O(M × N), where M and N are the image dimensions.

Space Complexity: O(1)

---


## Mathematical Foundation

The `bwarea` function estimates the area of foreground objects by analyzing all overlapping 2×2 neighborhoods in a binary image.

### Binary Image Representation

The input image is converted to a binary image:

```text
B(x,y) ∈ {0,1}
```

where:

* `0` = background pixel
* `1` = foreground pixel

---

### Convolution Kernels

Foreground-pixel counting kernel:

```text
K₁ =
[1 1
 1 1]
```

Diagonal-pattern detection kernel:

```text
K₂ =
[1 0
 0 1]
```

The convolutions

```text
F = B * K₁
D = B * K₂
```

are used to identify local 2×2 pixel configurations.

---

### Neighborhood Counts and Ranges

| Variable | Description                                                       | Range    |
| -------- | ----------------------------------------------------------------- | -------- |
| `Q₁`     | Number of neighborhoods containing exactly one foreground pixel   | `Q₁ ≥ 0` |
| `Qₐ`     | Number of neighborhoods containing two adjacent foreground pixels | `Qₐ ≥ 0` |
| `Qᵈ`     | Number of neighborhoods containing two diagonal foreground pixels | `Qᵈ ≥ 0` |
| `Q₃`     | Number of neighborhoods containing three foreground pixels        | `Q₃ ≥ 0` |
| `Q₄`     | Number of neighborhoods containing four foreground pixels         | `Q₄ ≥ 0` |

For an image of size `M × N`, the maximum possible value of any count is:

```text
(M + 1)(N + 1)
```

because the full convolution produces an output of size:

```text
(M + 1) × (N + 1)
```

---

### Area Estimation Formula

The estimated area is computed as:

```text
A = 0.25Q₁ + 0.50Qₐ + 0.75Qᵈ + 0.875Q₃ + Q₄
```

where:

* `A` = estimated object area
* `A ≥ 0`

---

### Output Range

For an image containing no foreground pixels:

```text
A = 0
```

For a completely foreground image of size `M × N`:

```text
A = M × N
```

Therefore:

```text
0 ≤ A ≤ M × N
```
---
## Difference Between `sum()` and `bwarea()`

Both functions operate on binary images but compute different measurements.

| Function   | Purpose                                                                                      |
| ---------- | -------------------------------------------------------------------------------------------- |
| `sum()`    | Counts the number of foreground pixels.                                                      |
| `bwarea()` | Estimates the geometric area of foreground objects using weighted 2×2 neighborhood analysis. |

Unlike `sum()`, `bwarea()` accounts for object boundaries and diagonal pixel configurations, resulting in a more accurate approximation of the true object area. Consequently, `bwarea()` may return non-integer values.


**Recommendation:** Use `sum()` for pixel counting and `bwarea()` for object area estimation.

---
## Test Cases:

The following 11 test cases cover all the reuired valid, invalid and boundary cases. Run the test script:

```scilab 
exec('bwarea.sce', -1)`.
```

### Test Case: 1 — Empty Image

Verifies that the function returns zero area when the image contains no foreground pixels.

```scilab
BW = zeros(5,5); 
area = bwarea(BW)
```

**Expected output:** `0`

Since all pixels are background, there are no foreground objects and the estimated area is zero.

---
### Test Case: 2 — Single Pixel Object

Verifies that the function correctly estimates the area of a single isolated foreground pixel.

```scilab
BW = zeros(5,5); 
BW(3,3) = 1; 
area = bwarea(BW)
```

**Expected output:** `1`

A single foreground pixel contributes an area of one pixel.

---
### Test Case: 3 — Completely White Image

Verifies that the area equals the total image area when all pixels belong to the foreground.

```scilab
BW = ones(5,5); 
area = bwarea(BW)
```

**Expected output:** `25`

All 25 pixels are foreground pixels, so the estimated area equals the image size.

---
### Test Case: 4 — Adjacent Pixels

Verifies that two horizontally adjacent foreground pixels are treated as a connected object.

```scilab
BW = zeros(5,5); 
BW(3,3) = 1; 
BW(3,4) = 1;
area = bwarea(BW)
```

**Expected output:** `2`

The two neighboring pixels form a connected region whose estimated area is close to two pixels.

---
### Test Case: 5 — Diagonal Pixels

Verifies the handling of diagonally connected foreground pixels.

```scilab
BW = zeros(5,5); 
BW(2,2) = 1; 
BW(3,3) = 1;
area = bwarea(BW)
```

**Expected output:** `2.25`

The function uses weighted neighborhood analysis to account for diagonal connectivity when estimating area.

---
### Test Case: 6 — Thin Horizontal Line

Verifies area estimation for a one-pixel-thick horizontal object.

```scilab
BW = zeros(7,7); 
BW(4,2:6) = 1;
area = bwarea(BW)
```

**Expected output:** `5`

The object consists of five connected foreground pixels arranged horizontally.

---
### Test Case: 7 — Thin Vertical Line

Verifies area estimation for a one-pixel-thick vertical object.

```scilab
BW = zeros(7,7); 
BW(2:6,4) = 1;
area = bwarea(BW)
```

**Expected output:** `5`

The object consists of five connected foreground pixels arranged vertically.

---
### Test Case: 8 — Multiple Disconnected Objects

Verifies that the function correctly accumulates the area of multiple separated foreground regions.

```scilab
BW = zeros(8,8); 
BW(2,2) = 1; 
BW(2,3) = 1; 
BW(6,6) = 1; 
BW(7,6) = 1;
area = bwarea(BW)
```

**Expected output:** `4`

The image contains two disconnected objects, each consisting of two foreground pixels.

---
### Test Case: 9 — Grayscale Image

Verifies the behavior when a grayscale image is supplied directly to the function.

```scilab
Img = imread("bright_img.jpg"); 
BW = rgb2gray(Img);
area = bwarea(BW)
```

**Expected output:** `Depends on image content`

If the implementation converts all non-zero pixels to foreground pixels, the computed area corresponds to the number of non-zero regions in the grayscale image. For meaningful results, grayscale images should be thresholded before area estimation.

---
### Test Case: 10 — Sparse Noise Pixels

Verifies area estimation for isolated foreground pixels scattered throughout the image.

```scilab
BW = zeros(10,10); 
BW(2,2) = 1; 
BW(4,7) = 1; 
BW(8,3) = 1; 
BW(9,9) = 1;
area = bwarea(BW)
```

**Expected output:** `4`

Each isolated foreground pixel contributes independently to the total estimated area.

---
### Test Case: 11 — Complex Shape

Verifies area estimation for a larger connected object with an irregular geometry.

```scilab
BW = [0 0 1 1 0 0; 
      0 1 1 1 1 0; 
      1 1 1 1 1 1; 
      0 1 1 1 1 0; 
      0 0 1 1 0 0];
area = bwarea(BW)
```

**Expected output:** `19`

The weighted neighborhood method provides a more accurate estimate of the area than simple foreground-pixel counting, especially along object boundaries.

---

### Test Results

The file `bwarea_Test_Results.pdf` contains the output images generated for each test case along with the corresponding values of:

* `Area` (computed using `bwarea()`)
* `Summed Area` (computed using `sum()`)

---

## Compatibility Notes

This function is a Scilab translation of GNU Octave's `bwarea` function and uses the same weighted 2×2 neighborhood method for area estimation.

### Important Differences from GNU Octave

* The input image is converted to binary using:

  ```scilab
  bw = bw <> 0;
  ```

  Therefore, all non-zero pixel values are treated as foreground pixels.

* No automatic thresholding is performed. Grayscale images should be thresholded before calling `bwarea`.

  ```scilab
  BW = Gray > threshold;
  area = bwarea(BW);
  ```

* RGB images are not supported directly. Convert the image to grayscale and then to binary before computing the area.

---

### Recommended Usage

For results comparable to GNU Octave:
```scilab
Gray = rgb2gray(Img);
BW = Gray > threshold;
area = bwarea(BW);
```
where `threshold` is chosen appropriately for the application.

---

## References

[1] MATLAB Image Processing Toolbox Documentation

[2] GNU Octave Image Package Documentation

