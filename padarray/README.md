# padarray

## Description:
`padarray` extends the boundaries of a matrix or image by adding rows and columns around its edges.

The function supports several padding methods, including constant-value padding, zero padding, border replication, circular wrapping, reflection, and symmetric reflection. Padding is commonly used in image processing operations such as filtering, convolution, edge detection, and morphological processing.
## Calling Sequence:
```
padding = padarray(A, padsize) 
padding = padarray(A, padsize, padopt)
```

---
## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `A` | Matrix | Input matrix or image to be padded. |
| `padsize` | Vector | Two-element vector `[rows cols]` specifying the number of rows and columns to add on each side. |
| `padopt` |  String / Scalar| Padding mode or constant padding value. Default: `0`. |
| `padding` |  Matrix| Output padded matrix.  |

---

## Supported Padding Modes:

| Mode | Description |
| :--- |  :--- |
| `0` or scalar value | Constant-value padding | 
| `"zeros"` | Pads with zeros | 
| `"replicate"` |  Replicates border values|
| `"circular"` |  Wraps image values cyclically|
| `"reflect"` |  Reflects image excluding edge pixels|
| `"symmetric"` |  Reflects image including edge pixels| 

---

## Variable Reference:

| Variable         | Scope         | Type             | Description                                                                                                                                                |
| ---------------- | ------------- | ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `A`             | Input | Matrix  |Input matrix or image.             |
| `padsize` | Input        | Vector         | Padding dimensions `[rows cols]`.                                                                          |
| `padopt`           | Input         | String / Scalar       | Selected padding method or constant value.                           |
| `m`            | Local         | Integer      | Number of rows to pad.   |
| `n`            | Local         | Integer      | Number of columns to pad.   |
| `rows`            | Local         | Integer      |Number of rows in input matrix.    |
| `cols`            | Local         | Integer      | Number of columns in input matrix.    |
| `padding`            | Output         | Matrix       | Resulting padded matrix.   |

---
## Helper Functions:

| Function   | Type     | Purpose                                                                               |
| ---------- | -------- | ------------------------------------------------------------------------------------- |
| `argn()`   | Built-in | Determines the number of input arguments.|
| `error()`   | Built-in | Generates error messages for invalid inputs.|
| `size()`  | Built-in | Obtains matrix dimensions. |
| `type()`  | Built-in | Determines data type of padding option. |
| `int()`  | Built-in | Converts padding dimensions to integers. |
| `ones()`   | Built-in | Creates matrices for constant-value and replicate padding.|
| `zeros()`   | Built-in | Creates matrices initialized with zeros..|
| `double()` | Built-in | Converts input arrays to double precision before arithmetic operations.      |
| `convstr()`  | Built-in | Converts padding mode strings to lowercase for comparison. |

---
## Algorithm:

```text
Start
│
├─ Receive input matrix A
│
├─ Validate inputs
│   ├─ Check number of arguments
│   ├─ Check padsize format
│   └─ Check non-negative padding values
│
├─ Set default padding mode if omitted
│
├─ Extract padding dimensions
│
├─ Determine padding type
│
├─ Constant value padding?
│   └─ Create output matrix and place A at center
│
└─ Otherwise
    ├─ Zero padding
    ├─ Replicate padding
    ├─ Circular padding
    ├─ Reflect padding
    └─ Symmetric padding
         │
         ▼
      Return padded matrix
```
                  
---
## Time & Space Complexity:

Let:

`Input size = M × N`

`Padding size = m × n`

Output size: `(M + 2m) × (N + 2n)`

**Time Complexity:** `O((M + 2m)(N + 2n))`

since every element of the output matrix must be assigned.

**Space Complexity:** `O((M + 2m)(N + 2n))`

for storing the padded matrix.

---


## Mathematical Foundation:

Let:

A ∈ ℝ^(M×N)
be the input matrix.

**Padding dimensions:**

padsize = `[m n]`

**The output matrix has dimensions:**

`(M + 2m) × (N + 2n)`

### Constant Padding
For a constant value `c` :

`P(i,j) = c`

outside the original image region.

**The original matrix is placed at:**

`P(m+1:m+M, n+1:n+N) = A`

### Zero Padding
Special case of constant padding where:

`c = 0`

### Replicate Padding

Border pixels are repeated outward:

* Top border    = first row

* Bottom border = last row

* Left border   = first column

* Right border  = last column

### Circular Padding

Values wrap around periodically:

* Left border  ← Right side values

* Right border ← Left side values

* Top border   ← Bottom values

* Bottom border ← Top values

Equivalent to periodic boundary conditions.

### Reflect Padding

Values are mirrored without repeating edge pixels.

Example:

