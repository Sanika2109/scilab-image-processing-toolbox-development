# lab2uint16

## Description:
`lab2uint16` converts a CIE L* a* b* image or colormap to the `uint16` representation commonly used in image-processing applications.

The function serves as a wrapper around `lab2cls`, requesting conversion of the input L* a* b* data to the `uint16` class. The conversion maps the L* a* b* components into the valid range of unsigned 16-bit integers `(0–65535)`.

The function accepts exactly one input argument and returns the converted L* a* b* image or colormap in `uint16` format.
## Calling Sequence:
```
lab_uint16 = lab2uint16(lab)
```

---
## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `lab` | Matrix | **Input:** L* a* b* image or colormap . |
| `lab_uint16` | uint16 Matrix |**Output:** L* a* b* image or colormap converted to `uint16` representation. |


---



## Variable Reference:

| Variable         | Scope         | Type             | Description                                                                                                                                                |
| ---------------- | ------------- | ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `lab`             | Input/Output | Matrix  |Input L* a* b* image or colormap. After conversion, contains the `uint16` representation of the L* a* b* data.             |



---
## Helper Functions:

| Function   | Type     | Purpose                                                                               |
| ---------- | -------- | ------------------------------------------------------------------------------------- |
| `argn()`   | Built-in | Determines the number of input arguments supplied to the function.|
| `error()`   | Built-in | Generates an error message when invalid input is detected.|
|`lab2cls()`   | Helper Function | Performs conversion of L* a* b* data to a specified output class `(uint16)`.|
| `uint16()`  | Built-in (used internally by `lab2cls()`) | Converts numeric values to unsigned 16-bit integer representation. |

---
## Algorithm:

```text
Start
  |
  v
Receive Input: lab
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
  +-- Yes --> Call lab2cls(LAB, "uint16")
                 |
                 v
          Convert LAB Data to uint16 Class
                 |
                 v
          Return Converted LAB Image
                 |
                 v
                End
```
                  
---
## Time & Space Complexity:

**Time Complexity:** `O(M × N × C)`

where:

* M = number of rows
* N = number of columns
* C = number of channels

The complexity is dominated by the conversion performed in `lab2cls()`.


**Space Complexity:** `O(M × N × C)` 

Additional memory is required to store the converted `uint16` output.

---


## Mathematical Foundation:

The CIE L* a* b* color space consists of three components:

`L*`  → Lightness

`a*`  → Green–Red axis

`b*`  → Blue–Yellow axis

The conversion performed by

`LAB_uint16 = lab2cls(LAB, "uint16")`

where:

* `LAB` is the input L*a*b* image.
* `LAB_uint16` is the converted `uint16` representation.
 
Conceptually, the L* a* b* components:

L* ∈ `[0,100]`

a* ∈ `[-128,127]`

b* ∈ `[-128,127]`

are mapped into:

uint16 ∈ `[0,65535]`

using scaling and offset operations implemented within `lab2cls()`.

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

* Has datatype `uint16`.
* Preserves the dimensions of the input.
* Stores L* a* b* values using 16-bit precision.
* Provides greater precision than `lab2uint8`.


---
## Test Cases:

The following 10 test cases cover valid L* a* b* colormaps, boundary values, special inputs, and error conditions. Run them after loading the function first with `exec ('lab2cls.sci', -1)` and then `exec('lab2uint16_test.sce', -1)`.

### Test Case: 1 — Typical Lab* Image

Verifies conversion of a typical L* a* b* image containing valid L*, a* and b* values.

```scilab
lab = cat(3, ... 
[50 75; 25 100], ... 
[0 20; -20 40], ... 
[0 -30; 30 60]); 

out = lab2uint16(lab);
```

**Expected output:** `Returns a uint16 representation of the input L* a* b* image.`

---
### Test Case: 2 — Minimum Valid Lab* Values (uint8 Input)

Verifies conversion of L* a* b* values at the lower end of the nominal range.

```scilab
lab = uint8(cat(3, ...
                zeros(2,2), ...
                zeros(2,2), ...
                zeros(2,2)));

out = lab2uint16(lab);
```

