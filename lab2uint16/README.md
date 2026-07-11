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

## 1 — Typical LAB Image

      lab = cat(3, ...
      [50 75; 25 100], ...
      [0 20; -20 40], ...
      [0 -30; 30 60]);

      out = lab2uint16(lab)

##
      Input type:
      constant

      Output type:
      uint16

      Output:

      (:,:,1)

      32640   48960
      16320   65280

      (:,:,2)

      32768   37888
      27648   43008

      (:,:,3)

      32768   25088
      40448   48128

---

## 2 — Minimum Valid LAB Values

      lab = uint8(cat(3, ...
                zeros(2,2), ...
                zeros(2,2), ...
                zeros(2,2)));

      out = lab2uint16(lab)

##
      Input type:
      uint8

      Output type:
      uint16

      Output:

      (:,:,1)

      0   0
      0   0

      (:,:,2)

      0   0
      0   0

      (:,:,3)

      0   0
      0   0

---

## 3 — Maximum Valid LAB Values

      lab = uint16(cat(3, ...
                 65280*ones(2,2), ...
                 65280*ones(2,2), ...
                 65280*ones(2,2)));

      out = lab2uint16(lab)

##
      Input type:
      uint16

      Output type:
      uint16

      Output:

      (:,:,1)

      65280   65280
      65280   65280

      (:,:,2)

      65280   65280
      65280   65280

      (:,:,3)

      65280   65280
      65280   65280

---

## 4 — Single Pixel

      lab = cat(3,50,0,0);

      out = lab2uint16(lab)

##
      Input type:
      constant

      Output type:
      uint16

---

## 5 — uint8 Input

      lab = uint8(cat(3, ...
      [0 128; 255 64], ...
      [128 128; 128 128], ...
      [128 128; 128 128]));

      out = lab2uint16(lab)

##
      Input type:
      uint8

      Output type:
      uint16

      Output:

      (:,:,1)

      0       32768
      65280   16384

      (:,:,2)

      32768   32768
      32768   32768

      (:,:,3)

      32768   32768
      32768   32768

---

## 6 — uint16 Input

      lab = uint16(cat(3, ...
      [0 1000; 30000 65280], ...
      [0 1000; 30000 65280], ...
      [0 1000; 30000 65280]));

      out = lab2uint16(lab)

##
      Input type:
      uint16

      Output type:
      uint16

      Output:

      (:,:,1)

      0       1000
      30000   65280

      (:,:,2)

      0       1000
      30000   65280

      (:,:,3)

      0       1000
      30000   65280
      
---

## 7 — Out-of-Range Values

      lab = cat(3, ...
      [-20 120; 200 -50], ...
      [-200 200; -150 150], ...
      [-200 200; -150 150]);

      out = lab2uint16(lab)

##
      Input type:
      constant

      Output type:
      uint16

      Output:

      (:,:,1)

      0       65535
      65535   0

      (:,:,2)

      0       65535
      0       65535

      (:,:,3)

      0       65535
      0       65535

---

## 8 — NaN Values

      lab = cat(3, ...
      [%nan 50], ...
      [0 0], ...
      [0 0]);

      out = lab2uint16(lab)

##
      Input type:
      constant

      Output type:
      uint16

      Output:

      (:,:,1)

      65535   32640
      16320   65280

      (:,:,2)

      32768   37888
      65535   43008

      (:,:,3)

      32768   25088
      40448   65535

---

## 9 — Invalid 2-D Input

      lab = [1 2; 3 4];

      out = lab2uint16(lab)

##
      Input type:
      constant

      Error:

      lab2: LAB must be Mx3, MxNx3, or MxNx3xK size

---

## 10 — int16 Input (Unsupported Class)

      lab = int16(cat(3, ...
      [0 50], ...
      [0 0], ...
      [0 0]));

      out = lab2uint16(lab)

##
      Input type:
      int16

      Error:

      lab2uint16: invalid class for LAB
