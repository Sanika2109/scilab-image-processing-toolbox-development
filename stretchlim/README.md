# stretchlim
## Description
- The stretchlim function computes lower and upper intensity limits for an image, suitable for use as contrast-stretching limits with functions such as `imadjust`.
- The number of arguments passed must be 1 or 2.
- For each color channel (or plane), pixel values are sorted and two order statistics — by default the 1st and 99th percentiles — are selected as the low and high limits. The returned limits are always normalized to `[0, 1]`, regardless of the original image's numeric class.
## Calling Sequence
```
low_high = stretchlim(img)
low_high = stretchlim(img, tol)
```
## Dependencies
The function depends on the following external file, which must be loaded before `stretchlim.sci`:

| File | Purpose |
|--------|---------|
| `postpad.sci` | Resizes an array by padding or truncating it along a specified dimension (default `0`). |
## Parameters
`img` - A grayscale image (M×N), RGB image (M×N×3), or higher-dimensional image stack (M×N×P×...). Must satisfy `isimage()` — class `constant` (double), `boolean`, `uint8`, `uint16`, or `int16`, with no zero-length dimension.

`tol` - (Optional, default `[0.01 0.99]`) Either a scalar `t` in `[0, 0.5]`, interpreted as `[t, 1-t]`, or an explicit 2-element vector `[low_frac, high_frac]` in `[0, 1]` with `low_frac ≤ high_frac`.

`low_high` - Output. A `2 × C` matrix, where `C` is the number of planes/channels in `img`. Row 1 holds the low limit and row 2 holds the high limit for each channel, both normalized to `[0, 1]`.
# Examples
## 1 — uint8 Ramp, Default Tolerance
      I = uint8(0:255);
      low_high = stretchlim(I)
##
      low_high =
         0.0078
         0.9922
## 2 — Scalar Tolerance 0.05
      I = uint8(0:255);
      low_high = stretchlim(I, 0.05)
##
      low_high =
         0.0471
         0.9529
## 3 — Custom Tolerance [0.20 0.80] on a Four-Block Image
      I = uint8([
           10 * ones(10,10), ...
          100 * ones(10,10), ...
          200 * ones(10,10), ...
          250 * ones(10,10)
      ]);
      low_high = stretchlim(I, [0.20 0.80])
##
      low_high =
         0.0392
         0.9804
## 4 — Constant uint8 Image
      I = uint8(100 * ones(20,20));
      low_high = stretchlim(I)
##
      low_high =
         0
         1
## 5 — Double-Precision Image with Four Intensity Blocks
      I = [
          0.10 * ones(10,10), ...
          0.40 * ones(10,10), ...
          0.70 * ones(10,10), ...
          0.95 * ones(10,10)
      ];
      low_high = stretchlim(I)
##
      low_high =
         0.10
         0.95
## 6 — Skewed Histogram with Unequal Block Widths
      I = uint8([
           20 * ones(20,5), ...
           80 * ones(20,15), ...
          180 * ones(20,20), ...
          240 * ones(20,10)
      ]);
      low_high = stretchlim(I)
##
      low_high =
         0.0784
         0.9412
## 7 — uint16 Full-Range Image
      I = matrix(uint16(0:65535), 256, 256);
      low_high = stretchlim(I)
##
      low_high =
         0.0100
         0.9900
## 8 — int16 Image with Four Intensity Regions
      I = int16([
         -25000 * ones(20,5), ...
         -5000  * ones(20,15), ...
          5000  * ones(20,20), ...
          25000 * ones(20,10)
      ]);
      low_high = stretchlim(I)
##
      low_high =
         0.1185
         0.8815
## 9 — RGB Image with Distinct Per-Channel Distributions
      I = zeros(16,16,3,"uint8");
      I(:,:,1) = matrix(uint8(0:255), 16, 16);
      I(:,:,2) = matrix(uint8(255:-1:0), 16, 16);
      I(:,:,3) = uint8(128 * ones(16,16));
      low_high = stretchlim(I)
##
      low_high =
         0.0078   0.0078   0
         0.9922   0.9922   1
## 10 — Invalid Tolerance (TOL(1) > TOL(2))
      try
          stretchlim(uint8(0:255), [0.8 0.2]);
      catch
          disp(lasterror());
      end
##
      Error : stretchlim: TOL(1) must not exceed TOL(2)
