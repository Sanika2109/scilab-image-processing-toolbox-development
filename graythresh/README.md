# graythresh

## Description:
`graythresh` computes a global intensity threshold for a binary image, using one of eleven selectable thresholding algorithms.

It analyzes either a grayscale image, an RGB image (auto-converted to grayscale), or a pre-computed intensity histogram, and returns a single threshold value normalized to `[0, 1]`. The threshold is intended to be used to binarize the image (e.g. via `BW = img > level`). Algorithms range from a simple intensity mean to variance-, entropy-, moment-, and shape-based methods, several of which iteratively refine the threshold until convergence.

## Calling Sequence:
```
level = graythresh(img)
level = graythresh(img, algo)
level = graythresh(img, "percentile", p)
[level, sep] = graythresh(img, "otsu")
```

---
## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `img` | Matrix / Vector | **Input:** `2-D` grayscale image, `M×N×3` RGB image (auto-converted via `rgb2gray`), or a non-negative real vector treated directly as a histogram. |
| `algo` | String | **Input (optional, default `"otsu"`):** Thresholding algorithm, case-insensitive. One of `"concavity"`, `"intermeans"`, `"intermodes"`, `"maxentropy"`, `"maxlikelihood"`, `"mean"`, `"minerror"`, `"minimum"`, `"moments"`, `"otsu"`, `"percentile"`. |
| `p` *(varargin)* | Double | **Input (optional):** Target cumulative fraction, only valid for `algo = "percentile"` (default `0.5`). Any other algorithm rejects extra arguments. |
| `level` | Double | **Output:** Computed threshold, normalized to `[0, 1]`. May be non-integer-derived but always lies in this range. |
| `sep` | Double | **Output (`"otsu"` only, second return value):** Separability/quality measure in `[0, 1]` — ratio of between-class to total variance. |

---
## Variable Reference

| Variable | Scope | Type | Description |
| --- | --- | --- | --- |
| `rhs` | Main | Integer | Number of input arguments supplied (`argn(2)`); used for argument-count validation. |
| `hist_in` | Main | Boolean | `%t` if `img` was recognized as a histogram vector rather than image data. |
| `ihist` | Main | Row vector (Double) | The working histogram of bin counts, either supplied directly or built from `img`. |
| `nbins` | Main | Integer | Number of histogram bins (`256` for 8-bit, `65536` for 16-bit data, or `length(ihist)` for histogram input). |
| `pixels` | Main | Column vector (Double) | Flattened, double-precision pixel values used to build `ihist`. |
| `thresh` | Main | List | Raw 0-based threshold (and, for `otsu`, an optional separability value) before final normalization. |
| `bins` | otsu | Row vector (Double) | Intensity values `0..nbins-1` represented by each histogram bin. |
| `total` | otsu | Double | Total pixel count, `sum(ihist)`. |
| `b_totals`, `w_totals` | otsu | Row vector (Double) | Cumulative pixel counts in the background / foreground class at each candidate split. |
| `b_weights`, `w_weights` | otsu | Row vector (Double) | Class proportions, `b_totals/total` and `w_totals/total`. |
| `b_means`, `w_means` | otsu | Row vector (Double) | Mean intensity of the background / foreground class at each candidate split. |
| `bcv` | otsu | Row vector (Double) | Between-class variance at each candidate split point. |
| `max_bcv` | otsu | Double | Maximum value of `bcv`; locates the optimal split and feeds the separability score. |
| `sumY`, `sumB`, `sumC`, `sumD` | moments, maxlikelihood, minerror_iter | Double | Zeroth-, first-, second-, third-order raw moments of the histogram (via `partial_sumA`–`D`). |
| `Avec` | moments, percentile | Row vector (Double) | Cumulative distribution function of the histogram, `cumsum(y)/sum(y)`. |
| `x0`, `x1`, `x2` | moments | Double | Auxiliary coefficients from the moment-matching equations; `x0` is the target cumulative fraction. |
| `negY` | maxentropy | Double | Total negative-entropy of the full histogram (via `negativeE`). |
| `vec` | maxentropy | Row vector (Double) | Candidate-threshold criterion values; the minimum locates the threshold. |
| `iter` | intermodes, minimum | Integer | Number of 3-point smoothing passes applied so far (capped at 10000). |
| `TT` | intermodes | Row vector (Double) | Positions of the histogram's local maxima (peaks) after smoothing. |
| `peakfound` | minimum | Boolean | Flag indicating the first peak has been located while scanning for the following valley. |
| `p`, `q` | percentile (input), and shared with minerror/maxlikelihood/intermeans | Double | In `percentile`: target cumulative fraction (default `0.5`). In the Gaussian-fit methods: estimated prior probabilities of the two classes. |
| `T`, `Tprev` | minerror_iter, maxlikelihood, intermeans | Integer | Current and previous threshold estimate; iteration stops when `T == Tprev`. |
| `mu`, `nu` | minerror_iter, maxlikelihood, intermeans | Double | Estimated means of the "below-threshold" and "above-threshold" classes. |
| `sigma2`, `tau2` | minerror_iter, maxlikelihood | Double | Estimated variances of the two classes. |
| `w0`, `w1`, `w2`, `sqterm` | minerror_iter, maxlikelihood | Double | Coefficients / discriminant of the quadratic equation solved for the Gaussian crossing point. |
| `phi`, `gamma` | maxlikelihood | Row vector (Double) | Posterior class-membership probabilities for each intensity level, and their complements. |
| `F`, `G` | maxlikelihood | Double | Weighted sums `sum(phi.*y)` and `sum(gamma.*y)`, used to re-estimate parameters each iteration. |
| `H` | concavity (`hconvhull`) | Row vector (Double) | Convex-hull envelope of the histogram. |
| `lmax` | concavity (`flocmax`) | Row vector (Boolean) | Marks local maxima of `H - h`. |
| `E` | concavity (`hbalance`) | Row vector (Double) | Balance measure at each histogram index. |
| `K` | concavity (`hconvhull`) | Row vector (Integer) | Indices of the convex hull's vertices. |

