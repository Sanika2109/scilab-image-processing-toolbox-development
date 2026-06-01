# immse 

## Description:
`immse` computes the Mean Squared Error (MSE) between two images or matrices of identical dimensions.

The Mean Squared Error is a widely used metric for measuring the similarity between two images. It is calculated as the average of the squared differences between corresponding elements of the input arrays.

An MSE value of:

`0` indicates that the two inputs are identical.
* A small positive value indicates minor differences.
* A large value indicates significant differences.

`immse` is commonly used in image processing applications such as image compression evaluation, image restoration assessment, denoising analysis, and image quality measurement.
## Calling Sequence:
```
mse = immse(A, B)
```

---
## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `A` | Matrix | **Input:** First image or matrix. |
| `B` | Matrix | **Input:** Second image or matrix. Must have the same dimensions as A. |
| `mse` | Double | **Output:** Mean Squared Error between `A` and `B`. |

---
## Variable Reference

| Variable         | Scope         | Type             | Description                                                                                                                                                |
| ---------------- | ------------- | ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `A`             | Input / Local | Matrix (Logical) |First input image or matrix. Converted to double precision before computation.                 |
| `B` | Input / Local        | Matrix           | Second input image or matrix. Converted to double precision before computation.                                                                                        |
| `diff`           | Local         | Matrix       | Element-wise difference between corresponding elements of `A` and `B`.                                                                |
| `mse`            | Output         | Double       | Mean Squared Error computed from the squared differences.    |
---
## Helper Functions

| Function   | Type     | Purpose                                                                               |
| ---------- | -------- | ------------------------------------------------------------------------------------- |
| `argn()`   | Built-in | Determines the number of input arguments supplied to the function.                    |
| `error()`  | Built-in | Generates an error message and terminates execution when invalid input is detected.   |
| `size()`  | Built-in | Verifies that the input matrices are non-empty and have identical dimensions. |
| `double()` | Built-in | Converts input arrays to double precision before arithmetic operations.      |
| `mean()`  | Built-in | Computes the average value of the squared differences.      |


---
## Algorithm

```text
┌─────────────────────┐
│        Start        │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Receive Inputs      │
│       A and B       │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Validate Inputs     │
│ • Two arguments     │
│ • Non-empty arrays  │
│ • Same dimensions   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Convert Inputs to   │
│ Double Precision    │ 
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Compute Difference  │
│        A - B        │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Square Each         │
│ Difference Element  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Compute Mean of     │
│ Squared Differences │ 
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Return MSE Value    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│         End         │
└─────────────────────┘
```

---
## Time & Space Complexity:

Time Complexity: O(M × N), where `M × N` is the number of elements in the input arrays.

Space Complexity: O(M × N)

Additional memory is required for storing the difference matrix.

---


## Mathematical Foundation

The Mean Squared Error measures the average squared difference between corresponding elements of two matrices.

### Difference Matrix

For two images:

`A(x,y)`

`B(x,y)`

the difference at each position is:

`D(x,y) = A(x,y) − B(x,y)`

### Squared Difference

The squared difference is:

`D²(x,y) = [A(x,y) − B(x,y)]²`

Squaring ensures:

* Positive and negative errors contribute equally.
* Larger errors are penalized more heavily.

### Mean Squared Error Formula

The MSE is computed as:

`MSE = mean((A - B)^2)`

where:

|Symbol	| Meaning |
| :--- | :--- | 
`Aᵢ`|	Element from first image
`Bᵢ`|	Corresponding element from second image
`N`	|Total number of elements
`MSE`|	Mean Squared Error

### Output Range

Since squared differences are always non-negative:

`MSE ≥ 0`

---
Special cases:
---

**Identical Inputs**

`A = B`

then:

`MSE = 0`

**Different Inputs**

`A != B`

then:

`MSE > 0`

The larger the differences between corresponding elements, the larger the MSE value.
## Test Cases:

The following 12 test cases cover valid inputs, boundary conditions, numerical precision checks, and error handling scenarios. Run them after loading the function with `exec('immse_test.sce', -1)`.

### Test Case: 1 — Identical images

Verifies that the MSE is zero when both inputs are identical.

```scilab
A = [5 5;
     5 5];

immse(A, A)
```

**Expected output:** `0`

Since corresponding elements are identical, all squared differences are zero.

---
### Test Case: 2 — Small Difference

Verifies computation when only a few elements differ slightly

