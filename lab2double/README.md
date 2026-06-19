# lab2double

## Description:
`lab2double` converts a CIE L* a* b* image or colormap to the `double` representation commonly used in image-processing applications.

The function serves as a wrapper around `lab2cls`, requesting conversion of the input L* a* b* data to the `double` class. The conversion produces a floating-point representation suitable for numerical computations, color-space transformations, and image-processing operations.

The function accepts exactly one input argument and returns the converted L* a* b* image or colormap in `double` format.

## Calling Sequence:
```
lab_double = lab2double(lab)
```
## Dependencies

The function depends on the following external file:

| File | Purpose |
|--------|---------|
| `lab2cls.sci` | Converts L* a* b* data to the specified output class. |

The dependency file must be loaded before executing `lab2double.sci`. The test script does this automatically:

```scilab
base = get_absolute_file_path("lab2double_test.sce");
exec(base + "../lab2cls/lab2cls.sci", -1);
exec(base + "lab2double.sci", -1);
```
---
## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `lab` | Matrix | **Input:** L* a* b* image or colormap . |
| `lab_double` | Double Matrix |**Output:** L* a* b* image or colormap converted to `double` representation. |


---



## Variable Reference:

| Variable         | Scope         | Type             | Description                                                                                                                                                |
| ---------------- | ------------- | ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `lab`             | Input/Output | Matrix  |Input L* a* b* image or colormap. After conversion, contains the `double` representation of the L* a* b* data.             |



---
## Helper Functions:

| Function   | Type     | Purpose                                                                               |
| ---------- | -------- | ------------------------------------------------------------------------------------- |
| `argn()`   | Built-in | Determines the number of input arguments supplied to the function.|
| `error()`   | Built-in | Generates an error message when invalid input is detected.|
|`lab2cls()`   | Helper Function | Performs conversion of L* a* b* data to the specified output class `(double)`.|
| `double()`  | Built-in (used internally by `lab2cls()`) | Converts numeric values to double representation. |

---

## Time & Space Complexity:

**Time Complexity:** `O(M × N × C)`

where:

* M = number of rows
* N = number of columns
* C = number of channels

The complexity is dominated by the conversion performed in `lab2cls()`.


**Space Complexity:** `O(M × N × C)` 

Additional memory is required to store the converted double-precision image.

---


## Mathematical Foundation:

The CIE L* a* b* color space consists of three components:

`L*`  → Lightness

`a*`  → Green–Red axis

`b*`  → Blue–Yellow axis

The conversion performed by

`LAB_double = lab2cls(LAB, "double")`

where:

* `LAB` is the input L* a* b* image.
* `LAB_double` is the converted floating-point representation.
 
The L* a* b* color space consists of three components:

L* ∈ `[0,100]`

a* ∈ `[-128,127]`

b* ∈ `[-128,127]`

The exact scaling and representation are determined by `lab2cls()`.

Double-precision storage provides approximately:

`15–16 decimal digits of precision`

making it suitable for scientific computation and color-space analysis.

### Input Requirements
The input should represent valid L* a* b* data and may be supplied as:

#### LAB Image

lab = rand(256,256,3);

where the third dimension corresponds to:

`(:, :, 1) → L*`

`(:, :, 2) → a*`

`(:, :, 3) → b*`

#### LAB Colormap
lab = rand(256,3);

where each row represents a color in L* a* b* space.

### Output Characteristics
The returned data:

* Has datatype `double`.
* Preserves the dimensions of the input.
* Supports floating-point computations.
* Provides higher numerical precision than integer representations.


---

### Difference Between `lab2uint8()`, `lab2uint16()` and `lab2double()`

| Function	| Output Class| 	Typical Range
| ---------- | -------- | ------------------------------------------------------------------------------------- |
lab2uint8()| 	uint8	| [0,255]
lab2uint16()| 	uint16	| [0,65535]
lab2double()| 	double	| Floating-point representation


`lab2double()` is typically preferred when performing color transformations, numerical analysis, or operations requiring high precision.

---
## Test Cases:

The following 11 test cases cover valid L* a* b* colormaps, boundary values, special inputs, and error conditions.  Run the test script:

```scilab
exec('lab2double_test.sce', -1);
```

### Test Case: 1 — Typical uint8 LAB Image

Verifies conversion of a typical uint8-encoded L* a* b* image to double precision.

```scilab
lab = uint8(cat(3, ... 
[0 128; 255 64], ... 
[128 148; 108 168], ... 
[128 98; 158 188])); 

out = lab2double(lab);
```