---
## Helper Functions

### Internal helper routines

| Function | Type | Purpose |
| --- | --- | --- |
| `partial_sumA(y,j)` | Internal | Zeroth moment: `sum(y(0..j))` — total count up to index `j`. |
| `partial_sumB(y,j)` | Internal | First moment: `sum(i*y(i))` for `i = 0..j`. |
| `partial_sumC(y,j)` | Internal | Second moment: `sum(i^2*y(i))` for `i = 0..j`. |
| `partial_sumD(y,j)` | Internal | Third moment: `sum(i^3*y(i))` for `i = 0..j`. Used only by `moments`. |
| `bimodtest(y)` | Internal | Returns `%t` if histogram `y` has exactly two local maxima (bimodal), `%f` otherwise. |
| `flocmax(x)` | Internal | Binary vector marking local maxima of `x` via a 3-point neighborhood. |
| `hbalance(y,ind)` | Internal | Balance about index `ind`: `partial_sumA(y,ind) * (total - partial_sumA(y,ind))`. |
| `hconvhull(h)` | Internal | Upper convex hull (envelope) of histogram `h` via angle-sweep using a two-argument `atan(y,x)`. |
| `negativeE(y,j)` | Internal | Negative-entropy contribution `sum(y_i * log10(y_i))` over nonzero bins `0..j`. |

### Built-in / toolbox functions used

| Function | Type | Purpose |
| --- | --- | --- |
| `argn()` | Built-in | Determines the number of input/output arguments supplied to the function. |
| `error()` | Built-in | Raises an error and halts execution on invalid input or unsupported options. |
| `convstr()` | Built-in | Case-folds the `algo` string for case-insensitive matching. |
| `rgb2gray()` | SIVP | Converts an `M×N×3` RGB image to a 2-D grayscale image. |
| `im2double()`, `im2uint8()`, `im2uint16()` | SIVP | Rescale/convert pixel values between numeric image classes. |
| `intmax()` | SIVP | Returns the maximum representable value for the image's numeric class, used to size `ihist`. |
| `conv2()` | Built-in | 1-D/2-D convolution; used for 3-point histogram smoothing (`intermodes`, `minimum`). |
| `cumsum()`, `sum()`, `mean()`, `find()`, `max()`/`min()` | Built-in | Vectorized statistics over histograms used throughout `otsu`, `moments`, `percentile`, etc. |

