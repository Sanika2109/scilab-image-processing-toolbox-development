# histeq
## Description
- The histeq function performs histogram equalization on a grayscale image, redistributing intensity values so the resulting histogram becomes more uniform.
- The number of arguments passed must be 1 or 2.
- If an RGB image is provided, it is first converted to grayscale before equalization. Empty images return an empty matrix, and constant images are returned unchanged.
## Calling Sequence
```
equi_hist = histeq(Img)
equi_hist = histeq(Img, numBins)
```
## Parameters
`Img` - A grayscale or RGB matrix.

`numBins` - (Optional, default `64`) Integer number of histogram bins used during equalization.

`equi_hist` - Output. Histogram-equalized image with intensity values in the range `[0,1]`.
# Examples
## 1 — Bright Image
      A = imread("bright_img.jpg");
      B = histeq(A)
##
      Contrast is enhanced; the histogram becomes more evenly distributed and bright regions become more distinguishable.
## 2 — Dark Image
      A = imread("dark_image.jpeg");
      B = histeq(A)
##
      Dark regions become more visible; contrast increases and the histogram spreads over a wider intensity range.
## 3 — Low Contrast Image
      A = imread("lc_image.jpg");
      B = histeq(A)
##
      Significant contrast improvement; details previously hidden become visible and the histogram becomes more uniformly distributed.
## 4 — Very Few Histogram Bins
      A = imread("grayscale_img.jpg");
      B = histeq(A, 4)
##
      Equalization completes successfully; the output image exhibits visible intensity quantization since only four histogram levels are available.
## 5 — Very Large Number of Histogram Bins
      A = imread("grayscale_img.jpg");
      B = histeq(A, 512)
##
      Equalization completes successfully; histogram mapping becomes more detailed and the output remains normalized to [0,1].
## 6 — Adequate Number of Histogram Bins
      A = imread("grayscale_img.jpg");
      B = histeq(A, 128)
##
      Contrast enhancement is achieved; the histogram is redistributed effectively while maintaining smooth intensity transitions.
## 7 — Empty Image
      A = [];
      B = histeq(A)
##
      Empty matrix
## 8 — Constant Image
      A = 100*ones(50,50);
      B = histeq(A)
##
      Original image returned unchanged
