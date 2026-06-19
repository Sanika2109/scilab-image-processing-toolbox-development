# psnr

## Description:
`psnr` computes the Peak Signal-to-Noise Ratio (PSNR) between two images or matrices.

PSNR is a widely used image quality metric that measures the similarity between an original image and a reconstructed, compressed, or processed image. It is expressed in decibels (dB) and is derived from the Mean Squared Error (MSE) between corresponding pixels.

Higher PSNR values indicate greater similarity between the two images, while lower values indicate greater distortion.

## Calling Sequence:
```
p = psnr(A, B) 
p = psnr(A, B, peak)
```
## Dependencies

The function relies on the following files:

| File | Purpose |
|--------|---------|
| `immse.sci` | Computes the Mean Squared Error (MSE) between two images or matrices. |
| `getrangefromclass.sci` | Determines the valid intensity range associated with an image datatype. |

These dependency files must be loaded before executing `psnr.sci`. The test script does this automatically:

```scilab
base = get_absolute_file_path("psnr_test.sce");

exec(base + "../immse/immse.sci", -1);
exec(base + "../getrangefromclass/getrangefromclass.sci", -1);
exec(base + "psnr.sci", -1);
```
---
## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `A` | Matrix | **Input:** Reference image or matrix. |
| `B` | Matrix | **Input:** Test image or matrix. Must have the same dimensions as `A`. |
| `peak` |  Double | Maximum possible signal value. Optional. Default value is `1`. |
| `p` | Double | **Output:** Computed Peak Signal-to-Noise Ratio (PSNR) in decibels (dB). |

---
## Variable Reference

| Variable         | Scope         | Type             | Description                                                                                                                                                |
| ---------------- | ------------- | ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `A`             | Input / Local | Matrix  |Reference image converted to double precision.                |
| `B` | Input / Local        | Matrix           | Test image converted to double precision.                                                                                        |
| `peak`           | Input / Local         | Double       | Maximum signal value used in PSNR computation.                                  |
| `diff`            | Local         | Matrix       | Difference between corresponding elements of `A` and `B`.    |
| `mse`            | Local         | Double       | Mean Squared Error between the two images.   |
| `p`            | Output         | Double       | Computed PSNR value in decibels.   |---

---
## Helper Functions

| Function   | Type     | Purpose                                                                               |
| ---------- | -------- | ------------------------------------------------------------------------------------- |
| `size()`  | Built-in | Determines image dimensions. |
| `or()`  | Built-in | Verifies dimension equality. |
| `error()`  | Built-in | Generates an error message and terminates execution when invalid input is detected.   |
| `double()` | Built-in | Converts input arrays to double precision before arithmetic operations.      |
| `argn()`   | Built-in | Determines the number of input arguments supplied to the function.|
| `mean()`  | Built-in | Computes the average value of the squared differences.|
| `log10()`   | Built-in | Computes the base-10 logarithm required for PSNR.|

                  
---
## Time & Space Complexity:

Time Complexity: O(M × N), where `M × N` is the image size.

Space Complexity: O(M × N)

Additional memory is required for storing the difference matrix.

---


## Mathematical Foundation

### Mean Squared Error
The Mean Squared Error measures the average squared difference between corresponding elements of two matrices.

**The Mean Squared Error between two images is:**

`MSE = (1 / N) × Σ(A(i) - B(i))²`

where:

|Symbol	| Meaning |
| :--- | :--- | 
`Aᵢ`|	Element from first image
`Bᵢ`|	Corresponding element from second image
`N`	|Total number of elements
`MSE`|	Mean Squared Error

### Peak Signal-to-Noise Ratio
PSNR (Peak Signal-to-Noise Ratio) is a metric that measures the quality of a reconstructed or processed image by comparing it to the original image, expressed in decibels (dB).

**The PSNR is defined as:**

`PSNR = 10 * log10((peak²) / MSE)`

where:

* `peak` = maximum possible pixel value
* `MSE` = Mean Squared Error

---
Special cases:
---

When

`MSE = 0`