---
## Algorithm

```text
┌──────────────────────────────┐
│             Start            │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│ Receive Inputs:              │
│ img, algo, varargin          │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────────┐
│ Validate Arguments               │
│ • 1–3 inputs supplied            │
│ • default algo = "otsu"          │
│ • only "percentile" accepts an   │
│   extra option (p)               │
└───────────────┬──────────────────┘
                │
                ▼
┌────────────────────────────────┐
│ Classify Input                 │
│ • numeric?  → else error       │
│ • M×N×3 (RGB) → rgb2gray       │
│ • non-negative double vector → │
│   treat as histogram (hist_in) │
└───────────────┬────────────────┘
                │
                ▼
        ┌─────────────────┐
        │ algo == "mean"? │
        └───┬─────────┬───┘
        yes │         │ no
            ▼         ▼
┌───────────────────┐ ┌──────────────────────────────────┐
│ level =           │ │  Build / use histogram `ihist`   │
│ mean(im2double    │ │  • convert to uint8/uint16/int16 │
│ (img(:)))         │ │  • count pixel intensities       │
│ → return level    │ │    (nbins = intmax(type)+1)      │
└───────────────────┘ └───────────────┬──────────────────┘
                                      │
                                      ▼
                       ┌────────────────────────────────┐
                       │ Dispatch on `algo`:            │
                       │ otsu • moments • maxentropy    │
                       │ intermodes • minimum •         │
                       │ percentile • minerror •        │
                       │ maxlikelihood • intermeans •   │
                       │ concavity                      │
                       └───────────────┬────────────────┘
                                       │
                                       ▼
                       ┌────────────────────────────────┐
                       │ Normalize Threshold            │
                       │ thresh(1) /= (nbins - 1)       │
                       │ (skipped if nbins == 1)        │
                       └───────────────┬────────────────┘
                                       │
                                       ▼
                       ┌────────────────────────────────┐
                       │ Return level                   │
                       │ (and sep, for "otsu" if        │
                       │  a second output is requested) │
                       └───────────────┬────────────────┘
                                       │
                                       ▼
                              ┌────────────────┐
                              │       End      │
                              └────────────────┘
```

### Method summaries

| Algorithm | One-line description |
| --- | --- |
| `mean` | Returns the mean of the (double-converted) pixel intensities directly; bypasses the histogram pipeline. |
| `otsu` *(default)* | Maximizes between-class variance over every candidate split; optionally returns a separability score. |
| `moments` | Matches the first three raw moments of the histogram to find a target cumulative fraction. |
| `maxentropy` | Minimizes a combined entropy criterion over the two resulting classes. |
| `intermodes` | Smooths the histogram until bimodal, then returns the mean position of its two peaks. |
| `minimum` | Smooths the histogram until bimodal, then returns the valley between its two peaks. |
| `percentile` | Returns the bin where the cumulative distribution first reaches a target fraction `p`. |
| `minerror`  | Iteratively fits two Gaussian classes and solves for their crossing point. |
| `maxlikelihood` | EM-style refinement of a two-Gaussian mixture, then solves for the crossing point. |
| `intermeans` | Iteratively sets the threshold to the average of the two class means until stable. |
| `concavity` | Locates the deepest, most balanced concavity between the histogram and its convex hull. |

---
## Time & Space Complexity

Let `N` = number of pixels in the image, and `n` = `nbins - 1` (`255` or `65535`).