**Expected output:** `Returns uint16 values corresponding to the minimum valid L* a* b* range.`

---
### Test Case: 3 — Maximum Valid Lab* Values (uint16 Input)

Verifies conversion of L* a* b* values at the upper end of the nominal range.

```scilab
lab = uint16(cat(3, ...
                 65280*ones(2,2), ...
                 65280*ones(2,2), ...
                 65280*ones(2,2)));

out = lab2uint16(lab);
```

**Expected output:** `Returns uint16 values corresponding to the maximum valid L* a* b* range.`

---
### Test Case: 4 — Single Pixel
Verifies conversion of a single L* a* b* pixel.

```scilab
lab = cat(3, 50, 0, 0); 
out = lab2uint16(lab);
```

**Expected output:** `Returns a single uint16 L* a* b* pixel.`

---
### Test Case: 5 — uint8 Input

Verifies conversion of an encoded uint8 L* a* b* image to uint16 representation.

```scilab
lab = uint8(cat(3, ... 
[0 128; 255 64], ... 
[128 128; 128 128], ... 
[128 128; 128 128])); 

out = lab2uint16(lab);
```

**Expected output:** `Returns an equivalent uint16 L* a* b* image.`


---
### Test Case: 6 — uint16 Input

Verifies behavior when the input is already stored as uint16 L* a* b* data.

```scilab
lab = uint16(cat(3, ... 
[0 1000; 30000 65280], ... 
[0 1000; 30000 65280], ... 
[0 1000; 30000 65280])); 

out = lab2uint16(lab);
```

**Expected output:** `Returns a uint16 L* a* b* image with preserved or equivalent values.`

---
### Test Case: 7 — Out-of-Range Values

Verifies handling of L* a* b* values outside the nominal range.

```scilab
lab = cat(3, ... 
[-20 120; 200 -50], ... 
[-200 200; -150 150], ... 
[-200 200; -150 150]); 

out = lab2uint16(lab);
```

**Expected output:** `Behavior depends on clipping and scaling rules implemented in lab2cls().`

---
### Test Case: 8 — NaN Values

Verifies handling of undefined numerical values.
```scilab
lab = cat(3, ... 
[%nan 50], ... 
[0 0], ... 
[0 0]); 

out = lab2uint16(lab);
```

**Expected output:** `Behavior depends on NaN handling implemented in lab2cls().`

---
### Test Case: 9 — Invalid 2-D Input

Verifies error handling when the input is not a valid Lab* image.

```scilab
lab = [1 2; 3 4]; 
out = lab2uint16(lab);
```

**Expected output:** `Error generated by lab2cls() indicating invalid L* a* b* data.`

---
### Test Case: 10 — int16 Input

Verifies error handling for unsupported signed integer input.

```scilab
lab = int16(cat(3, ... 
[0 50], ... 
[0 0], ... 
[0 0])); 

out = lab2uint16(lab);
```

**Expected output:** `Error generated by lab2cls() indicating unsupported input class.`

---

### Test Results

The file `lab2uint16_Test_Results.pdf` contains the results obtained from executing all test cases, including:

* Input L* a* b*  matrices.
* Datatypes before and after conversion.
* Converted `uint16` outputs.
* Error handling outputs for invalid inputs.


---

## Compatibility Notes

This implementation follows the behavior of GNU Octave's `lab2uint16` function.

### Important Differences
* The conversion itself is performed by `lab2cls()`.
* Any limitations of `lab2cls()` are inherited by `lab2uint16`.
* Input validation and scaling behavior are handled by `lab2cls()`.

---

### Recommended Usage
For converting L* a* b* images to `uint8` format:
```
lab = rgb2lab(rgbImage);
lab_uint16 = lab2uint16(lab);
```
Use `lab2uint16()` when higher precision storage of L* a* b* data is required.

---

## References

[1] MATLAB Image Processing Toolbox Documentation

[2] GNU Octave Image Package Documentation

[3] CIE L* a* b* Color Space Specification