`[1 2 3]`

becomes

`[2 1 2 3 2]`

### Symmetric Padding

Values are mirrored including edge pixels.

Example:

`[1 2 3]`

becomes

`[1 1 2 3 3]`

---

### Output Size

For input size:

`M × N`

and padding:

`[m n]`

the output size is:

`(M + 2m) × (N + 2n)`

---
## Test Cases:

The following 12 test cases validate all supported padding modes, boundary conditions, and error handling scenarios. Run them after loading the function with `exec('padarray_test.sce', -1)`.

### Test Case: 1 — Default Zero Padding

Verifies that omitted padding mode defaults to zero padding.

```scilab
A = [1 2;
     3 4];

padarray(A,[1 1]);
```

**Expected output:** `Matrix padded with zeros on all sides.`

---
### Test Case: 2 — Explicit Zero Padding

Verifies the `"zeros"` padding mode.

```scilab
padarray(A,[1 1],"zeros");
```

**Expected output:** `Same result as Test Case 1.`

---
### Test Case: 3 — Constant Value Padding

Verifies padding using a user-defined constant value.

```scilab
padarray(A,[1 1],5);
```

**Expected output:** `Border values equal to 5.`

---
### Test Case: 4 — Replicate Padding

Verifies border replication.

```scilab
padarray(A,[1 1],"replicate");
```

**Expected output:** `Edge pixels are repeated outward.`

---
### Test Case: 5 — Circular Padding

Verifies periodic boundary extension.

```scilab
padarray(A,[1 1],"circular");
```

**Expected output:** `Opposite image edges wrap around.`


---
### Test Case: 6 — Reflect Padding

Verifies reflection excluding border pixels.

```scilab
A = [1 2 3;
     4 5 6;
     7 8 9];

padarray(A,[1 1],"reflect");
```

**Expected output:** `Border values are mirrored without repeating edge pixels.`

---
### Test Case: 7 — Symmetric Padding

Verifies reflection including border pixels.

```scilab
padarray(A,[1 1],"symmetric");
```

**Expected output:** `Border values are mirrored with edge pixels repeated.`

---
### Test Case: 8 — Non-Square Padding

Verifies unequal row and column padding.

```scilab
A = [1 2 3;
     4 5 6];

padarray(A,[1 3],"replicate");
```

**Expected output:** `Matrix padded by 1 row and 3 columns on each side.`

---
### Test Case: 9 — Single Pixel Image

Verifies padding of a 1×1 image.

```scilab
padarray(7,[2 2],0);
```

**Expected output:** `A 5×5 matrix with the center value equal to 7 and surrounding zeros.`

---
### Test Case: 10 — No Padding

Verifies behavior when padding size is zero.

```scilab
padarray(A,[0 0]);
```

**Expected output:** `Original matrix returned unchanged.`

---
### Test Case: 11 — Invalid Negative Padding Size

Verifies input validation.

```scilab
padarray(A,[-1 1]);
```

**Expected output:** `Error indicating that padding sizes must be non-negative.`

---
### Test Case: 12 — Invalid Reflect Padding Size

Verifies reflect-mode boundary checking.

```scilab
padarray([1 2;3 4],[2 2],"reflect");
```

**Expected output:** `Error indicating that reflect padding size must be smaller than image dimensions.`

---
### Test Results

The file `padarray_Test_Results.pdf` contains the results obtained from executing all test cases, including:

* Input matrices used for each test case.
* Selected padding mode and padding size.
* Output padded matrices.
* Error message generated for invalid inputs.


---

## Compatibility Notes

This implementation follows the behavior of GNU Octave's `padarray` function.

### Supported Modes

* Constant-value padding
* Zero padding
* Replicate padding
* Circular padding
* Reflect padding
* Symmetric padding

### Differences
* Padding is applied equally on all sides.
* Only two-dimensional padding sizes `[rows cols]` are supported.
* Circular and symmetric modes validate padding size against image dimensions.
* Reflect mode requires padding dimensions to be strictly smaller than image dimensions.

---

### Recommended Usage
**Zero Padding:**
```scilab
B = padarray(A,[1 1]);
```
**Constant Padding:**
```scilab
B = padarray(A,[2 2],5);
```
**Replicate Padding:**
```scilab
B = padarray(A,[1 1],"replicate");
```
**Circular Padding:**
```scilab
B = padarray(A,[1 1],"circular");
```
**Reflect Padding:**
```scilab
B = padarray(A,[1 1],"reflect");
```
**Symmetric Padding:**
```scilab
B = padarray(A,[1 1],"symmetric");
```




---

## References

[1] MATLAB Image Processing Toolbox Documentation

[2] GNU Octave Image Package Documentation