| Stage / Algorithm | Time Complexity | Space Complexity | Notes |
| --- | --- | --- | --- |
| Histogram construction | `O(N)` | `O(n)` | Explicit per-pixel loop; large constant factor vs. a vectorized bin-count. |
| `mean` | `O(N)` | `O(1)` | Single pass; no histogram needed. |
| `otsu` | `O(n)` | `O(n)` | Fully vectorized via `cumsum`. |
| `moments` | `O(n)` | `O(n)` | A few `O(n)` moment sums plus one scan. |
| `percentile` | `O(n)` | `O(n)` | One `cumsum` plus one scan. |
| `maxentropy` | `O(n²)` | `O(n)` | Outer loop of `n+1`, each iteration doing `O(j)` work via `partial_sumA`/`negativeE`. |
| `intermodes` | `O(n·k)` | `O(n)` | `k` = smoothing iterations until bimodal (capped at 10000). |
| `minimum` | `O(n·k)` | `O(n)` | Like `intermodes`, but the vector grows by 2 elements per pass (`conv2` without `"same"`). |
| `minerror_iter` | `O(n·k)` | `O(n)` | `k` = convergence iterations (typically small). |
| `intermeans` | `O(n·k)` | `O(n)` | `k` = convergence iterations (typically small). |
| `maxlikelihood` | `O(n·k₁) + O(n·k₂)` | `O(n)` | `k₁` from its internal call to `minimum`, `k₂` = EM iterations. |
| `concavity` | `O(n²)` | `O(n)` | `hconvhull`'s angle-sweep is `O(n²)` worst case; `hbalance` called `n+1` times at `O(n)` each. |

---
## Mathematical Foundation

### Histogram and Class Split

```text
y(i)  = histogram count at intensity i,  i = 0 .. n
N(t)  = sum(y(0..t))           // pixels in the "below threshold" class
N'(t) = sum(y(t+1..n))         // pixels in the "above threshold" class
```

### Otsu (Otsu, 1979)

```text
w0(t) = N(t)  / total
w1(t) = N'(t) / total
σ_B²(t) = w0(t) * w1(t) * (μ0(t) - μ1(t))²

threshold = argmax_t  σ_B²(t)
separability η = max(σ_B²) / σ_Total²
```

### Moments (Tsai, 1985)

```text
x2 = (B*C - Y*D) / (Y*C - B²)
x1 = (B*D - C²) / (Y*C - B²)
x0 = 0.5 - (B/Y + x2/2) / sqrt(x2² - 4*x1)

threshold = argmin_t | CDF(t) - x0 |
```
where `Y, B, C, D` are the zeroth–third raw moments of the histogram.

### Maximum Entropy (Kapur, Sahoo & Wong, 1985)

```text
J(t) = -E(t)/N(t) - log10(N(t)) - (E_total - E(t))/N'(t) - log10(N'(t))

threshold = argmin_t  J(t)
```
where `E(t) = sum( y(i) * log10(y(i)) )` for `i = 0..t`.

### Minimum Error (Kittler & Illingworth, 1986)

```text
J(t) = p*log10(σ/p) + q*log10(τ/q)

threshold = argmin_t  J(t)
```
assuming two Gaussian populations with means `μ, ν`, variances `σ², τ²`, and priors `p, q = 1-p`.

### Maximum Likelihood

```text
E-step:  φ(i) = [p·N(i;μ,σ²)] / [p·N(i;μ,σ²) + q·N(i;ν,τ²)]
M-step:  re-estimate μ, ν, σ², τ², p, q as weighted moments using φ and (1-φ)

repeat until parameters converge, then solve:
 w0·t² ... → crossing point of the two weighted Gaussians
```

### Intermeans / Isodata (Ridler & Calvard, 1978)

```text
T(0) = initial guess
T(k+1) = floor( (mean(below T(k)) + mean(at/above T(k))) / 2 )
repeat until T(k+1) == T(k)
```

### Intermodes / Minimum (Prewitt & Mendelsohn, 1966)

```text
repeat: y = conv(y, [1 1 1]/3)   until bimodal(y)

intermodes: threshold = floor( mean(peak positions) )
minimum:    threshold = position of the valley between the two peaks
```