**Expected output:** `Returns a double-precision L* a* b* image.`

---
### Test Case: 2 — Minimum uint8 Values

Verifies conversion of the minimum possible uint8 L* a* b* values.

```scilab
lab = uint8(zeros(2,2,3)); 

out = lab2double(lab);
```

**Expected output:** `Returns double values corresponding to the minimum uint8 encoding.`

---
### Test Case: 3 — Maximum uint8 Values

Verifies conversion of the maximum possible uint8 L* a* b* values.

```scilab
lab = uint8(255 * ones(2,2,3)); 

out = lab2double(lab);
```

**Expected output:** `Returns double values corresponding to the maximum uint8 encoding.`

---
### Test Case: 4 — Typical uint16 LAB Image
Verifies conversion of a typical uint16-encoded L* a* b* image.

```scilab
lab = uint16(cat(3, ... 
[0 32640; 65280 16320], ... 
[32640 40000; 20000 50000], ... 
[32640 30000; 45000 60000])); 

out = lab2double(lab);
```

**Expected output:** `Returns a double-precision L* a* b* image.`

---
### Test Case: 5 — Minimum uint16 Values

Verifies conversion of the minimum possible uint16 L* a* b* values.

```scilab
lab = uint16(zeros(2,2,3)); 

out = lab2double(lab);
```

**Expected output:** `Returns double values corresponding to the minimum uint16 encoding.`


---
### Test Case: 6 — Maximum uint16 Values

Verifies conversion of the maximum possible uint16 L* a* b* values.

```scilab
lab = uint16(65280 * ones(2,2,3)); 

out = lab2double(lab);
```

**Expected output:** `Returns double values corresponding to the maximum uint16 encoding.`

---
### Test Case: 7 — Double Input (Pass-through)

Verifies behavior when the input is already a double-precision L* a* b* image.

```scilab
lab = cat(3, ... 
[50 75; 25 100], ... 
[0 20; -20 40], ... 
[0 -30; 30 60]); 

out = lab2double(lab);
```

**Expected output:** `Returns a double image with equivalent L* a* b* values.`

---
### Test Case: 8 — Single Pixel

Verifies conversion of a double-encoded L* a* b* pixel.
```scilab
lab = cat(3, 50, 0, 0);

out = lab2double(lab);
```

**Expected output:** `Returns a single double-precision L* a* b* pixel.`

---
### Test Case: 9 — M×3 Colormap

Verifies conversion of an L* a* b* colormap represented as an M×3 matrix.

```scilab
lab = [...
    0    -128  -128;
    50      0     0;
    100    127   127]; 

out = lab2double(lab);
```

**Expected output:** `Returns a double-precision L* a* b* colormap.`

---
### Test Case: 10 — Invalid 2-D Input

Verifies error handling when the input is a 2-D matrix that is not a valid Lab* colormap.

```scilab
lab = uint8([1 2; 3 4]); 

out = lab2double(lab);
```

**Expected output:** `Error generated by lab2cls() indicating invalid L* a* b* data.`

---
### Test Case: 11 — int16 Input
Verifies error handling for unsupported signed integer input.

```scilab
lab = int16(cat(3, ... 
[0 50], ... 
[0 0], ... 
[0 0])); 

out = lab2double(lab);
```

**Expected output:** `Error generated by lab2cls() indicating unsupported input class.`

---
### Test Results

The file `lab2double_Test_Results.pdf` contains the results obtained from executing all test cases, including:

* Input L* a* b*  matrices.
* Datatypes before and after conversion.
* Conversion of uint8-encoded L* a* b* images to double precision.
* Conversion of uint16-encoded L* a* b* images to double precision.
* Error handling outputs for invalid inputs.


---

## Compatibility Notes

This implementation follows the behavior of GNU Octave's `lab2double` function.

### Important Differences
* The conversion itself is performed by `lab2cls()`.
* Any limitations of `lab2cls()` are inherited by `lab2double`.
* Input validation and scaling behavior are handled by `lab2cls()`.

---

### Recommended Usage
For converting L* a* b* images to `double` format:
```
lab = rgb2lab(rgbImage); 
lab_double = lab2double(lab);
```
Use `lab2double()` when performing numerical computations or color-space transformations that require floating-point precision.

---

## References

[1] MATLAB Image Processing Toolbox Documentation

[2] GNU Octave Image Package Documentation

[3] CIE L* a* b* Color Space Specification