the images are identical.

Therefore:

`PSNR = ∞`

---

### Output Range

|Condition	| PSNR |
| :--- | :--- | 
Identical images	|∞
Very similar images|	High positive value
Moderately different images|	Medium value
Very different images|	Low value


Typical values:

|PSNR (dB)|	Quality|
| :--- | :--- |
|> 40	|Excellent
30 – 40	|Good
20 – 30	|Acceptable
< 20	|Poor

---
### Difference between `immse()` and `psnr()`

|Function	|Purpose|
| :--- | :--- |
`immse()`	|Computes Mean Squared Error directly.
`psnr()`	|Converts MSE into a logarithmic quality metric measured in dB.

Lower MSE corresponds to higher PSNR.

**Recommendation:** Use `immse()` for raw error measurement and `psnr()` for image quality evaluation.

---

## Test Cases:

The following 12 test cases cover valid inputs, boundary conditions, numerical precision, custom peak values, and special cases such as identical images and random matrices. Run the test script:

```scilab
exec('psnr_test.sce', -1);
```

### Test Case: 1 — Identical Images

Verifies that the PSNR is infinite when both images are identical.

```scilab
A = [10 20; 30 40]; 
B = [10 20; 30 40]; 
psnr(A,B)
```

**Expected output:** `%inf`

**Calculation:**
```
A and B are identical.

MSE = 0

Since MSE = 0,

PSNR = ∞
```

Since the images are identical, the MSE is zero and the PSNR is infinite.

---
### Test Case: 2 — All Zeros

Verifies behavior when both images contain only zero values.

```scilab
A = zeros(3,3); 
B = zeros(3,3); 
psnr(A,B)
```

**Expected output:** `%inf`

**Calculation:**
```
A and B contain only zeros.

MSE = 0

Since MSE = 0,

PSNR = ∞
```

The images are identical, resulting in infinite psnr.

---
### Test Case: 3 — Constant Matrices

Verifies PSNR computation for matrices with constant but different values.

```scilab
A = ones(3,3)*50; 
B = ones(3,3)*100; 
psnr(A,B)
```

**Expected output:** `-33.979`

**Calculation:**
```
Difference = 50 - 100 = -50

Squared Difference = 2500

MSE = 2500

PSNR = 10 × log10(1 / 2500)
     = -33.98 dB
```

Since the default peak value is `1`, a large MSE produces a negative PSNR value.

---
### Test Case: 4 — Negative Values

Verifies correct handling of negative-valued inputs.

```scilab
A = [-1 -2; 3 4]; 
B = [ 1 2; -3 -4]; 
psnr(A,B)
```

**Expected output:** `-14.771`

**Calculation:**
```
Differences:
-2  -4
 6   8

Squared Differences:
4   16
36  64

MSE = (4 + 16 + 36 + 64) / 4
    = 30

PSNR = 10 × log10(1 / 30)
     = -14.77 dB
```

The function should correctly compute PSNR using the squared differences.

---
### Test Case: 5 — Floating Values

Verifies computation for floating-point matrices.

```scilab
A = [0.1 0.2; 0.3 0.4]; 
B = [0.1 0.25; 0.35 0.45]; 
psnr(A,B)
```

**Expected output:** `27.27`

**Calculation:**
```
Differences:
0      -0.05
-0.05  -0.05

Squared Differences:
0       0.0025
0.0025  0.0025

MSE = (0 + 0.0025 + 0.0025 + 0.0025) / 4
    = 0.001875

PSNR = 10 × log10(1 / 0.001875)
     = 27.27 dB
```

A small MSE results in a relatively high PSNR value.

---
### Test Case: 6 — Single Element

Verifies operation on scalar inputs.

```scilab
psnr(5,10)
```

**Expected output:** `-13.979`

**Calculation:**
```
Difference = 5 - 10 = -5

Squared Difference = 25

MSE = 25

PSNR = 10 × log10(1 / 25)
     = -13.98 dB
```

The function should correctly compute PSNR for single-element matrices.

