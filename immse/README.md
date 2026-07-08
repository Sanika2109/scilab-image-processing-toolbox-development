# immse
## Description
- The immse function computes the Mean Squared Error (MSE) between two images or matrices of identical dimensions.
- The number of arguments passed must be equal to 2.
- The inputs must have identical dimensions and are internally converted to double precision before computation.
## Calling Sequence
`mse = immse(A, B)`
## Parameters
`A` - First image or matrix.

`B` - Second image or matrix. Must have the same dimensions as `A`.

`mse` - Output. Mean Squared Error between `A` and `B`.
# Examples
## 1 — Identical Images
      A = [5 5;
           5 5];
      immse(A, A)
##
      0
## 2 — Small Difference
      A = [5 5;
           5 5];
      B = [4 6;
           5 5];
      immse(A, B)
##
      0.5
## 3 — Large Difference
      A = [5 5;
           5 5];
      B = zeros(2,2);
      immse(A, B)
##
      25
## 4 — Floating-Point Inputs
      A = rand(4,4);
      B = rand(4,4);
      immse(A, B)
##
      Positive floating-point value depending on the generated matrices.
## 5 — Negative Values
      A = [-1 -2;
            3  4];
      B = [ 1  2;
           -3 -4];
      immse(A, B)
##
      30
## 6 — Size Mismatch (Invalid Input)
      immse([1 2], [1 2 3])
##
      Error : Input images must have the same dimensions.
## 7 — Zero Images
      A = zeros(3,3);
      B = zeros(3,3);
      immse(A, B)
##
      0
## 8 — One Zero Image and One Non-Zero Image
      A = zeros(3,3);
      B = ones(3,3) * 10;
      immse(A, B)
##
      100
## 9 — Large Values
      A = [1000 2000;
           3000 4000];
      B = [1100 1900;
           3100 3900];
      immse(A, B)
##
      10000
## 10 — Single Element
      A = 5;
      B = 10;
      immse(A, B)
##
      25
## 11 — Floating-Point Precision Check
      A = [0.1 0.2;
           0.3 0.4];
      B = [0.1  0.25;
           0.35 0.45];
      immse(A, B)
##
      0.001875
## 12 — Large Random Matrix
      A = rand(50,50);
      B = rand(50,50);
      immse(A, B)
##
      Positive floating-point value depending on the generated matrices.
