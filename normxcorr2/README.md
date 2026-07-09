# normxcorr2
## Description
- The normxcorr2 function computes the normalized 2-D cross-correlation between a template `a` and an image `b`, producing a correlation map with values in `[-1, 1]`.
- The number of arguments passed must be equal to 2.
- Higher output values indicate greater similarity: `1` is a perfect match, `0` is no linear correlation, and negative values indicate inverse correlation. The output is larger than the input image, similar to `conv2(..., "full")`.
## Calling Sequence
`c = normxcorr2(a, b)`
## Dependencies
The function depends on the following external file, which must be loaded before `normxcorr2.sci`:

| File | Purpose |
|--------|---------|
| `postpad.sci` | Resizes an array by padding or truncating it along a specified dimension (default `0`). |
## Parameters
`a` - Template matrix (the pattern to search for). Must have no dimension larger than the corresponding dimension of `b`. Internally converted to `double`.

`b` - Image matrix (the signal to search within). Internally converted to `double`.

`c` - Output. Normalized cross-correlation map of size `(rows(b) + rows(a) - 1) × (cols(b) + cols(a) - 1)`. All values lie in `[-1, 1]`; positions with zero local variance in `b` are set to `0`.
# Examples
## 1 — Basic Matching Template
      A = [1 2;
           3 4];
      B = [0 0 0;
           1 2 0;
           3 4 0];
      C = normxcorr2(A, B)
##
      C =                          (4×4)
        -0.7746  -0.8944  -0.8944  -0.2582
         0.1861   0.9439   0.2582   0.4472
         0.7735   1.0000  -0.1348   0.4472
        -0.2582  -0.7679  -0.5698   0.7746
## 2 — Rectangular Template
      A = [1 2 3;
           4 5 6];
      B = [ 1  2  3  4;
            5  6  7  8;
            9 10 11 12];
      C = normxcorr2(A, B)
##
      C =                                           (4×6)
        -0.6547  -0.8014  -0.7667  -0.7282  -0.3719  -0.1309
        -0.0485   0.3107   0.9939   0.9939   0.8374   0.5797
         0.5797   0.8374   0.9939   0.9939   0.3107  -0.0485
        -0.1309  -0.3719  -0.7282  -0.7667  -0.8014  -0.6547
## 3 — Floating-Point Inputs
      A = [0.5 1.5;
           2.5 3.5];
      B = [1.1 2.2 3.3;
           4.4 5.5 6.6;
           7.7 8.8 9.9];
      C = normxcorr2(A, B)
##
      C =                          (4×4)
        -0.7746  -0.8141  -0.7746  -0.2582
         0.0682   0.9899   0.9899   0.7182
         0.7182   0.9899   0.9899   0.0682
        -0.2582  -0.7746  -0.8141  -0.7746
## 4 — Negative Values
      A = [-1 -2;
            3  4];
      B = [-4 -3 -2;
           -1  0  1;
            2  3  4];
      C = normxcorr2(A, B)
##
      C =                          (4×4)
        -0.6794  -0.9337  -0.9058  -0.4529
         0.5383   0.9303   0.9303   0.5399
         0.8099   0.9303   0.9303   0.3589
        -0.6794  -0.9813  -0.9886  -0.4529
## 5 — Single-Pixel Template
      A = [5];
      B = [1 2 3;
           4 5 6;
           7 8 9];
      C = normxcorr2(A, B)
##
      C =               (3×3)
         0   0   0
         0   0   0
         0   0   0
## 6 — Template Equals Image (Self-Correlation)
      A = [2 1;
           4 3];
      B = [2 1;
           4 3];
      C = normxcorr2(A, B)
##
      C =                          (3×3)
        -0.2582  -0.5477  -0.7746
         0.4472   1.0000   0.4472
        -0.7746  -0.5477  -0.2582
## 7 — Template Larger Than Image (Warning)
      A = [1 2 3;
           4 5 6;
           7 8 9];
      B = [1 2;
           3 4];
      C = normxcorr2(A, B)
##
      WARNING: normxcorr2: TEMPLATE larger than IMG. Arguments may be swapped.

      C =                                    (4×4)
        -0.5477  -0.5853  -0.4052  -0.2739
         0.0418   0.4041   0.4041   0.2923
         0.2923   0.4041   0.4041   0.0418
        -0.2739  -0.4052  -0.5853  -0.5477
## 8 — Constant Template (Zero Variance)
      A = ones(2,2);
      B = [1 2 3;
           4 5 6;
           7 8 9];
      C = normxcorr2(A, B)
##
      C =               (4×4)
         0   0   0   0
         0   0   0   0
         0   0   0   0
         0   0   0   0
## 9 — Larger Image with Repeated Pattern
      A = [1 2;
           3 4];
      B = [1 2 1 2;
           3 4 3 4;
           1 2 1 2;
           3 4 3 4];
      C = normxcorr2(A, B)
##
      C =                                           (5×5)
        -0.7746  -0.5477  -0.9129  -0.5477  -0.2582
         0.4472   1.0000   0.6000   1.0000   0.4472
        -0.7454  -0.6000  -1.0000  -0.6000  -0.7454
         0.4472   1.0000   0.6000   1.0000   0.4472
        -0.2582  -0.5477  -0.9129  -0.5477  -0.7746
## 10 — Invalid Number of Arguments
      try
          normxcorr2([1 2; 3 4]);
      catch
          disp(lasterror());
      end
##
      Error : normxcorr2: Wrong number of input arguments.
