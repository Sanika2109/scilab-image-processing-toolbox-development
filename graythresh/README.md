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
The function depends on the following external file, which must be loaded before `graythresh.sci`:

| File | Purpose |
|--------|---------|
| `intmax.sci` | Returns the maximum representable value for an integer datatype. |
## Parameters
`img` - A 2-D grayscale image, an M×N×3 RGB image, or a non-negative real vector treated as a histogram.

`algo` - (Optional, default `"otsu"`) A string, case-insensitive. One of `"concavity"`, `"intermeans"`, `"intermodes"`, `"maxentropy"`, `"maxlikelihood"`, `"mean"`, `"minerror"`, `"minimum"`, `"moments"`, `"otsu"`, `"percentile"`.

`p` - (Optional, only valid when `algo = "percentile"`, default `0.5`) Target cumulative fraction.

`level` - Output. Computed threshold, normalized to `[0, 1]`.

`sep` - Output (`"otsu"` only, second return value). Separability/quality measure in `[0, 1]`.
# Examples
## 1 — Otsu Thresholding on Bimodal Image
      img = uint8([zeros(50,50) 255*ones(50,50)]);
      [level, goodness] = graythresh(img)
##
      Threshold lies near the midpoint of the intensity range.
      Goodness metric is close to 1, since the two classes are perfectly separated.
## 2 — Mean Thresholding
      img = uint8([
          grand(100,1,"uin",20,80);
          grand(100,1,"uin",180,240)
      ]);
      out = graythresh(img, "mean")
##
      Threshold approximately equals the mean image intensity, falling between the two intensity clusters.
## 3 — Intermeans Thresholding
      img = uint8([
          grand(100,1,"uin",20,70);
          grand(100,1,"uin",180,230)
      ]);
      out = graythresh(img, "intermeans")
##
      Iterative process converges; threshold lies between the two modes.
## 4 — Intermodes Thresholding
      img = uint8([
          10 + grand(100,1,"uin",0,5);
          245 + grand(100,1,"uin",0,5)
      ]);
      out = graythresh(img, "intermodes")
##
      Histogram is smoothed until two modes remain; threshold is located between the modes.
## 5 — Maximum Entropy Thresholding
      img = uint8([
          30 + grand(100,1,"uin",0,20);
          200 + grand(100,1,"uin",0,20)
      ]);
      out = graythresh(img, "maxentropy")
##
      Threshold maximizes information content; value lies between the two classes.
## 6 — Maximum Likelihood Thresholding
      img = uint8([
          40 + grand(100,1,"uin",0,20);
          200 + grand(100,1,"uin",0,20)
      ]);
      out = graythresh(img, "maxlikelihood")
##
      Threshold separates two statistically distinct populations; a convergent solution is obtained.
## 7 — Minimum Method
      img = uint8([
          50 + grand(100,1,"uin",0,10);
          220 + grand(100,1,"uin",0,10)
      ]);
      out = graythresh(img, "minimum")
##
      Threshold lies at the minimum between two peaks; histogram smoothing converges successfully.
## 8 — Minimum Error Thresholding
      img = uint8([
          30 + grand(100,1,"uin",0,15);
          210 + grand(100,1,"uin",0,15)
      ]);
      out = graythresh(img, "minerror")
##
      Threshold minimizes expected misclassification, falling between the two intensity groups.
## 9 — Moments Thresholding
      img = uint8(grand(128,128,"uin",0,255));
      out = graythresh(img, "moments")
##
      Threshold preserves selected histogram moments; a valid normalized threshold is returned.
## 10 — Concavity Thresholding
      img = uint8([
          20 + grand(120,1,"uin",0,25);
          120 + grand(120,1,"uin",0,40);
          220 + grand(120,1,"uin",0,15)
      ]);
      out = graythresh(img, "concavity")
##
      Threshold corresponds to significant histogram valleys; multiple peaks are analyzed successfully.
## 11 — Percentile Thresholding (p = 0.5)
      img = uint8([
          grand(150,1,"uin",10,80);
          grand(150,1,"uin",180,240)
      ]);
      out = graythresh(img, "percentile", 0.5)
##
      Approximately 50% of pixels lie below the threshold, corresponding to the histogram median.
## 12 — Percentile Thresholding (p = 0.25)
      img = uint8([
          grand(200,1,"uin",10,60);
          grand(100,1,"uin",180,240)
      ]);
      out = graythresh(img, "percentile", 0.25)
##
      Approximately 25% of pixels lie below the threshold; threshold shifts toward lower intensities.
## 13 — Percentile Thresholding (p = 0.75)
      img = uint8([
          grand(300,1,"uin",10,80);
          grand(100,1,"uin",180,240)
      ]);
      out = graythresh(img, "percentile", 0.75)
##
      Approximately 75% of pixels lie below the threshold; threshold shifts toward higher intensities.
## 14 — Histogram Input
      histogram = [10 20 50 100 50 20 10];
      out = graythresh(histogram, "otsu")
##
      Histogram is interpreted correctly; the Otsu threshold is computed directly from the bin counts.
## 15 — Single-Bin Histogram
      histogram = 100;
      out = graythresh(histogram, "otsu")
##
      No meaningful threshold exists since only one gray level is present; the function returns a valid fallback value (raw threshold 0, unnormalized).
## 16 — RGB Image Input
      rgb(:,:,1) = uint8([255*ones(50,25) 50*ones(50,25)]);
      rgb(:,:,2) = uint8([100*ones(50,25) 200*ones(50,25)]);
      rgb(:,:,3) = uint8([0*ones(50,25) 150*ones(50,25)]);
      out = graythresh(rgb, "otsu")
##
      The RGB image is converted internally to grayscale via rgb2gray, and a valid threshold is returned.
## 17 — uint16 Image Input
      img = uint16([zeros(50,50) 65535*ones(50,50)]);
      out = graythresh(img)
##
      Dynamic range is handled correctly; threshold is normalized to [0,1] using the 16-bit bin count.
## 18 — Double Precision Image
      img = rand(100,100);
      out = graythresh(img)
##
      Threshold lies within [0,1]; a valid normalized threshold is produced from the continuous-valued data.
