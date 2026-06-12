# lab2uint8

## Description:
`lab2uint8` lab2uint8 converts a CIE L* a* b* image or colormap to the `uint8` representation commonly used in image-processing applications.

The function serves as a wrapper around `lab2cls`, requesting conversion of the input L* a* b* data to the `uint8` class. The conversion maps the L* a* b* components into the valid range of unsigned 8-bit integers `(0–255)`.

The function accepts exactly one input argument and returns the converted L* a* b* image or colormap in `uint8` format.
## Calling Sequence:
```
lab_uint8 = lab2uint8(lab)
```

---
## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `lab` | Matrix | **Input:** L* a* b* image or colormap represented as a numeric matrix or multidimensional array. |
| `lab_uint8` | uint8 Matrix |**Output:** L* a* b* image or colormap converted to `uint8` representation. |


---



## Variable Reference:

| Variable         | Scope         | Type             | Description                                                                                                                                                |
| ---------------- | ------------- | ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `lab`             | Input/Output | Matrix  |Input L* a* b* image or colormap. After conversion, contains the uint8 representation of the L* a* b* data.             |



---
## Helper Functions:

| Function   | Type     | Purpose                                                                               |
| ---------- | -------- | ------------------------------------------------------------------------------------- |
| `argn()`   | Built-in | Determines the number of input arguments supplied to the function.|
| `error()`   | Built-in | Generates an error message when invalid input is detected.|
|`lab2cls()`   | Helper Function | Performs conversion of L* a* b* data to a specified output class.|
| `uint8()`  | Built-in (used internally by `lab2cls()`) | Converts numeric values to unsigned 8-bit integer representation. |

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
  +-- Yes --> Call lab2cls(LAB, "uint8")
                 |
                 v
          Convert LAB Data to uint8 Class
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

Additional memory is required to store the converted `uint8` output.

---


## Mathematical Foundation:

The CIE L* a* b* color space consists of three components:

`L*`  → Lightness

`a*`  → Green–Red axis

`b*`  → Blue–Yellow axis

The conversion performed by

`LAB_uint8 = lab2cls(LAB, "uint8")`

maps the floating-point L* a* b* values to unsigned 8-bit integer values.

Conceptually:

L* ∈ `[0,100]`

a* ∈ `[-128,127]`

b* ∈ `[-128,127]`

are transformed into

uint8 ∈ `[0,255]`

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

where each row represents one L* a* b* color.

### Output Characteristics
The returned data:

* Has datatype `uint8`.
* Preserves the dimensions of the input.
* Contains encoded L* a* b* values suitable for storage and visualization.


---
## Test Cases:

The following 10 test cases cover valid L* a* b* colormaps, boundary values, special inputs, and error conditions. Run them after loading the function with `(exec 'lab2uint8_test.sce', -1)`.

### Test Case: 1 — Typical Lab* Image

Verifies conversion of a typical L* a* b* image containing valid L*, a* and b* values.

```scilab
lab = cat(3, ... 
[50 75; 25 100], ... 
[0 20; -20 40], ... 
[0 -30; 30 60]); 

out = lab2uint8(lab);
```

**Expected output:** `Returns a uint8 representation of the input L* a* b* image.`

---
### Test 2: Minimum valid L*a*b* values (uint8 Input)

Verifies conversion of L* a* b* values at the lower end of the nominal range.

```scilab
lab = cat(3, ...
          uint8(zeros(2,2)), ...
          uint8(zeros(2,2)), ...
          uint8(zeros(2,2)));

out = lab2uint8(lab);
```

**Expected output:** `Returns uint8 values corresponding to the minimum valid L* a* b* range.`

---
### Test Case: 3 — Maximum valid L*a*b* values (uint16 Input)

Verifies conversion of L* a* b* values at the upper end of the nominal range.

```scilab
lab = cat(3, ...
          uint16(65280*ones(2,2)), ...
          uint16(65280*ones(2,2)), ...
          uint16(65280*ones(2,2)));

out = lab2uint8(lab);
```

