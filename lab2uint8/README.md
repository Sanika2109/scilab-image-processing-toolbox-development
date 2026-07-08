# lab2uint8
## Description
- The lab2uint8 function converts a CIE L*a*b* image or colormap to the uint8 representation commonly used in image-processing applications.
- The number of arguments passed must be equal to 1.
- The function is a wrapper around `lab2cls`, requesting conversion of the input L*a*b* data to the `uint8` class, mapping the L*a*b* components into the valid range of unsigned 8-bit integers (0-255).
## Calling Sequence
`lab_uint8 = lab2uint8(lab)`
## Dependencies
The function depends on the following external file, which must be loaded before `lab2uint8.sci`:

| File | Purpose |
|--------|---------|
| `lab2cls.sci` | Converts L*a*b* data to the specified output class. |
## Parameters
`lab` - An L*a*b* image or colormap represented as a numeric matrix or multidimensional array.

`lab_uint8` - Output. The L*a*b* image or colormap converted to `uint8` representation.
# Examples
## 1 — Real LAB Image from RGB
      rgb = DogImg;
      lab = rgb2lab(rgb);
      out = lab2uint8(lab)
##
      Returns a valid uint8 LAB image output with same dimensions as input.
## 2 — Minimum Valid LAB (double)
      lab = cat(3, ...
                zeros(2,2), ...
                -128*ones(2,2), ...
                -128*ones(2,2));
      out = lab2uint8(lab)
##
      Proper conversion with clamping/scaling of minimum LAB values.
## 3 — Maximum Valid LAB (double)
      lab = cat(3, ...
                100*ones(2,2), ...
                127*ones(2,2), ...
                127*ones(2,2));
      out = lab2uint8(lab)
##
      Proper conversion of maximum LAB values into the uint8 range.
## 4 — Typical LAB Values (double)
      lab = cat(3, ...
                [50 75;25 100], ...
                [0 20;-20 40], ...
                [0 -30;30 60]);
      out = lab2uint8(lab)
##
      Correct uint8 representation of typical LAB values.
## 5 — NaN Handling
      lab = cat(3, ...
                [%nan 50;25 100], ...
                [0 20;%nan 40], ...
                [0 -30;30 %nan]);
      out = lab2uint8(lab)
##
      NaN values handled via clipping rules defined in lab2cls().
## 6 — Clipping Behavior (Out-of-Range Double)
      lab = cat(3, ...
                [-20 50;120 200], ...
                [-200 0;100 300], ...
                [-300 0;100 400]);
      out = lab2uint8(lab)
##
      Values clipped to valid LAB range before conversion.
## 7 — uint8 Encoded LAB Input
      lab = cat(3, ...
                uint8([0 128;200 255]), ...
                uint8([0 128;200 255]), ...
                uint8([0 128;200 255]));
      out = lab2uint8(lab)
##
      Correct conversion of uint8-encoded LAB image.
## 8 — uint16 Encoded LAB Input
      lab = cat(3, ...
                uint16([0 32768;49152 65280]), ...
                uint16([0 32768;49152 65280]), ...
                uint16([0 32768;49152 65280]));
      out = lab2uint8(lab)
##
      Proper scaling and conversion of uint16 LAB input.
## 9 — Empty Input (Invalid Input)
      lab = [];
      out = lab2uint8(lab)
##
      Error : LAB must be Mx3, MxNx3, or MxNx3xK size.
## 10 — Invalid Dimensions (Invalid Input)
      lab = uint8([50 60;70 80]);
      out = lab2uint8(lab)
##
      Error : LAB must be Mx3, MxNx3, or MxNx3xK size.