### Concavity (Rosenfeld & De La Torre, 1983)

```text
H    = convex hull (upper envelope) of histogram h
gap  = H - h
threshold = argmax over local maxima of gap, weighted by
            balance(t) = N(t) * (total - N(t))
```

### Percentile (Doyle, 1962)

```text
CDF(t) = cumsum(y) / sum(y)
threshold = argmin_t | CDF(t) - p |     (default p = 0.5)
```

### Output Range

```text
0 ≤ level ≤ 1          (after dividing the raw bin index by (nbins - 1))
0 ≤ sep   ≤ 1          ("otsu" separability only)
```

---
## Choosing an Algorithm

| Algorithm | Approach | Needs (Near-)Bimodal Histogram | Relative Cost | Best Used When |
| --- | --- | --- | --- | --- |
| `mean` | Arithmetic mean of intensities | No | Lowest | A fast, rough estimate is acceptable. |
| `otsu` *(default)* | Maximizes between-class variance | No | Low | General-purpose; also reports a separability/quality score. |
| `percentile` | Fixed cumulative fraction | No | Low | The approximate foreground/background proportion is known. |
| `moments` | Matches statistical moments | No | Low | Robust alternative to `otsu`. |
| `intermeans` | Iterative mean-of-means | Helpful | Low–Moderate | Two reasonably separated populations. |
| `minerror` | Iterative Gaussian-mixture fit | Helpful | Low–Moderate | Two roughly Gaussian populations. |
| `maxlikelihood` | EM-based Gaussian-mixture fit | Helpful | Moderate–High | Higher accuracy needed; populations roughly Gaussian. |
| `intermodes` | Smooth until bimodal, take midpoint of peaks | Yes (or smoothed into it) | Moderate | Histogram is, or can be smoothed into, two clear peaks. |
| `minimum` | Smooth until bimodal, take the valley | Yes (or smoothed into it) | Moderate | Clear valley between two populations. |
| `maxentropy` | Maximizes combined class entropy | No | Moderate (`O(n²)`) | Low-contrast or noisy histograms. |
| `concavity` | Convex-hull concavity + balance | No | High (`O(n²)`) | Histogram shape has a pronounced "notch". |

**Recommendation:** Start with `otsu` (the default). If `sep` is low, or the histogram is visibly bimodal, try `intermodes`/`minimum`/`intermeans`. Use `percentile` only when the foreground proportion is known in advance.

---
## Test Cases:

The following 18 test cases use small histogram vectors (passed directly as `img`, via the `hist_in` path) so that results can be verified without needing a full image. All edge cases and critical cases are covered in the test suite. Run them after loading the function with `exec('graythresh_test.sce', -1)`.

### Test Case 1 — Otsu Thresholding on Bimodal Image

Verifies that the default Otsu algorithm correctly identifies the threshold separating two distinct intensity classes and returns the effectiveness metric.

```scilab
img = uint8([zeros(50,50) 255*ones(50,50)]);

[level, goodness] = graythresh(img);
```

**Expected output:** 
* Threshold lies near the midpoint of the intensity range.
* Goodness metric is close to 1.
* Two classes are clearly separated.

**Observation:**
The image contains two perfectly separated intensity groups
at 0 and 255. Otsu's method identifies a threshold near
the middle of the histogram and reports excellent class
separability.

---
### Test Case 2 — Mean Thresholding

Verifies that the mean algorithm selects the threshold equal to the average gray-level intensity.

```scilab
img = uint8([
    grand(100,1,"uin",20,80);
    grand(100,1,"uin",180,240)
]);

out = graythresh(img, "mean");
```

**Expected output:** 

* Threshold approximately equals the mean image intensity.
* Value lies between the two intensity clusters.

**Observation:**
The threshold corresponds to the arithmetic mean of the
image histogram and falls between the low and high
intensity groups.

---
### Test Case 3 — Intermeans Thresholding

Verifies convergence of the iterative intermeans (Ridler-Calvard) algorithm.