---
### Test Case: 7 — Random Matrix

Verifies operation on randomly generated matrices.

```scilab
A = rand(3,3); 
B = rand(3,3); 
psnr(A,B)
```

**Expected output:** `Positive finite value depending on the generated matrices.`

**Calculation:**
```
MSE depends on the randomly generated matrices.

PSNR is computed using the calculated MSE value.
```

---
### Test Case: 8 — Custom Peak Value

Verifies use of a user-specified peak value.

```scilab
A = [10 20; 30 40]; 
B = [12 18; 33 39]; 
psnr(A,B,128)
```

**Expected output:** `35.612`

**Calculation:**
```
Differences:
-2   2
-3   1

Squared Differences:
4   4
9   1

MSE = (4 + 4 + 9 + 1) / 4
    = 4.5

PSNR = 10 × log10(128² / 4.5)
     = 35.61 dB
```

Using a larger peak value increases the PSNR.

---
### Test Case: 9 — High Dynamic Range Values

Verifies behavior for large numerical values.

```scilab
A = [1000 2000; 3000 4000]; 
B = [1100 1900; 3100 3900]; 
psnr(A,B)
```

**Expected output:** `-40`

**Calculation:**
```
Differences:
-100   100
-100   100

Squared Differences:
10000  10000
10000  10000

MSE = 10000

PSNR = 10 × log10(1 / 10000)
     = -40 dB
```

Large differences produce a very low PSNR.

---
### Test Case: 10 — Binary Image

Verifies computation on binary-valued matrices.

```scilab
A = [0 1; 1 0]; 
B = [1 0; 0 1]; 
psnr(A,B)
```

**Expected output:** `0`

**Calculation:**
```
Differences:
-1   1
 1  -1

Squared Differences:
1  1
1  1

MSE = 1

PSNR = 10 × log10(1 / 1)
     = 0 dB
```

For binary images with peak value `1`, MSE equals `1`, resulting in a PSNR of `0` dB.

---
### Test Case: 11 — Mixed Sign Values

Verifies operation when positive and negative values coexist.

```scilab
A = [-10 0; 10 20]; 
B = [10 0; -10 -20]; 
psnr(A,B)
```

**Expected output:** `-27.782`

**Calculation:**
```
Differences:
-20   0
 20  40

Squared Differences:
400     0
400  1600

MSE = (400 + 0 + 400 + 1600) / 4
    = 600

PSNR = 10 × log10(1 / 600)
     = -27.78 dB
```

The function should correctly handle sign changes through squared differences.

---
### Test Case: 12 — Large Random Matrix

Verifies performance on larger matrices.

```scilab
A = rand(50,50)*255; 
B = rand(50,50)*255; 
psnr(A,B)
```

**Expected output:** `Finite PSNR value depending on the generated matrices.`

**Calculation:**
```
MSE depends on the randomly generated matrices.

PSNR is computed using the calculated MSE value.
```

This test demonstrates correct operation on large datasets.

---
### Test Results

The file `psnr_Test_Results.pdf` contains the results obtained from executing all test cases, including:

* Input matrices used for each test case.
* Computed PSNR values (in decibels).
* Error-free execution results for all valid inputs.
* A summary table comparing the expected and obtained outputs.

---

## Compatibility Notes

This implementation follows the behavior of GNU Octave's `psnr` function.

### Important Notes

* Input matrices must have identical dimensions.
* Images are internally converted to double precision.
* If `peak` is omitted, a default value of `1` is used.
* Identical images return infinite PSNR `(%inf)`.
* Negative PSNR values may occur when the Mean Squared Error exceeds the square of the specified peak value. This behavior is mathematically valid and matches GNU Octave.
---

### Recommended Usage

For normalized images:
```scilab
p = psnr(A, B);
```
For 8-bit grayscale images:
```scilab
p = psnr(A, B, 255);
```
For binary images:
```scilab
p = psnr(A, B, 1);
```
---

## References

[1] MATLAB Image Processing Toolbox Documentation

[2] GNU Octave Image Package Documentation

