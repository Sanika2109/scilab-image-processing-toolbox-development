# lab2double
## Description
- The lab2double function converts a CIE L*a*b* image or colormap to the double representation commonly used in image-processing applications.
- The number of arguments passed must be equal to 1.
- The function is a wrapper around `lab2cls`, requesting conversion of the input L*a*b* data to the `double` class.
## Calling Sequence
`lab_double = lab2double(lab)`
## Dependencies
The function depends on the following external file, which must be loaded before `lab2double.sci`:

| File | Purpose |
|--------|---------|
| `lab2cls.sci` | Converts L*a*b* data to the specified output class. |
## Parameters
`lab` - An L*a*b* image (M×N×3) or colormap (M×3). May be `uint8`, `uint16`, or `double`.

`lab_double` - Output. The L*a*b* image or colormap converted to `double` representation.
# Examples
## 1 — Typical uint8 LAB Image
      lab = uint8(cat(3, ...
      [0 128; 255 64], ...
      [128 148; 108 168], ...
      [128 98; 158 188]));
      out = lab2double(lab)
##
      Returns a double-precision L*a*b* image.
## 2 — Minimum uint8 Values
      lab = uint8(zeros(2,2,3));
      out = lab2double(lab)
##
      Returns double values corresponding to the minimum uint8 encoding.
## 3 — Maximum uint8 Values
      lab = uint8(255 * ones(2,2,3));
      out = lab2double(lab)
##
      Returns double values corresponding to the maximum uint8 encoding.
## 4 — Typical uint16 LAB Image
      lab = uint16(cat(3, ...
      [0 32640; 65280 16320], ...
      [32640 40000; 20000 50000], ...
      [32640 30000; 45000 60000]));
      out = lab2double(lab)
##
      Returns a double-precision L*a*b* image.
## 5 — Minimum uint16 Values
      lab = uint16(zeros(2,2,3));
      out = lab2double(lab)
##
      Returns double values corresponding to the minimum uint16 encoding.
## 6 — Maximum uint16 Values
      lab = uint16(65280 * ones(2,2,3));
      out = lab2double(lab)
##
      Returns double values corresponding to the maximum uint16 encoding.
## 7 — Double Input (Pass-through)
      lab = cat(3, ...
      [50 75; 25 100], ...
      [0 20; -20 40], ...
      [0 -30; 30 60]);
      out = lab2double(lab)
##
      Returns a double image with equivalent L*a*b* values.
## 8 — Single Pixel
      lab = cat(3, 50, 0, 0);
      out = lab2double(lab)
##
      Returns a single double-precision L*a*b* pixel.
## 9 — M×3 Colormap
      lab = [...
          0    -128  -128;
          50      0     0;
          100    127   127];
      out = lab2double(lab)
##
      Returns a double-precision L*a*b* colormap.
## 10 — Invalid 2-D Input
      lab = uint8([1 2; 3 4]);
      out = lab2double(lab)
##
      Error : LAB must be Mx3, MxNx3, or MxNx3xK size.
## 11 — int16 Input (Unsupported Class)
      lab = int16(cat(3, ...
      [0 50], ...
      [0 0], ...
      [0 0]));
      out = lab2double(lab)
##
      Error : Invalid class int16 for LAB.