```scilab
img = uint8([
    grand(100,1,"uin",20,70);
    grand(100,1,"uin",180,230)
]);

out = graythresh(img, "intermeans");
```

**Expected output:** 

* Iterative process converges.
* Threshold lies between the two modes.

**Observation:**
The algorithm repeatedly computes class means until
the threshold stabilizes. The final threshold separates
the two dominant intensity groups.

---
### Test Case 4 — Intermodes Thresholding
Verifies detection of the valley between two sharp histogram peaks.

```scilab
img = uint8([
    10 + grand(100,1,"uin",0,5);
    245 + grand(100,1,"uin",0,5)
]);

out = graythresh(img, "intermodes");
```

**Expected output:** 

* Histogram is smoothed until two modes remain.
* Threshold is located between the modes.

**Observation:**
The histogram contains two narrow peaks near opposite
ends of the intensity range. Intermodes identifies the
minimum between these peaks as the threshold.

---
### Test Case 5 — Maximum Entropy Thresholding

Verifies that the threshold maximizes the sum of foreground and background entropies.

```scilab
img = uint8([
    30 + grand(100,1,"uin",0,20);
    200 + grand(100,1,"uin",0,20)
]);

out = graythresh(img, "maxentropy");
```

**Expected output:** 

* Threshold maximizes information content.
* Value lies between the two classes.

**Observation:**
The algorithm searches for the threshold producing the
largest combined entropy of the foreground and background
histograms.

---
### Test Case 6 — Maximum Likelihood Thresholding

Verifies threshold estimation using a Gaussian mixture model.

```scilab
img = uint8([
    40 + grand(100,1,"uin",0,20);
    200 + grand(100,1,"uin",0,20)
]);

out = graythresh(img, "maxlikelihood");
```

**Expected output:** 

* Threshold separates two statistically distinct populations.
* Convergent solution is obtained.

**Observation:**
The image is modeled as a mixture of two Gaussian
distributions. The threshold corresponds to the most
likely separation between these classes.

---
### Test Case 7 — Minimum Method

Verifies valley detection between two histogram peaks using the minimum method.

```scilab
img = uint8([
    50 + grand(100,1,"uin",0,10);
    220 + grand(100,1,"uin",0,10)
]);

out = graythresh(img, "minimum");
```

**Expected output:** 

* Threshold lies at the minimum between two peaks.
* Histogram smoothing converges successfully.
  
**Observation:**
The histogram exhibits two well-separated modes.
The minimum method selects the valley between these
modes as the threshold.

---
### Test Case 8 — Minimum Error Thresholding

Verifies threshold computation that minimizes classification error.

```scilab
img = uint8([
    30 + grand(100,1,"uin",0,15);
    210 + grand(100,1,"uin",0,15)
]);

out = graythresh(img, "minerror");
```

**Expected output:** 

* Threshold minimizes expected misclassification.
* Result falls between the two intensity groups.
  
**Observation:**
The method estimates class statistics and determines
the threshold that minimizes segmentation error.

---
### Test Case 9 — Moments Thresholding

Verifies threshold estimation using histogram moment preservation.

```scilab
img = uint8(grand(128,128,"uin",0,255));

out = graythresh(img, "moments");
```

**Expected output:** 

* Threshold preserves selected histogram moments.
* Valid normalized threshold is returned.
  
**Observation:**
The algorithm computes a threshold that preserves the
statistical moments of the original histogram in the
binary image representation.

---
### Test Case 10 — Concavity Thresholding

Verifies threshold determination based on histogram concavity analysis.

```scilab
img = uint8([
    20 + grand(120,1,"uin",0,25);
    120 + grand(120,1,"uin",0,40);
    220 + grand(120,1,"uin",0,15)
]);

out = graythresh(img, "concavity");
```

**Expected output:** 

* Threshold corresponds to significant histogram valleys.
* Multiple peaks are analyzed successfully.
  
**Observation:**
The histogram contains several modes. The concavity
method identifies a threshold based on valley depth
and histogram shape characteristics.

---
### Test Case 11 — Percentile Thresholding (p = 0.5)

