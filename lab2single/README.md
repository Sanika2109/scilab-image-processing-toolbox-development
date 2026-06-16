# lab2single

## Description:

`lab2single` converts a CIE L* a* b* image or colormap to a floating-point representation.

The function serves as a wrapper around 
`lab2cls`, requesting conversion of the input L* a* b* data to the `single` output class. Since Scilab does not provide a native `single` floating-point datatype, the converted data is returned as a Scilab `constant` (double-precision matrix).

The function supports L* a* b* data stored as:

* M×3 colormaps
* M×N×3 images
* M×N×3×K image stacks

Input data may be encoded as `uint8`, `uint16` or floating-point (`constant`) values. Integer-encoded L* a* b* values are converted to their floating-point representation according to the scaling rules implemented in `lab2cls`.

The function accepts exactly one input argument and returns the converted L* a* b* image or colormap.
## Calling Sequence:
```
lab_single = lab2single(lab)
```

---
## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `lab` | Matrix | **Input:** L* a* b* image, colormap or image stack. |
| `lab_double` | Double Matrix (`constant`)|**Output:** Floating-point representation of the L* a* b* data. |


---



## Variable Reference:

| Variable         | Scope         | Type             | Description                                                                                                                                                |
| ---------------- | ------------- | ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `lab`             | Input/Output | Matrix  |Input L* a* b* image, colormap or image stack. After conversion, contains the floating-point representation of the L* a* b* data.            |



---
## Helper Functions:

| Function   | Type     | Purpose                                                                               |
| ---------- | -------- | ------------------------------------------------------------------------------------- |
| `argn()`   | Built-in | Determines the number of input arguments supplied to the function.|
| `error()`   | Built-in | Generates an error message when invalid input is detected.|
|`lab2cls()`   | Helper Function | Performs conversion of L* a* b* data to the requested output class (`single`).|
| `double()`  | Built-in (used internally by `lab2cls()`) | Converts numeric values to floating-point representation.|

---
## Algorithm:

```text
Start
  |
  v
Receive Input: LAB
  |
  v
Check Number of Input Arguments
  |
  v
Is there exactly one input argument?
  |
  +-- No --> Generate Error Message
  |             |
  |             v
  |            End
  |
  +-- Yes --> Call lab2cls(LAB, "single")
                 |
                 v
      Validate LAB Dimensions
                 |
                 v
Convert uint8 / uint16 Values to Floating-Point LAB Values
                 |
                 v
        Preserve Original Dimensions
                 |
                 v
        Return Converted LAB 
                 | 
                 v 
                End
```
                    
---
## Time & Space Complexity:

**Time Complexity:** `O(M × N × C x K)`

where:

* M = number of rows
* N = number of columns
* C = number of channels
* K = number of images in an image stack

The complexity is dominated by the conversion performed in `lab2cls()`.


**Space Complexity:** `O(M × N × C x K)` 

Additional memory is required to store the converted floating-point image.

---


## Mathematical Foundation:

The CIE L* a* b* color space consists of three components:

`L*`  → Lightness

`a*`  → Green–Red axis

`b*`  → Blue–Yellow axis

`lab2single()` performs the conversion by calling:

`lab = lab2cls(lab, "single");`

The actual conversion rules depend on the datatype of the input.

### uint8 Input

For uint8-encoded L* a* b* data, `lab2cls()` converts the values using:

lab(:, 1, :) = lab(:, 1, :) * (100 / 255);

lab(:, 2:3, :) = lab(:, 2:3, :) - 128;

The first channel is scaled to the L* range, while the second and third channels are shifted to obtain the corresponding a* and b* values.

### uint16 Input

For uint16-encoded L* a* b* data, `lab2cls()` applies:

lab(:, 1, :) = lab(:, 1, :) * (100 / 65280);

lab(:, 2:3, :) = lab(:, 2:3, :) * (255 / 65280);

lab(:, 2:3, :) = lab(:, 2:3, :) - 128;

This converts the encoded integer representation into floating-point L*a*b* values.

### Floating-Point Input

If the input is already a Scilab `constant` matrix, no scaling is performed.

lab = double(lab);

The values are preserved and returned unchanged.

### Input Requirements

The input must represent valid L* a* b* data and must have one of the following dimensions:

#### LAB Colormap
lab = rand(256,3);

where each row represents a color in L* a* b* space.

#### LAB Image
lab = rand(256,256,3);

#### LAB Image Stack
lab = rand(256,256,3,10);

where the fourth dimension represents multiple images.

Inputs that are not of size:

* M×3

* M×N×3

* M×N×3×K

generate an error.

### Supported Input Classes

The implementation supports the following input classes:

* uint8
* uint16
* double (Scilab `constant` )

Any other datatype generates an error.

### Output Characteristics
The returned data:

* Has Scilab datatype `constant`.
* Contains floating-point L* a* b* values.
* Preserves the dimensions of the input.
* Preserves image-stack structure.
* Supports numerical computations and color-space operations.

