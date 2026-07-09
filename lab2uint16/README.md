# lab2uint16
## Description
- The lab2uint16 function converts a CIE L*a*b* image or colormap to the uint16 representation commonly used in image-processing applications.
- The number of arguments passed must be equal to 1.
- The function is a wrapper around `lab2cls`, requesting conversion of the input L*a*b* data to the `uint16` class, mapping the L*a*b* components into the valid range of unsigned 16-bit integers (0-65535).
## Calling Sequence
`lab_uint16 = lab2uint16(lab)`
## Dependencies
The function depends on the following external file, which must be loaded before `lab2uint16.sci`:

| File | Purpose |
|--------|---------|
| `lab2cls.sci` | Converts L*a*b* data to the specified output class. |
## Parameters
`lab` - An L*a*b* image or colormap.

`lab_uint16` - Output. The L*a*b* image or colormap converted to `uint16` representation.
# Examples
## 1 — Typical Lab* Image
      lab = cat(3, ...
      [50 75; 25 100], ...
      [0 20; -20 40], ...
      [0 -30; 30 60]);
      out = lab2uint16(lab)
##
      Returns a uint16 representation of the input L*a*b* image.
## 2 — Minimum Valid Lab* Values (uint8 Input)
      lab = uint8(cat(3, ...
                zeros(2,2), ...
                zeros(2,2), ...
                zeros(2,2)));
      out = lab2uint16(lab)
##
      Returns uint16 values corresponding to the minimum valid L*a*b* range.
## 3 — Maximum Valid Lab* Values (uint16 Input)
      lab = uint16(cat(3, ...
                 65280*ones(2,2), ...
                 65280*ones(2,2), ...
                 65280*ones(2,2)));
      out = lab2uint16(lab)
##
      Returns uint16 values corresponding to the maximum valid L*a*b* range.
## 4 — Single Pixel
      lab = cat(3, 50, 0, 0);
      out = lab2uint16(lab)
##
      Returns a single uint16 L*a*b* pixel.
## 5 — uint8 Input
      lab = uint8(cat(3, ...
      [0 128; 255 64], ...
      [128 128; 128 128], ...
      [128 128; 128 128]));
      out = lab2uint16(lab)
##
      Returns an equivalent uint16 L*a*b* image.
## 6 — uint16 Input
      lab = uint16(cat(3, ...
      [0 1000; 30000 65280], ...
      [0 1000; 30000 65280], ...
      [0 1000; 30000 65280]));
      out = lab2uint16(lab)
##
      Returns a uint16 L*a*b* image with preserved or equivalent values.
## 7 — Out-of-Range Values
      lab = cat(3, ...
      [-20 120; 200 -50], ...
      [-200 200; -150 150], ...
      [-200 200; -150 150]);
      out = lab2uint16(lab)
##
      Behavior depends on clipping and scaling rules implemented in lab2cls().
## 8 — NaN Values
      lab = cat(3, ...
      [%nan 50], ...
      [0 0], ...
      [0 0]);
      out = lab2uint16(lab)
##
      Behavior depends on NaN handling implemented in lab2cls().
## 9 — Invalid 2-D Input
      lab = [1 2; 3 4];
      out = lab2uint16(lab)
##
      Error : LAB must be Mx3, MxNx3, or MxNx3xK size.
## 10 — int16 Input (Unsupported Class)
      lab = int16(cat(3, ...
      [0 50], ...
      [0 0], ...
      [0 0]));
      out = lab2uint16(lab)
##
      Error : Invalid class for LAB.
