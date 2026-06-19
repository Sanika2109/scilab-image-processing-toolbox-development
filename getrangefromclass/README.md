# getrangefromclass

## Description:
`getrangefromclass` returns the valid intensity range associated with the datatype of an image.

For integer image types, the function returns the minimum and maximum representable values of the datatype. For floating-point (`constant`) and boolean images, it returns the normalized intensity range `[0, 1]`.

The function is useful in image-processing algorithms that require knowledge of the valid intensity limits of an image class.
## Calling Sequence:
```
r = getrangefromclass(img)
```
## Dependencies

The function depends on the following external files:

| File | Purpose |
|--------|---------|
| `intmin.sci` | Returns the minimum representable value for an integer datatype. |
| `intmax.sci` | Returns the maximum representable value for an integer datatype. |

These dependency files must be loaded before `getrangefromclass.sci`. The test script does this automatically:

```scilab
base = get_absolute_file_path("getrangefromclass_test.sce");

exec(base + "../intmin/intmin.sci", -1);
exec(base + "../intmax/intmax.sci", -1);
exec(base + "getrangefromclass.sci", -1);
```

## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `img` | Matrix | **Input:** Image whose class range is to be determined. |
| `r` | Double Row Vector |**Output:** Two-element vector containing the minimum and maximum values supported by the image class. |


---



## Variable Reference:

| Variable         | Scope         | Type             | Description                                                                                                                                                |
| ---------------- | ------------- | ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `img`             | Input | Matrix  |Input image whose datatype is analyzed.             |
| `cl` | Local       | String         | Stores the datatype returned by `typeof(img)`.                                                                         |
| `r`           | Output        | Double Vector       |Two-element vector containing the valid range of the image class.                           |
| `isint`            | Local / Helper Output         | Boolean      | Indicates whether the input belongs to an integer datatype.   |


---
## Helper Functions:

| Function   | Type     | Purpose                                                                               |
| ---------- | -------- | ------------------------------------------------------------------------------------- |
| `argn()`   | Built-in | Determines the number of input arguments supplied to the function.|
| `error()`   | Built-in | Generates an error message when invalid input is detected.|
| `typeof()`   | Built-in | Returns the datatype of the input image.|
| `isinteger()`  | Helper Function | Determines whether the input belongs to a supported integer datatype. |
| `intmin()`  | Built-in | Returns the minimum representable value of an integer datatype. |
| `intmax()`  | Built-in | Returns the maximum representable value of an integer datatype. |
| `double()`   | Built-in | Converts the output range to double precision.|
| `or()`   | Built-in | Evaluates logical conditions involving multiple datatype comparisons.|
| `msprintf()` | Built-in | Formats error messages for unsupported image classes.      |
  
---
## Time & Space Complexity:

**Time Complexity:** `O(1)`

The function performs only datatype inspection and constant-time range retrieval.


**Space Complexity:** `O(1)` 

Only a few scalar variables and a two-element output vector are allocated.

---


## Mathematical Foundation:

Let
`I`
be an image 

of datatype
`C = typeof(I)`

The output range is defined as:

### Integer Image Types
For integer datatypes:

`r = [intmin(C), intmax(C)]`

**Examples:**

uint8  → `[0, 255]`

int8   → `[-128, 127]`

uint16 → `[0, 65535]`

int16  → `[-32768, 32767]`

### Logical and Floating-Point Images
For boolean and constant datatypes:

`r = [0, 1]`

This corresponds to the normalized intensity range commonly used in image-processing operations.

### Output Range

The output is always a double-precision vector:

r ∈ ℝ²

with

`r(1) ≤ r(2)`

### Supported Datatypes

The helper function `isinteger()` recognizes the following integer image classes:

Datatype
* int8
* uint8
* int16
* uint16
* int32
* uint32
* int64
* uint64

The function additionally supports:

Datatype
* boolean
* constant


---
## Test Cases:

The following 15 test cases support image classes, boundary conditions, and invalid inputs. Run the test script:

```scilab
exec("getrangefromclass_test.sce", -1);
```

### Test Case: 1 — uint8 Image

Verifies correct range detection for standard 8-bit unsigned integer image.

```scilab
I = uint8([1 2; 3 4]);
r = getrangefromclass(I);
```

**Expected output:** `[0 255]`

---
### Test Case: 2 — int8 Image

