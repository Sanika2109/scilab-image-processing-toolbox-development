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
# Examples

## 1 — Typical uint8 LAB Image

      lab = uint8(cat(3, ...
      [0 128; 255 64], ...
      [128 148; 108 168], ...
      [128 98; 158 188]));

      out = lab2double(lab)

##
      Input type:
      uint8

      Output type:
      constant

      Output size:
      2149   3224   3

      Returns a double-precision L*a*b* image with dimensions preserved.
```

## 2 — Minimum uint8 Values

      lab = uint8(zeros(2,2,3));

      out = lab2double(lab)

##
      Input type:
      uint8

      Output type:
      constant

      Output:

      (:,:,1)

      0   0
      0   0

      (:,:,2)

      -128   -128
      -128   -128

      (:,:,3)

      -128   -128
      -128   -128
```

## 3 — Maximum uint8 Values

      lab = uint8(255 * ones(2,2,3));

      out = lab2double(lab)

##
      Input type:
      uint8

      Output type:
      constant

      Output:

      (:,:,1)

      100   100
      100   100

      (:,:,2)

      127   127
      127   127

      (:,:,3)

      127   127
      127   127
```

## 4 — Typical uint8 LAB Image

      lab = uint8(cat(3, ...
      [0 128; 200 64], ...
      [128 148; 108 168], ...
      [128 98; 158 188]));

      out = lab2double(lab)

##
      Input type:
      uint8

      Output type:
      constant

      Output:

      (:,:,1)

      0        50.196078
      100      25.098039

      (:,:,2)

      0        20
      -20      40

      (:,:,3)

      0        -30
      30       60
```

## 5 — uint16 LAB Image

      lab = uint16(cat(3, ...
      [0 32640; 65280 16320], ...
      [32640 40000; 20000 50000], ...
      [32640 30000; 45000 60000]));

      out = lab2double(lab)

##
      Input type:
      uint16

      Output type:
      constant

      Output:

      (:,:,1)

      0        50
      100      25

      (:,:,2)

      -0.5       28.25
      -49.875    67.3125

      (:,:,3)

      -0.5       -10.8125
      47.78125   106.375
```

## 6 — Minimum uint16 Values

      lab = uint16(zeros(2,2,3));

      out = lab2double(lab)

##
      Input type:
      uint16

      Output type:
      constant

      Output:

      (:,:,1)

      0   0
      0   0

      (:,:,2)

      -128   -128
      -128   -128

      (:,:,3)

      -128   -128
      -128   -128
```

## 7 — Maximum uint16 Values

      lab = uint16(65280 * ones(2,2,3));

      out = lab2double(lab)

##
      Input type:
      uint16

      Output type:
      constant

      Output:

      (:,:,1)

      100   100
      100   100

      (:,:,2)

      127   127
      127   127

      (:,:,3)

      127   127
      127   127
```

## 8 — Double Input (Pass-through)

      lab = cat(3, ...
      [50 75; 25 100], ...
      [0 20; -20 40], ...
      [0 -30; 30 60]);

      out = lab2double(lab)

##
      Input type:
      constant

      Output type:
      constant

      Output:

      (:,:,1)

      50   75
      25   100

      (:,:,2)

      0    20
      -20  40

      (:,:,3)

      0    -30
      30   60

```

## 9 — M×3 LAB Colormap

      lab = [
          0    -128  -128;
          50      0     0;
          100    127   127
      ];

      out = lab2double(lab)

##
      Input type:
      constant

      Output type:
      constant

      Output:

      0      -128     -128
      50       0        0
      100      127      127
```

## 10 — Invalid 2-D Input

      lab = uint8([1 2; 3 4]);

      out = lab2double(lab)

##
      Error:

      lab2: LAB must be Mx3, MxNx3, or MxNx3xK size
```

## 11 — int16 Input (Unsupported Class)

      lab = int16(cat(3, ...
      [0 50], ...
      [0 0], ...
      [0 0]));

      out = lab2double(lab)

##
      Input type:
      int16

      Error:

      lab2: invalid class for LAB
