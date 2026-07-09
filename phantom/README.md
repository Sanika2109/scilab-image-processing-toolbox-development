# phantom
## Description
- Generates a standard **Shepp-Logan head phantom**, commonly used for testing image reconstruction and tomography algorithms (e.g., CT and MRI).
- Accepts **0, 1, or 2 input arguments**.
- The phantom is created by summing ellipses defined by their intensity, size, position, and rotation. The ellipse set can be a built-in model (`"shepp-logan"` or `"modified shepp-logan"`), a user-defined **N×6** ellipse matrix, or omitted (defaults to the modified Shepp-Logan model).
- The output image size defaults to **256 × 256** but can be specified by the user.
- If the first argument is `n`, no second argument is allowed. If the first argument is `model` or `E`, the optional second argument must be `n`.
## Calling Sequence
```
head             = phantom()
head             = phantom(model)
head             = phantom(E)
head             = phantom(n)
head             = phantom(model, n)
head             = phantom(E, n)
[head, ellipses] = phantom(...)
```
## Parameters
`model` - (Optional) A string, `"shepp-logan"` (classic, high-contrast) or `"modified shepp-logan"` (default, softer contrast). Case-insensitive.

`E` - (Optional) Custom ellipse matrix, N×6, one row per ellipse: `[I  a  b  x0  y0  phi]`.

`n` - (Optional, default `256`) Output image size; produces an n×n image. May be given alone, or as the second argument after `model`/`E`.

`head` - Output. The generated n×n phantom image.

`ellipses` - Output. The N×6 ellipse matrix actually used to build `head` — either the resolved named model or the user-supplied `E`.

### Ellipse Matrix Columns
| Column | Symbol | Meaning |
| :---: | :---: | --- |
| 1 | `I` | Intensity added within the ellipse. |
| 2 | `a` | Semi-axis length along the ellipse's unrotated x-direction, in normalized coordinates `[-1, 1]`. |
| 3 | `b` | Semi-axis length along the unrotated y-direction. |
| 4 | `x0` | Horizontal center offset. |
| 5 | `y0` | Vertical center offset. |
| 6 | `phi` | Rotation angle in degrees, counter-clockwise from horizontal. |
# Examples
## 1 — Default Phantom
      [head,E] = phantom()
##
      Image Size: 256   256
      Image Sum:  ≈ 8044.0
      Mean Intensity: ≈ 0.1227
      E = the built-in 10x6 modified Shepp-Logan ellipse matrix
## 2 — Small Image (N = 8)
      head = phantom(8)
##
      Image Size: 8   8
      Image Sum:  7.6

      0     0     0     0     0     0     0     0
      0     0     1     0.2   0.2   1     0     0
      0     0     0.2   0.3   0.3   0.2   0     0
      0     0     0.2   0     0.2   0.2   0     0
      0     0     0.2   0     0     0.2   0     0
      0     0     0.2   0.2   0.2   0.2   0     0
      0     0     1     0.2   0.2   1     0     0
      0     0     0     0     0     0     0     0
## 3 — 90 Degree Rotation
      E = [1 0.55 0.20 0 0 90];
      [head,ell] = phantom(E,128)
##
      Image Size: 128   128
      Image Sum: 1400
      Center Pixel (64,64): 1
      Non-zero Pixels: 1400
## 4 — Shepp-Logan Phantom
      [head,E] = phantom("shepp-logan")
##
      Image Size: 256   256
      Minimum Intensity: 0
      Maximum Intensity: 1
      E = the built-in 10x6 classic Shepp-Logan ellipse matrix
## 5 — Negative Intensity Ellipse
      E = [-0.8 0.40 0.30 0 0 0];
      [head,ell] = phantom(E,128)
##
      Image Size: 128   128
      Minimum Intensity: -0.8
      Maximum Intensity: 0
      Image Sum: -1212.8
## 6 — Ellipse Partially Outside Image
      E = [1 0.40 0.30 0.80 0 0];
      [head,ell] = phantom(E,128)
##
      Image Size: 128   128
      Image Sum: 1240
      Non-zero Pixels: 1240
## 7 — Rotated and Shifted Ellipses
      E = [ 1.0  0.35 0.15 -0.30  0.20  30;
           -0.5  0.20 0.10  0.30 -0.20 -45];
      [head,ell] = phantom(E,256)
##
      Image Size: 256   256
      Image Sum: 2169
      Center Pixel (128,128): 0
## 8 — Overlapping Ellipses
      E = [1.0 0.40 0.40 0 0 0;
           0.7 0.40 0.40 0 0 0];
      [head,ell] = phantom(E,101)
##
      Image Size: 101   101
      Maximum Intensity: 1.7
      Non-zero Pixels: 1255
      Image Sum: 2133.5
## 9 — Ellipses Completely Outside Image
      E = [1.0 0.20 0.20 3 3 0];
      [head,ell] = phantom(E,128)
##
      Image Size: 128   128
      Image Sum: 0
      Non-zero Pixels: 0
## 10 — Invalid Model
      phantom("brain")
##
      Error : phantom: unknown MODEL
## 11 — Invalid Ellipse Matrix
      phantom(rand(4,5))
##
      Error : phantom: first argument must either be MODEL, E, or N
## 12 — Invalid Numeric Input
      phantom(64.5)
##
      Error : phantom: first argument must either be MODEL, E, or N
## 13 — Invalid Second Argument
      phantom("shepp-logan","abc")
##
      Error : phantom: N must be numeric scalar
## 14 — Too Many Inputs
      phantom(64,64,64)
##
      Error : phantom: Wrong number of input arguments.