```scilab
A = [5 5;
     5 5];

B = [4 6;
     5 5];

immse(A, B)
```

**Expected output:** `0.5`

**Calculation:**
```
[(1² + 1² + 0² + 0²)] / 4

= 2/4

= 0.5
```
---
### Test Case: 3 — Large Difference

Verifies MSE for significantly different images.

```scilab
A = [5 5;
     5 5];

B = zeros(2,2);

immse(A, B)
```

**Expected output:** `25`

**Calculation:**
```
[(5² + 5² + 5² + 5²)] / 4

= 100/4

= 25
```
---
### Test Case: 4 — Floating-Point Inputs

Verifies operation on random floating-point matrices.

```scilab
A = rand(4,4);
B = rand(4,4);

immse(A, B)
```

**Expected output:** `Positive floating-point value depending on the generated matrices.`

---
### Test Case: 5 — Negative Values

Verifies that negative values are handled correctly.

```scilab
A = [-1 -2;
      3  4];

B = [ 1  2;
     -3 -4];

immse(A, B)
```

**Expected output:** `30`

**Calculation:**
```
[(−2)² + (−4)² + 6² + 8²] / 4

= (4 + 16 + 36 + 64)/4

= 120/4

= 30
```
---
### Test Case: 6 — Size Mismatch

Verifies input dimension validation.

```scilab
immse([1 2], [1 2 3])
```

**Expected output:** `Input images must have the same dimensions.`

The function should terminate with an error.

---
### Test Case: 7 — Zero Images

Verifies behavior when both inputs contain only zeros.

```scilab
A = zeros(3,3);
B = zeros(3,3);

immse(A, B)
```

**Expected output:** `0`

Since all corresponding elements are equal, the error is zero.

---
### Test Case: 8 — One Zero Image and One Non-Zero Image

Verifies MSE when one image is entirely zero and the other contains a constant value.

```scilab
A = zeros(3,3);
B = ones(3,3) * 10;

immse(A, B)
```

**Expected output:** `100`

**Calculation:**
```
(10²) = 100
```
All elements contribute equally.

---
### Test Case: 9 — Large Values

Verifies operation on large numerical values.

```scilab
A = [1000 2000;
     3000 4000];

B = [1100 1900;
     3100 3900];

immse(A, B)
```

**Expected output:** `10000`

**Calculation:** 
```
[(100² + 100² + 100² + 100²)] / 4

= 40000/4

= 10000
```
---
### Test Case: 10 — Single Element

Verifies operation on scalar inputs.

```scilab
A = 5;
B = 10;

immse(A, B)
```

**Expected output:** `25`

**Calculation:** 
```
(5 − 10)² 

= 25
```

---
### Test Case: 11 — Floating-Point Precision Check

Verifies accurate computation for small floating-point differences.

```scilab
A = [0.1 0.2;
     0.3 0.4];

B = [0.1  0.25;
     0.35 0.45];

immse(A, B)
```

**Expected output:** `0.001875`

**Calculation:** 
```
[(0)² + (0.05)² + (0.05)² + (0.05)²] / 4

= (0 + 0.0025 + 0.0025 + 0.0025)/4

= 0.0075/4

= 0.001875
```
---
### Test Case: 12 — Large Random Matrix

Verifies operation on larger datasets.

```scilab
A = rand(50,50);
B = rand(50,50);

immse(A, B)
```

**Expected output:** `Positive floating-point value depending on the generated matrices.`

---
### Test Results

The file `immse_Test_Results.pdf` contains the results obtained from executing all test cases, including:

* Input matrices used for each test case.
* Computed Mean Squared Error (MSE) values.
* A summary table comparing the expected and obtained outputs.

---

## Compatibility Notes

This function is a Scilab implementation compatible with the behavior of GNU Octave's `immse` function.

### Important Notes

* Both inputs must have identical dimensions.
* Empty inputs are not allowed.
* Inputs are internally converted to double precision before computation.
* The function supports:
    * Binary images
    *  Grayscale images
    * RGB images
    * Numerical matrices
* The output is always a non-negative scalar value.
---

### Recommended Usage

```scilab
A = imread("original.jpg"); 
B = imread("processed.jpg"); 
mse = immse(A,B); 
disp(mse);
```
Smaller MSE values indicate greater similarity between the two images.

---

## References

[1] MATLAB Image Processing Toolbox Documentation

[2] GNU Octave Image Package Documentation

