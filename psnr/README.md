# psnr
## Description
- The psnr function computes the Peak Signal-to-Noise Ratio (PSNR) between two images or matrices, expressed in decibels (dB).
- The number of arguments passed must be 2 or 3.
- The inputs must have identical dimensions and are internally converted to double precision. Higher PSNR values indicate greater similarity between the two images.
## Calling Sequence
```
p = psnr(A, B)
p = psnr(A, B, peak)
```
## Dependencies
The function depends on the following external files, which must be loaded before `psnr.sci`:

| File | Purpose |
|--------|---------|
| `immse.sci` | Computes the Mean Squared Error (MSE) between two images or matrices. |
| `getrangefromclass.sci` | Determines the valid intensity range associated with an image datatype. |
## Parameters
`A` - Reference image or matrix.

`B` - Test image or matrix. Must have the same dimensions as `A`.

`peak` - (Optional, default `1`) Maximum possible signal value.

`p` - Output. Computed Peak Signal-to-Noise Ratio (PSNR) in decibels (dB).
# Examples
## 1 — Identical Images
      A = [10 20; 30 40];
      B = [10 20; 30 40];
      psnr(A,B)
##
      %inf
## 2 — All Zeros
      A = zeros(3,3);
      B = zeros(3,3);
      psnr(A,B)
##
      %inf
## 3 — Constant Matrices
      A = ones(3,3)*50;
      B = ones(3,3)*100;
      psnr(A,B)
##
      -33.979
## 4 — Negative Values
      A = [-1 -2; 3 4];
      B = [ 1 2; -3 -4];
      psnr(A,B)
##
      -14.771
## 5 — Floating Values
      A = [0.1 0.2; 0.3 0.4];
      B = [0.1 0.25; 0.35 0.45];
      psnr(A,B)
##
      27.27
## 6 — Single Element
      psnr(5,10)
##
      -13.979
## 7 — Random Matrix
      A = rand(3,3);
      B = rand(3,3);
      psnr(A,B)
##
      Positive finite value depending on the generated matrices.
## 8 — Custom Peak Value
      A = [10 20; 30 40];
      B = [12 18; 33 39];
      psnr(A,B,128)
##
      35.612
## 9 — High Dynamic Range Values
      A = [1000 2000; 3000 4000];
      B = [1100 1900; 3100 3900];
      psnr(A,B)
##
      -40
## 10 — Binary Image
      A = [0 1; 1 0];
      B = [1 0; 0 1];
      psnr(A,B)
##
      0
## 11 — Mixed Sign Values
      A = [-10 0; 10 20];
      B = [10 0; -10 -20];
      psnr(A,B)
##
      -27.782
## 12 — Large Random Matrix
      A = rand(50,50)*255;
      B = rand(50,50)*255;
      psnr(A,B)
##
      Finite PSNR value depending on the generated matrices.