**Expected output:** `Returns uint8 values corresponding to the maximum valid L* a* b* range.`

---
### Test Case: 4 — Floating-Point Values
Verifies conversion of non-integer L* a* b* values.

```scilab
lab = cat(3, ... 
[10.5 20.2; 30.8 40.1], ... 
[1.5 -2.3; 5.7 -8.9], ... 
[15.4 -12.7; 25.8 -30.6]); 

out = lab2uint8(lab);
```

**Expected output:** `Returns a uint8 image after converting floating-point L* a* b* values.`

---
### Test Case: 5 — uint8 Encoded L*a*b* Input

Verifies conversion when the input consists of integer-valued L* a* b* data.

```scilab
lab = cat(3, ...
          uint8([0 50; 75 100]), ...
          uint8([0 128; 178 255]), ...
          uint8([0 128; 178 255]));

out = lab2uint8(lab);
```

**Expected output:** `Returns the equivalent uint8 representation.`


---
### Test Case: 6 — Single pixel L*a*b* value (uint16 Input)

Verifies conversion of a single L* a* b* pixel.

```scilab
lab = cat(3, ...
          uint16(32640), ...
          uint16(32768), ...
          uint16(32768));
out = lab2uint8(lab);
```

**Expected output:** `Returns a single uint8 L* a* b* pixel.`

---
### Test Case: 7 — 3-D Lab* Image

Verifies conversion of a larger multidimensional L* a* b* image.

```scilab
lab = rand(4,4,3); 
lab(:,:,1) = lab(:,:,1) * 100; 
lab(:,:,2) = lab(:,:,2) * 255 - 128; 
lab(:,:,3) = lab(:,:,3) * 255 - 128; 

out = lab2uint8(lab);
```

**Expected output:** `Returns a uint8 image having the same dimensions as the input.`

---
### Test Case: 8 — Out-of-Range L*a*b* Values (uint16 Input)

Verifies behavior when L* a* b* values fall outside the nominal range.
```scilab
lab = cat(3, ...
          uint16([0 32768; 49152 65535]), ...
          uint16([0 15234; 33425 61767]), ...
          uint16([0 54678; 42252 65535]));

out = lab2uint8(lab);
```

**Expected output:** `Behavior depends on the clipping and scaling rules implemented in lab2cls().`

---
### Test Case: 9 — Empty Input

Verifies handling of an empty input array.

```scilab
lab = []; 
out = lab2uint8(lab);
```

**Expected output:** `Behavior depends on the validation performed by lab2cls().`

---
### Test Case: 10 — Invalid 2-D uint8 Input (Should Error)

Verifies error handling when the input is not a valid Lab* image.

```scilab
lab = uint8([50 60; 70 80]);
out = lab2uint8(lab);
```

**Expected output:** `Error generated by lab2cls() indicating invalid L* a* b* data.`

---

### Test Results

The file `lab2uint8_Test_Results.pdf` contains the results obtained from executing all test cases, including:

* Input L* a* b*  colormaps.
* Datatypes before and after conversion.
* Converted `uint8` outputs.
* Error handling outputs for invalid function calls.


---

## Compatibility Notes

This implementation follows the behavior of GNU Octave's `lab2uint8` function.

### Important Differences
* The conversion itself is performed by `lab2cls()`.
* Any limitations of `lab2cls()` are inherited by `lab2uint8`.
* Input validation beyond argument count is delegated to `lab2cls()`.

---

### Recommended Usage
For converting L* a* b* images to `uint8` format:
```
lab = rgb2lab(rgbImage);
lab_uint8 = lab2uint8(lab);
```
The resulting data can be stored efficiently and used in image-processing workflows requiring 8-bit representations.

---

## References

[1] MATLAB Image Processing Toolbox Documentation

[2] GNU Octave Image Package Documentation

[3] CIE L* a* b* Color Space Specification
