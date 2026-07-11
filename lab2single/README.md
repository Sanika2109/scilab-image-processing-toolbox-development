# lab2single
## Description
- The lab2single function converts a CIE L*a*b* image or colormap to a floating-point representation.
- The number of arguments passed must be equal to 1.
- The function is a wrapper around `lab2cls`, requesting conversion of the input L*a*b* data to the `single` class. Since Scilab does not provide a native `single` datatype, the converted data is returned as a Scilab `constant` (double-precision matrix).
- Supports L*a*b* data stored as M×3 colormaps, M×N×3 images, or M×N×3×K image stacks, encoded as `uint8`, `uint16`, or floating-point (`constant`) values.
## Calling Sequence
`lab_single = lab2single(lab)`
## Dependencies
The function depends on the following external file, which must be loaded before `lab2single.sci`:

| File | Purpose |
|--------|---------|
| `lab2cls.sci` | Converts L*a*b* data to the specified output class. |

## Parameters
`lab` - An L*a*b* image, colormap, or image stack (M×3, M×N×3, or M×N×3×K). May be `uint8`, `uint16`, or `constant` (double).

`lab_single` - Output. Floating-point representation of the L*a*b* data, returned as a Scilab `constant` matrix.

# Examples

## 1 — Real LAB Image from rgb2lab
      rgb = imread("dog.jpg");
      lab = rgb2lab(rgb);
      out = lab2single(lab);

      typeof(lab)
      typeof(out)
      size(out)
##
      uint8
      constant
      2149   3224   3

## 2 — uint8 LAB Colormap
      lab = uint8([
          255 128 128;
          0   128 128
      ]);
      out = lab2single(lab)
##
      Input type:
      uint8

      Output type:
      constant

      100   0   0
        0   0   0

## 3 — uint16 LAB Colormap
      lab = uint16([
          65280 32768 32768;
          0     32768 32768
      ]);
      out = lab2single(lab)
##
      Input type:
      uint16

      Output type:
      constant

      100   0   0
        0   0   0

## 4 — Double LAB Colormap
      lab = [
          50 10 -10;
          75 20 30
      ];
      out = lab2single(lab)
##
      Input type:
      constant

      Output type:
      constant

      50   10  -10
      75   20   30

## 5 — uint8 M×N×3 LAB Image
      lab = cat(3, ...
                uint8([0 128;255 64]), ...
                uint8([128 138;148 158]), ...
                uint8([128 118;168 108]));
      out = lab2single(lab)
##
      Input type:
      uint8

      Output type:
      constant

      (:,:,1)

         0.000000   50.196078
       100.000000   25.098039

      (:,:,2)

         0.   10.
        20.   30.

      (:,:,3)

         0.  -10.
        40.  -20.

## 6 — uint16 M×N×3 LAB Image
      lab = cat(3, ...
                uint16([0 32640;65280 16320]), ...
                uint16([32640 40000;20000 50000]), ...
                uint16([32640 30000;45000 60000]));
      out = lab2single(lab)
##
      Input type:
      uint16

      Output type:
      constant

      (:,:,1)

         0.    50.
       100.    25.

      (:,:,2)

        -0.5      28.25
       -49.875    67.3125

      (:,:,3)

        -0.5      -10.8125
        47.78125  106.375

## 7 — 4-D LAB Image (Batch Processing)
      lab = rand(2,2,3,2);
      lab(:,:,1,:) = lab(:,:,1,:) * 100;
      lab(:,:,2,:) = lab(:,:,2,:) * 255 - 128;
      lab(:,:,3,:) = lab(:,:,3,:) * 255 - 128;
      out = lab2single(lab);

      size(lab)
      size(out)
##
      Input type:
      constant

      Output type:
      constant

      Input size:
      2   2   3   2

      Output size:
      2   2   3   2

## 8 — Invalid Dimensions
      lab = rand(3,4);
      out = lab2single(lab)
##
      Input type:
      constant

      Error:
      lab2: LAB must be Mx3, MxNx3, or MxNx3xK size

## 9 — Invalid Input Type
      lab = "hello";
      out = lab2single(lab)
##
      Input type:
      string

      Error:
      lab2: LAB must be Mx3, MxNx3, or MxNx3xK size

## 10 — NaN and Inf Handling
      lab = cat(3, ...
                [%nan 50; %inf -50], ...
                [0 -%inf; %nan 40], ...
                [0 30; -30 %inf]);
      out = lab2single(lab)
##
      Input type:
      constant

      Output type:
      constant

      Input:

      (:,:,1)

         Nan   50.
         Inf  -50.

      (:,:,2)

         0.   -Inf
         Nan   40.

      (:,:,3)

         0.    30.
       -30.    Inf

      Output:

      (:,:,1)

         Nan   50.
         Inf  -50.

      (:,:,2)

         0.   -Inf
         Nan   40.

      (:,:,3)

         0.    30.
       -30.    Inf