Verifies correct range detection for signed 8-bit integer image.

```scilab
I = int8([1 -2; 3 -4]);
r = getrangefromclass(I);
```

**Expected output:** `[-128 127]`

---
### Test Case: 3 — uint16 Image

Verifies correct range detection for 16-bit unsigned integer image.

```scilab
I = uint16([1 2; 3 4]);
r = getrangefromclass(I);
```

**Expected output:** `[0 65535]`

---
### Test Case: 4 — int16 Image
Verifies correct range detection for signed 16-bit integer image.

```scilab
I = int16([1 -2; 3 -4]);
r = getrangefromclass(I);
```

**Expected output:** `[-32768 32767]`

---
### Test Case: 5 — uint32 Image

Verifies correct range detection for 32-bit unsigned integer image.

```scilab
I = uint32([1 2; 3 4]);
r = getrangefromclass(I);
```

**Expected output:** `[0 4294967295]`


---
### Test Case: 6 — int32 Image

Verifies correct range detection for 32-bit signed integer image.

```scilab
I = int32([1 -2; 3 -4]);
r = getrangefromclass(I);
```

**Expected output:** `[-2147483648 2147483647]`

---
### Test Case: 7 — uint64 Image

Verifies correct range detection for 64-bit unsigned integer image.

```scilab
I = uint64([1 2; 3 4]);
r = getrangefromclass(I);
```

**Expected output:** `[0 18446744073709551615]`

---
### Test Case: 8 — int64 Image

Verifies correct range detection for 64-bit signed integer image.
```scilab
B = medfilt2(double(A), [3 3], "symmetric");
```

**Expected output:** `[-9223372036854775808 9223372036854775807]`

---
### Test Case: 9 — Double Image

Verifies default normalized range for floating-point (constant) images.

```scilab
I = rand(5,5);
r = getrangefromclass(I);
```

**Expected output:** `[0 1]`

---
### Test Case: 10 — Boolean Image

Verifies correct range for logical images.

```scilab
I = [%t %f; %f %t];
r = getrangefromclass(I);
```

**Expected output:** `[0 1]`

---
### Test Case: 11 — Actual Grayscale Image

Verifies correct range detection for real image loaded using imread.

```scilab
I = imread("cameraman.jpeg");
r = getrangefromclass(I);
```

**Expected output:** `[0 255]` (for uint8 image)

---
### Test Case: 12 — Empty Matrix

Verifies behavior for empty input image.

```scilab
I = [];
r = getrangefromclass(I);
```

**Expected output:** `Error: "getrangefromclass: IMG must be an image"`

---
### Test Case: 13 — String Input (Invalid)

Verifies error handling for unsupported data type (string).

```scilab
r = getrangefromclass("hello");
```

**Expected output:** `Error: "getrangefromclass: unrecognized image class"`

---
### Test Case: 14 — List Input (Invalid)

Verifies error handling for unsupported Scilab list input.
```scilab
r = getrangefromclass(list(1,2,3));
```

**Expected output:** `Error: "getrangefromclass: unrecognized image class"`

---
### Test Case: 15 — No Input Argument

Verifies error handling when no input is provided.

```scilab
r = getrangefromclass();
```

**Expected output:** `Error: "getrangefromclass: IMG must be an image"`

---
### Test Results

The file `getrangefromclass_Test_Results.pdf` contains the results obtained from executing all test cases, including:

* Input images or matrices
* Output intensity range values
* Error outputs for invalid inputs


---

## Compatibility Notes

This implementation follows the behavior of GNU Octave's `getrangefromclass` function.

### Important Differences
* Scilab uses `typeof()` instead of MATLAB's `class()`.
* Floating-point images `(constant)` are assumed to use the normalized range:
`[0, 1]`
* Only the datatypes explicitly listed in `isinteger()` are recognized as integer image classes.
* Unsupported datatypes generate an error.


---

### Recommended Usage
Use `getrangefromclass` whenever an image-processing algorithm requires the valid intensity limits of an image datatype.

Example:
```
I = uint8(rand(256,256) * 255);

r = getrangefromclass(I);

disp("Minimum:");
disp(r(1));

disp("Maximum:");
disp(r(2));
```




---

## References

[1] MATLAB Image Processing Toolbox Documentation

[2] GNU Octave Image Package Documentation

[3] Octave Documentation for `intmin` and `intmax`