Verifies median-based threshold selection.

```scilab
img = uint8([
    grand(150,1,"uin",10,80);
    grand(150,1,"uin",180,240)
]);

out = graythresh(img, "percentile", 0.5);
```

**Expected output:** 

* Approximately 50% of pixels lie below the threshold.
* Threshold corresponds to the histogram median.
  
**Observation:**
The selected threshold divides the cumulative histogram
into two equal portions.

---
### Test Case 12 — Percentile Thresholding (p = 0.25)

Verifies lower-percentile threshold selection.

```scilab
img = uint8([
    grand(200,1,"uin",10,60);
    grand(100,1,"uin",180,240)
]);

out = graythresh(img, "percentile", 0.25);
```

**Expected output:** 

* Approximately 25% of pixels lie below the threshold.
* Threshold shifts toward lower intensities.
  
**Observation:**
The threshold is selected from the cumulative histogram
position corresponding to the first quartile.

---

### Test Case 13 — Percentile Thresholding (p = 0.75)

Verifies upper-percentile threshold selection.

```scilab
img = uint8([
    grand(300,1,"uin",10,80);
    grand(100,1,"uin",180,240)
]);

out = graythresh(img, "percentile", 0.75);
```

**Expected output:** 

* Approximately 75% of pixels lie below the threshold.
* Threshold shifts toward higher intensities.
  
**Observation:**
The threshold corresponds to the cumulative histogram
position representing the third quartile.

---

### Test Case 14 — Histogram Input

Verifies that a histogram vector can be used directly instead of an image.

```scilab
histogram = [10 20 50 100 50 20 10];

out = graythresh(histogram, "otsu");
```

**Expected output:** 

* Histogram is interpreted correctly.
* Otsu threshold is computed from bin counts.
  
**Observation:**
The function accepts histogram data directly and
computes the threshold without reconstructing an image.

---

### Test Case 15 — Single-Bin Histogram

Verifies behavior for a degenerate histogram containing only one bin.

```scilab
histogram = 100;

out = graythresh(histogram, "otsu");
```

**Expected output:** 

* No meaningful threshold exists.
* Function returns a valid fallback value.
  
**Observation:**
Since only one gray level is present, segmentation is
not meaningful. The algorithm handles this edge case
gracefully.

---

### Test Case 16 — RGB Image Input

Verifies handling of true-color images.

```scilab
rgb(:,:,1) = uint8([255*ones(50,25) 50*ones(50,25)]);
rgb(:,:,2) = uint8([100*ones(50,25) 200*ones(50,25)]);
rgb(:,:,3) = uint8([0*ones(50,25) 150*ones(50,25)]);

out = graythresh(rgb, "otsu");
```

**Expected output:** 

* RGB image is converted internally.
* Valid threshold is returned.
  
**Observation:**
The algorithm processes the color image by converting
it to a grayscale representation before threshold
selection.

---

### Test Case 17 — uint16 Image Input

Verifies support for 16-bit integer images.

```scilab
img = uint16([zeros(50,50) 65535*ones(50,50)]);

out = graythresh(img);
```

**Expected output:** 

* Dynamic range is handled correctly.
* Threshold is normalized to the output range.
  
**Observation:**
The image contains two extreme intensity classes.
The algorithm successfully computes a threshold for
16-bit data.

---

### Test Case 18 — Double Precision Image

Verifies thresholding of floating-point images.

```scilab
img = rand(100,100);

out = graythresh(img);
```

**Expected output:** 

* Threshold lies within `[0,1]`.
* Otsu algorithm implemented successfully.
  
**Observation:**
The image contains random floating-point intensities.
A valid normalized threshold is produced from the
continuous-valued data.

---

### Test Results

The file `graythresh_Test_Results.pdf` contains the output generated for each test case, including:
* Input image matrix or histogram used for threshold computation.
* Threshold value returned by graythresh.
* Results obtained using different thresholding methods.
* Additional test cases for visual observations.

---
## Compatibility Notes

