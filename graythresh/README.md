# graythresh
## Description
- The graythresh function computes a global intensity threshold for a binary image, using one of eleven selectable thresholding algorithms.
- The number of arguments passed must be 1 or 2 (3 only when `algo = "percentile"`).
- The input can be a 2-D grayscale image, an M×N×3 RGB image (auto-converted via `rgb2gray`), or a non-negative real vector treated directly as a histogram.
## Calling Sequence
```
level = graythresh(img)
level = graythresh(img, algo)
level = graythresh(img, "percentile", p)
[level, sep] = graythresh(img, "otsu")
```
## Dependencies

The function depends on the following external files, which must be loaded before `graythresh.sci`:

| File | Purpose |
|------|---------|
| `rgb2gray.sci` | Converts an RGB image to a grayscale image. |
| `im2double.sci` | Converts image data to double precision for processing. |
| `isa.sci` | Checks whether an input belongs to a specified datatype or class. |
| `im2uint16.sci` | Converts an image to the `uint16` datatype. |
| `im2uint8.sci` | Converts an image to the `uint8` datatype. |
| `intmax.sci` | Returns the maximum representable value for an integer datatype. |

## Parameters
`img` - A 2-D grayscale image, an M×N×3 RGB image, or a non-negative real vector treated as a histogram.

`algo` - (Optional, default `"otsu"`) A string, case-insensitive. One of `"concavity"`, `"intermeans"`, `"intermodes"`, `"maxentropy"`, `"maxlikelihood"`, `"mean"`, `"minerror"`, `"minimum"`, `"moments"`, `"otsu"`, `"percentile"`.

`p` - (Optional, only valid when `algo = "percentile"`, default `0.5`) Target cumulative fraction.

`level` - Output. Computed threshold, normalized to `[0, 1]`.

`sep` - Output (`"otsu"` only, second return value). Separability/quality measure in `[0, 1]`.

# Examples

Before running the examples that use randomly generated data, initialize the random number generators to obtain reproducible results.

      grand("setsd", 123456789);
      rand("seed", 123456789);

## 1 — Otsu Thresholding on Bimodal Image
      img = uint8([zeros(50,50) 255*ones(50,50)]);
      [level, goodness] = graythresh(img)
##
      level = 0.4980392
      goodness = 1.

## 2 — Mean Thresholding
      img = uint8([
          grand(100,1,"uin",20,80);
          grand(100,1,"uin",180,240)
      ]);
      out = graythresh(img, "mean")
##
      0.5114902

## 3 — Intermeans Thresholding
      img = uint8([
          grand(100,1,"uin",20,70);
          grand(100,1,"uin",180,230)
      ]);
      out = graythresh(img, "intermeans")
##
      0.4862745

## 4 — Intermodes Thresholding
      img = uint8([
          10 + grand(100,1,"uin",0,5);
          245 + grand(100,1,"uin",0,5)
      ]);
      out = graythresh(img, "intermodes")
##
       0.5098039

## 5 — Maximum Entropy Thresholding
      img = uint8([
          30 + grand(100,1,"uin",0,20);
          200 + grand(100,1,"uin",0,20)
      ]);
      out = graythresh(img, "maxentropy")
##
      0.1960784

## 6 — Maximum Likelihood Thresholding
      img = uint8([
          40 + grand(100,1,"uin",0,20);
          200 + grand(100,1,"uin",0,20)
      ]);
      out = graythresh(img, "maxlikelihood")
##
      0.5098039

## 7 — Minimum Method
      img = uint8([
          50 + grand(100,1,"uin",0,10);
          220 + grand(100,1,"uin",0,10)
      ]);
      out = graythresh(img, "minimum")
##
      0.2470588

## 8 — Minimum Error Thresholding
      img = uint8([
          30 + grand(100,1,"uin",0,15);
          210 + grand(100,1,"uin",0,15)
      ]);
      out = graythresh(img, "minerror")
##
      0.5058824

## 9 — Moments Thresholding
      img = uint8(grand(128,128,"uin",0,255));
      out = graythresh(img, "moments")
##
      0.4941176

## 10 — Concavity Thresholding
      img = uint8([
          20 + grand(120,1,"uin",0,25);
          120 + grand(120,1,"uin",0,40);
          220 + grand(120,1,"uin",0,15)
      ]);
      out = graythresh(img, "concavity")
##
      0.5490196

## 11 — Percentile Thresholding (p = 0.5)
      img = uint8([
          grand(150,1,"uin",10,80);
          grand(150,1,"uin",180,240)
      ]);
      out = graythresh(img, "percentile", 0.5)
##
      0.3137255

## 12 — Percentile Thresholding (p = 0.25)
      img = uint8([
          grand(200,1,"uin",10,60);
          grand(100,1,"uin",180,240)
      ]);
      out = graythresh(img, "percentile", 0.25)
##
      0.1215686

## 13 — Percentile Thresholding (p = 0.75)
      img = uint8([
          grand(300,1,"uin",10,80);
          grand(100,1,"uin",180,240)
      ]);
      out = graythresh(img, "percentile", 0.75)
##
      0.3137255

## 14 — Histogram Input
      histogram = [10 20 50 100 50 20 10];
      out = graythresh(histogram, "otsu")
##
      0.4166667

## 15 — Single-Bin Histogram
      histogram = 100;
      out = graythresh(histogram, "otsu")
##
      0.

## 16 — RGB Image Input
      rgb(:,:,1) = uint8([255*ones(50,25) 50*ones(50,25)]);
      rgb(:,:,2) = uint8([100*ones(50,25) 200*ones(50,25)]);
      rgb(:,:,3) = uint8([0*ones(50,25) 150*ones(50,25)]);
      out = graythresh(rgb, "otsu")
##
      0.5

## 17 — uint16 Image Input
      img = uint16([zeros(50,50) 65535*ones(50,50)]);
      out = graythresh(img)
##
      0.4999924

## 18 — Double Precision Image
      img = rand(100,100);
      out = graythresh(img)
##
      0.4941176