Since Scilab does not provide a native `single` datatype, the output of `lab2single()` is stored as a Scilab `constant` matrix.

---

### Difference Between `lab2uint8()`, `lab2uint16()` and `lab2double()` and `lab2single()`

| Function	| Output Class| 	Typical Range
| ---------- | -------- | ------------------------------------------------------------------------------------- |
lab2uint8()| 	uint8	| [0,255]
lab2uint16()| 	uint16	| [0,65535]
lab2double()| 	constant	| Floating-point representation
lab2single()| 	constant	| Floating-point representation

In this Scilab implementation, `lab2single()` and `lab2double()` produce identical numerical results because Scilab does not support a native `single` datatype.

---
## Test Cases:

The following 9 test cases cover valid L* a* b* images, colormaps, boundary values, special inputs, and error conditions. Run them after loading the function first with `exec ('lab2cls.sci', -1)` and then `exec('lab2single_test.sce', -1)`.

### Test Case: 1 — uint8 LAB Colormap

Verifies conversion of a uint8-encoded L* a* b* colormap to floating-point representation.

```scilab
lab = uint8([255 128 128;
             0   128 128]);

out = lab2single(lab);
```

**Expected output:** `Returns a floating-point L* a* b* colormap of type constant.`

---
### Test Case: 2 — uint16 LAB Colormap

Verifies conversion of a uint16-encoded L* a* b* colormap.

```scilab
lab = uint16([65280 32768 32768;
                  0 32768 32768]);

out = lab2single(lab);
```

**Expected output:** `Returns a floating-point L* a* b* colormap obtained from uint16 encoding.`

---
### Test Case: 3 — Double Input

Verifies behavior when the input is already stored as floating-point values.

```scilab
lab = [50 10 -10;
       75 20  30];

out = lab2single(lab);
```

**Expected output:** `Returns equivalent floating-point values without modifying the LAB representation.`

---
### Test Case: 4 — M×N×3 Image
Verifies conversion of a standard three-channel L* a* b* image.

```scilab
lab = cat(3,...
          [0 50;100 25],...
          [0 10;20 30],...
          [0 -10;40 -20]);

out = lab2single(lab);
```

**Expected output:** `Returns a floating-point LAB image with the same dimensions as the input.`

---
### Test Case: 5 — uint8 Image

Verifies conversion of a uint8-encoded L* a* b* image.

```scilab
lab = cat(3,...
          uint8([0 255;128 64]),...
          uint8([128 255;0 128]),...
          uint8([128 0;255 128]));

out = lab2single(lab);
```

**Expected output:** `Returns a floating-point LAB image obtained from uint8 encoding.`


---
### Test Case: 6 — 4-D LAB Image

Verifies support for M×N×3×K image stacks.
```scilab
lab = rand(2,2,3,2);

out = lab2single(lab);
```

**Expected output:** `Returns a floating-point LAB image stack with dimensions preserved.`

---
### Test Case: 7 — Invalid Dimensions

Verifies error handling when the input dimensions do not correspond to a valid LAB colormap or image.

```scilab
lab = rand(3,3);

lab2single(lab);
```

**Expected output:** `Error indicating that LAB must be M×3, M×N×3, or M×N×3×K.`

---
### Test Case: 8 — Invalid Class

Verifies error handling for unsupported input datatypes.
```scilab
lab2single("hello");
```

**Expected output:** `Error indicating an unsupported LAB class.`

---
### Test Case: 9 — Output Type Verification

Verifies the datatype returned by the function.

```scilab
lab = uint8([255 128 128]);

out = lab2single(lab);

typeof(out)
```

**Expected output:** `constant` - Since Scilab does not provide a native `single` datatype, the output is returned as a floating-point matrix of type `constant`.

---

### Test Results

The file `lab2single_Test_Results.pdf` contains the results obtained from executing all test cases, including:

* Conversion of uint8-encoded L* a* b* colormaps and images.
* Conversion of uint16-encoded L* a* b* colormaps.
* Processing of floating-point L* a* b* data.
* Validation of M×N×3 and M×N×3×K inputs.
* Datatype verification and error handling results.


---

## Compatibility Notes

This implementation follows the API and conversion behavior of GNU Octave's `lab2single` function.

### Important Differences
* Scilab does not provide a native `single` datatype.
* The output is returned as a Scilab `constant` matrix.
* Conversion, validation, and scaling are performed by `lab2cls()`.
* Only `uint8`, `uint16`, and floating-point (`constant`) inputs are supported.
* Unsupported datatypes generate an error.

---

### Recommended Usage
For converting L* a* b* images to floating-point representation:
```
lab = rgb2lab(rgbImage); 
lab_single = lab2single(lab);
```
Use `lab2single()` when porting MATLAB/Octave image-processing code or when a floating-point L* a* b* representation is required.

---

## References

[1] MATLAB Image Processing Toolbox Documentation

[2] GNU Octave Image Package Documentation

[3] CIE L* a* b* Color Space Specification
