# lab2uint8

## Description:
`lab2uint8` lab2uint8 converts a CIE L* a* b* image or colormap to the `uint8` representation commonly used in image-processing applications.

The function serves as a wrapper around `lab2cls`, requesting conversion of the input L* a* b* data to the `uint8` class. The conversion maps the L* a* b* components into the valid range of unsigned 8-bit integers `(0–255)`.

The function accepts exactly one input argument and returns the converted L* a* b* image or colormap in `uint8` format.

## Calling Sequence:
```
lab_uint8 = lab2uint8(lab)
```
## Dependencies

The function depends on the following external file:

| File | Purpose |
|--------|---------|
| `lab2cls.sci` | Converts L* a* b* data to the specified output class. |

The dependency file must be loaded before executing `lab2uint8.sci`. The test script does this automatically:

```scilab
base = get_absolute_file_path("lab2uint8_test.sce");
exec(base + "../lab2cls/lab2cls.sci", -1);
exec(base + "lab2uint8.sci", -1);
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

The following 10 test cases cover valid L* a* b* colormaps, boundary values, special inputs, and error conditions. Run the test script:

```scilab
exec ('lab2uint8_test.sce', -1);
```

### Test Case: 1 — Real LAB Image from RGB

Verifies conversion using a real image converted from RGB to LAB.

```scilab
rgb = DogImg;
lab = rgb2lab(rgb);

out = lab2uint8(lab);

```

**Expected output:** `Returns a valid uint8 LAB image with same dimensions as input.`

---
### Test Case: 2 — Minimum Valid LAB (double)

Checks lower bound LAB values.

```scilab
lab = cat(3, ...
          zeros(2,2), ...
          -128*ones(2,2), ...
          -128*ones(2,2));

out = lab2uint8(lab);
```

**Expected output:** `Proper conversion with clamping/scaling of minimum LAB values.`

---
### Test Case: 3 — Maximum Valid LAB (double)

Checks upper bound LAB values.

```scilab
lab = cat(3, ...
          100*ones(2,2), ...
          127*ones(2,2), ...
          127*ones(2,2));

out = lab2uint8(lab);
```

**Expected output:** `Proper conversion of maximum LAB values into uint8 range.`

---
### Test Case: 4 — Typical LAB Values (double)

Verifies standard mid-range LAB values.

```scilab
lab = cat(3, ...
          [50 75;25 100], ...
          [0 20;-20 40], ...
          [0 -30;30 60]);

out = lab2uint8(lab);
```

**Expected output:** `Correct uint8 representation of typical LAB values.`

---
### Test Case: 5 — NaN Handling

Checks robustness against invalid NaN values.

```scilab
lab = cat(3, ...
          [%nan 50;25 100], ...
          [0 20;%nan 40], ...
          [0 -30;30 %nan]);

out = lab2uint8(lab);
```

**Expected output:** `NaN values handled via clipping rules defined in lab2cls().`


---
### Test Case: 6 — Clipping Behavior (Out-of-Range Double)

Checks handling of extreme LAB values.

```scilab
lab = cat(3, ...
          [-20 50;120 200], ...
          [-200 0;100 300], ...
          [-300 0;100 400]);

out = lab2uint8(lab);
```

**Expected output:** `Values clipped to valid LAB range before conversion.`

---
### Test Case: 7 — uint8 Encoded LAB Input

Validates uint8 LAB input handling.

```scilab
lab = cat(3, ...
          uint8([0 128;200 255]), ...
          uint8([0 128;200 255]), ...
          uint8([0 128;200 255]));

out = lab2uint8(lab);
```

**Expected output:** `Correct conversion of uint8-encoded LAB image.`

---
### Test Case: 8 — uint16 Encoded LAB Input

Checks uint16 encoded LAB values.

```scilab
lab = cat(3, ...
          uint16([0 32768;49152 65280]), ...
          uint16([0 32768;49152 65280]), ...
          uint16([0 32768;49152 65280]));

out = lab2uint8(lab);
```

**Expected output:** `Proper scaling and conversion of uint16 LAB input.`

---
### Test Case: 9 — Empty Input (Error Case)

Ensures function handles empty input safely.

```scilab
lab = []; 
out = lab2uint8(lab);
```

**Expected output:** `Error handled by lab2cls() validation logic.`

---
### Test Case: 10 — Invalid Dimensions (Error Case)

Checks invalid 2D input rejection.

```scilab
lab = uint8([50 60;70 80]); 
out = lab2uint8(lab);
```

**Expected output:** `Error indicating invalid LAB image format (handled by lab2cls()).`

---

### Test Results

The file `lab2uint8_Test_Results.pdf` contains the results obtained from executing all test cases, including:

* Input L* a* b* image.
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