This function is a Scilab translation of GNU Octave's `graythresh` function (from the Octave `image` package) and supports the same eleven algorithms via the same `algo` string values.

### Important Differences from Octave

* **Error message formatting bug.** `error(msprintf("graythresh: unknown method", algo))` has no `%s` placeholder, so the offending `algo` name is silently dropped from the error text.

* **`intermodes` vs. `minimum` smoothing differ in vector growth.** `intermodes` uses `conv2(y, h, "same")` (length-preserving); `minimum` uses `conv2(y, h)` without `"same"`, which grows the vector by 2 elements per smoothing pass, shifting index alignment over many iterations.

* **Histogram construction is not vectorized.** Bin counts are accumulated with an explicit per-pixel `for` loop rather than a vectorized bin-count, which can be noticeably slower for large images.

* **`"mean"` bypasses the `[0,1]` normalization step** that all other algorithms go through — it returns `mean(im2double(img(:)))` directly.

* **`"mean"` with a histogram-vector input is not meaningful.** If `img` is itself a histogram (`hist_in` path), `"mean"` computes the mean *bin count*, not the mean *intensity*.

* **Otsu's second output (`sep`) is not renormalized** — only `thresh(1)` is divided by `(nbins-1)`.

* **Histogram-vector detection is strict.** An input is treated as a histogram only if it is a real, non-negative, **double-precision** vector (`type(img)==1 & isvector(img) & isreal(img) & and(img>=0)`); integer-typed vectors are instead treated as a `1×N` image.

* **Single-bin histograms skip normalization entirely** (`size(ihist,"*")==1`), so a raw `0` threshold is returned unchanged.

---
## Recommended Usage

For results comparable to GNU Octave, and to avoid the pitfalls above:

```scilab
// General-purpose, with a quality check
[level, sep] = graythresh(Img, "otsu");
if sep < 0.3 then
    disp("Warning: histogram is poorly separated; thresholding may be unreliable.");
end
BW = Img > (level * 255);   // re-scale level back to the image's intensity range
```

* Use `"otsu"` (the default) as a general-purpose starting point, and inspect `sep` to assess whether global thresholding is appropriate at all.
* For known bimodal histograms, `"intermodes"`, `"minimum"`, or `"intermeans"` are inexpensive and effective.
* For known foreground proportions, use `"percentile"` with an explicit `p`.
* Avoid `"mean"` on histogram-vector inputs, and never pass a third argument unless `algo = "percentile"`.
* For large images, consider precomputing a histogram once (e.g. with a vectorized bin-count) and passing that histogram to `graythresh` when comparing multiple algorithms, to avoid repeating the `O(N)` per-pixel histogram-construction loop.

---
## References

[1] N. Otsu, "A threshold selection method from gray-level histograms," *IEEE Transactions on Systems, Man, and Cybernetics*, 1979.

[2] W.-H. Tsai, "Moment-preserving thresholding: A new approach," *Computer Vision, Graphics, and Image Processing*, 1985.

[3] J. Kapur, P. Sahoo, A. Wong, "A new method for gray-level picture thresholding using the entropy of the histogram," *Computer Vision, Graphics, and Image Processing*, 1985.

[4] J. Kittler, J. Illingworth, "Minimum error thresholding," *Pattern Recognition*, 1986.

[5] T. Ridler, S. Calvard, "Picture thresholding using an iterative selection method," *IEEE Transactions on Systems, Man, and Cybernetics*, 1978.

[6] A. Rosenfeld, P. De La Torre, "Histogram concavity analysis as an aid in threshold selection," *IEEE Transactions on Systems, Man, and Cybernetics*, 1983.

[7] J. M. S. Prewitt, M. L. Mendelsohn, "The analysis of cell images," *Annals of the New York Academy of Sciences*, 1966.

[8] W. Doyle, "Operations useful for similarity-invariant pattern recognition," *Journal of the ACM*, 1962.

[9] GNU Octave Image Package Documentation — `graythresh`.

[10] MATLAB Image Processing Toolbox Documentation — `graythresh`.
