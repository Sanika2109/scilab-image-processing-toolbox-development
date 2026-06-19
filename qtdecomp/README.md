# qtdecomp

## Description:
`qtdecomp` performs quadtree decomposition of a square image, recursively splitting it into smaller square blocks until each block satisfies a stopping criterion.

Starting from the whole image, each square block is tested against a splitting rule; if the rule says "split," the block is divided into four equal quadrants, each of which is then tested again, recursively, until every remaining block either passes the rule or has reached the smallest allowed size (`mindim`). The result is encoded in a sparse matrix `S` of the same size as the input image, where each nonzero entry marks the top-left corner of a final (un-split) block and records that block's side length. Three splitting rules are supported: uniform-value blocks only (no second argument), a numeric intensity-range threshold, or a user-supplied decision function evaluated on stacks of candidate blocks.

## Calling Sequence:
```
S = qtdecomp(I)
S = qtdecomp(I, threshold)
S = qtdecomp(I, threshold, mindim)
S = qtdecomp(I, threshold, [mindim maxdim])
S = qtdecomp(I, fun)
S = qtdecomp(I, fun, ...)
```

---
## Parameters:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `I` | Matrix | **Input:** `2-D` square image to decompose (any numeric class; `uint8`/`uint16` receive special threshold scaling). |
| `p1` | Double / Function | **Input (optional):** Either a numeric splitting threshold, or a function handle / inline function used as a custom split decision. If omitted, blocks are split until every remaining block is uniform (all pixels equal). |
| `varargin(1)` (`dims`) | Double / Vector | **Input (optional, threshold mode only):** Either a single value `mindim`, or a two-element vector `[mindim maxdim]` bounding the allowed block sizes. Defaults to `mindim = 1`, `maxdim = size(I,1)`. |
| `varargin(2:)` | Any | **Input (optional, function-handle mode only):** Additional arguments forwarded to `fun` on every call. |
| `S` | Matrix (Sparse) | **Output:** Quadtree decomposition matrix, same size as `I`. `S(r,c) = d` marks `(r,c)` as the top-left corner of a final `d×d` block; all other entries are `0`. |

---
## Variable Reference

| Variable | Scope | Type | Description |
| --- | --- | --- | --- |
| `rhs` | Main | Integer | Number of input arguments supplied (`argn(2)`); must be at least `1`. |
| `curr_size` | Main | Double | Side length of the block size currently being evaluated; starts at `size(I,1)` and halves at every quadtree level (or is reduced once up front if `maxdim` forces it). |
| `mindim`, `maxdim` | Main | Double | Smallest and largest permitted block sizes; default to `1` and `size(I,1)` respectively. |
| `decision_method` | Main | Integer | Selects the splitting rule: `0` = uniform-value test (no threshold given), `1` = numeric range threshold, `2` = user function handle. |
| `fun` | Main | Function | The user-supplied decision function, only set when `decision_method == 2`. |
| `threshold` | Main | Double | The numeric split threshold; rescaled by `255` or `65535` when `I` is `uint8`/`uint16`, to match the image's native intensity range. |
| `res` | Main | Matrix | Accumulator of finalized blocks; each row is `[row, col, size]` for one terminal (un-split) block. |
| `finished` | Main | Boolean | Set to `%t` once a quadtree level is reached where every remaining block must stop (cannot satisfy `curr_size/2 >= mindim` evenly). |
| `offsets` | Main | Matrix | `N×2` matrix of `[row, col]` top-left corners of all blocks currently being evaluated at the current `curr_size`. |
| `initial_splits` | Main | Double | Number of mandatory splits computed up front (`ceil(log2(curr_size/maxdim))`) to force the starting block size down to `maxdim` before the main loop begins. |
| `divs` | Main | Double | `2^initial_splits`; the number of blocks per side after the mandatory pre-split. |
| `els` | Main | Vector | Block-corner offsets along one axis after the mandatory pre-split, `[0:divs-1]*curr_size + 1`. |
| `db` | Main | Boolean Vector | Decision vector for the current set of `offsets`: `%t` = split this block further, `%f` = keep it as a terminal block. |
| `o`, `fo` | Main | Vector | Top-left and bottom-right corner coordinates of the block currently being tested for the split decision. |
| `blk`, `t` | Main | Matrix / Vector | The pixel data of the candidate block (`decision_method == 0`), or its flattened form (`decision_method == 1`), used to test uniformity or intensity range. |
| `b` | Main | 3-D Array | Stack of all candidate blocks at the current level (`curr_size × curr_size × N`), built for `decision_method == 2` and passed to `fun` in a single vectorized call. |
| `rbc` | Main | Matrix | Bottom-right corner coordinates corresponding to each row of `offsets`, used to slice `I` when building `b`. |
| `nd` | Main | Matrix | Subset of `offsets` for which `db` is `%f` (i.e. blocks that will not be split); appended to `res` at the current `curr_size`. |
| `otemp` | Main | Matrix | Subset of `offsets` for which `db` is `%t` (i.e. blocks selected for subdivision into four children). |
| `hs`, `zs` | Main | Matrix | Half-step and zero-step offset matrices used to generate the four children's corner coordinates from `otemp`. |
| `x`, `v` | Main | Matrix / Vector | Final block coordinates (`res(:,1:2)`) and corresponding block sizes (`res(:,3)`), passed to `sparse()` to build `S`. |

---
## Helper Functions

| Function | Type | Purpose |
| --- | --- | --- |
| `argn()` | Built-in | Determines the number of input arguments supplied to the function (`argn(2)`). |
| `error()` | Built-in | Raises an error and halts execution for invalid arguments or unsatisfiable size constraints. |
| `issquare()` | Built-in | Verifies that `I` is a square matrix before decomposition begins. |
| `typeof()` | Built-in | Distinguishes function handles / inline functions from numeric thresholds, and detects `uint8`/`uint16` image classes for threshold rescaling. |
| `isreal()` | Built-in | Confirms that `p1` (and, where relevant, `dims`) is numeric rather than a function handle. |
| `isvector()` | Built-in | Checks whether the third argument is a two-element `[mindim maxdim]` vector or a single scalar `mindim`. |
| `ceil()`, `log2()` | Built-in | Compute the number of mandatory pre-splits needed to bring the initial block size down to `maxdim`. |
| `modulo()` | Built-in | Checks divisibility of `curr_size` by `divs` (forced pre-split) and parity of `curr_size` (whether a level can still be halved). |
| `kron()` | Built-in | Builds the full grid of row/column offsets for the mandatory pre-split, via Kronecker products of the 1-D offset vector `els`. |
| `max()`, `min()` | Built-in | Used to test block uniformity (`decision_method == 0`) and intensity range (`decision_method == 1`). |
| `find()` | Built-in | Selects the rows of `offsets` corresponding to blocks marked for splitting (`db`) versus blocks finalized (`~db`). |
| `zeros()`, `ones()` | Built-in | Construct the candidate-block stack `b`, and the constant-size columns appended to `res`. |
| `sparse()` | Built-in | Assembles the final sparse decomposition matrix `S` from block coordinates `x` and sizes `v`. |
| `fun(b, varargin(:))` | User-supplied | Custom decision function for `decision_method == 2`; receives the full stack of candidate blocks and any extra arguments, and must return a boolean vector of split decisions. |

---

### Decision Methods at a Glance

| `decision_method` | Trigger | Split Rule |
| --- | --- | --- |
| `0` | No second argument supplied | Split unless every pixel in the block is identical (`max(blk) == min(blk)`). |
| `1` | Numeric `p1` (threshold) | Split unless the block's intensity range (`max - min`) is `≤ threshold`. |
| `2` | `p1` is a function handle / inline function | Split according to the boolean vector returned by `fun(stack_of_blocks, varargin(:))`. |

---
## Time & Space Complexity:

Let `M × M` be the size of the (square) image `I`, and let `L = log2(M)` be the maximum possible quadtree depth.

Time Complexity: `O(M² · log M)` in the worst case — at each of up to `L` quadtree levels, every pixel belonging to a still-active block is touched once by the split-decision test (`max`/`min` over the block, or one call to `fun`), and the total pixel count examined per level is at most `M²`; summed over `O(log M)` levels this gives `O(M² log M)`. In the common case where most blocks terminate early (large uniform regions), actual runtime is much closer to `O(M²)`.

Space Complexity: `O(M²)` — dominated by the output sparse matrix `S` (same dimensions as `I`) and, transiently, the candidate-block stack `b` in function-handle mode (`O(curr_size² · N)`, bounded by `O(M²)` per level).

---

## Mathematical Foundation

### Quadtree Recursion

Given a square block `B` of side length `s` at top-left corner `(r, c)`:

```text
split(B) = true   if the chosen decision rule says so
split(B) = false  if s/2 < mindim, or s is odd, or the rule says "stop"
```

If `split(B) = true`, `B` is replaced by four child blocks of side `s/2`:

```text
B₀₀ = (r,       c)
B₀₁ = (r,       c + s/2)
B₁₀ = (r + s/2, c)
B₁₁ = (r + s/2, c + s/2)
```

each of which is recursively re-evaluated.

### Decision Rule 0 — Uniform Value

```text
split(B) = false  iff  max(B) = min(B)
```

i.e. a block is left un-split only if every pixel within it has exactly the same value.

### Decision Rule 1 — Intensity Range Threshold

```text
split(B) = false  iff  ( max(B) − min(B) ) ≤ T
```

where `T` is the supplied `threshold`, rescaled to `255·T` or `65535·T` when `I` is `uint8` or `uint16` respectively, so that a threshold expressed in `[0,1]` maps onto the image's native integer intensity range.

### Decision Rule 2 — Custom Function

```text
db = fun(b, extra_args...)
```

where `b` is a `s × s × N` stack of every currently-candidate block at the current quadtree level, and `db` is an `N`-element boolean vector: `db(k) = true` means block `k` should be split.

### Mandatory Pre-Split for `maxdim`

If `maxdim < M`, the number of mandatory splits needed before the main loop begins is:

```text
initial_splits = ceil( log2(M / maxdim) )
divs = 2^initial_splits
curr_size = M / divs            (requires M mod divs = 0)
```

This guarantees no block larger than (approximately) `maxdim` is ever evaluated, independent of the chosen decision rule.

### Output Encoding

```text
S(r, c) = s     if (r, c) is the top-left corner of a final block of side s
S(r, c) = 0     otherwise

sum over all final blocks of s² = M²     (the blocks exactly tile the image)
```

### Output Range

```text
mindim ≤ s ≤ maxdim     for every nonzero entry s of S
nnz(S) ≥ 1
```

---
## Test Cases:

The following 20 test cases use small, hand-constructed images so that the expected decomposition can be verified by inspection. Run the test script:

```scilab
exec('qtdecomp_test.sce', -1);
```

### Test Case: 1 — 1×1 Image

Verifies that `qtdecomp` correctly handles the smallest possible image and returns a valid quadtree decomposition without attempting further subdivision.

```scilab
I = 1;
S = full(qtdecomp(I));
```

**Expected output:** 
* A valid decomposition matrix is returned.
* No subdivision occurs.
* The single pixel is represented as one block.

**Observation:**
Since the image contains only one pixel, no splitting is possible. The algorithm should terminate immediately and represent the image as a single quadtree block.

---
### Test Case: 2 — Odd-Sized Identity Matrix (5×5)

Verifies that non-power-of-two square images are correctly padded internally and decomposed.

```scilab
I = eye(5,5);
S = full(qtdecomp(I));
```

**Expected output:** 
* Decomposition succeeds without errors.
* Internal padding is handled automatically.
* Blocks containing diagonal transitions may be subdivided.

**Observation:**
The identity matrix contains strong intensity changes along the diagonal. The decomposition should split regions that contain both zero and nonzero values while preserving homogeneous regions.

---
### Test Case: 3 — Even-Sized Identity Matrix (6×6)

Verifies decomposition behavior for an even-sized square image that is not a power of two.

```scilab
I = eye(6,6);
S = full(qtdecomp(I));
```

**Expected output:** 
* Successful decomposition.
* Internal resizing or padding is handled automatically.
* Non-uniform regions are subdivided.

**Observation:**
The diagonal structure introduces local intensity variations that force subdivision around transition regions.

---
### Test Case 4 — Power-of-Two Identity Matrix (8×8)

Verifies standard quadtree decomposition on an image whose dimensions already satisfy power-of-two requirements.

```scilab
I = eye(8,8);
S = full(qtdecomp(I));
```

**Expected output:** 
* No padding is required.
* Regions intersecting the diagonal are subdivided.
* Uniform regions remain large blocks.

**Observation:**
This represents the ideal input size for quadtree decomposition and serves as a baseline validation case.

---
### Test Case: 5 — Near-Uniform Image

Verifies sensitivity to small localized intensity changes.

```scilab
I = ones(8,8);
I(4:5,4:5) = 3;

S = full(qtdecomp(I));
```

**Expected output:** 
* Most of the image remains a large block.
* The altered central region triggers local subdivision.
* Splitting is concentrated near the intensity change.

**Observation:**
Only a small region differs from the background intensity. The quadtree should isolate that region while avoiding unnecessary subdivision elsewhere.

---
### Test Case: 6 — Uniform Zero Image

Verifies that a completely homogeneous image is not subdivided.

```scilab
I = zeros(8,8);
S = full(qtdecomp(I));
```

**Expected output:** 
* A single large block represents the image.
* No recursive splitting occurs.
* Splitting is concentrated near the intensity change.

**Observation:**
Since all pixels have identical values, the image satisfies the homogeneity criterion at the largest possible scale.

---
### Test Case: 7 — Checkerboard Pattern

Verifies decomposition of a highly nonuniform image.

```scilab
I = [
0 1 0 1;
1 0 1 0;
0 1 0 1;
1 0 1 0
];

S = full(qtdecomp(I));
```

**Expected output:** 
* Extensive subdivision occurs.
* Many blocks reach the minimum allowable size.
* Fine image detail is preserved.

**Observation:**
Every neighboring pixel differs in intensity, forcing repeated subdivision throughout the image.

---
### Test Case: 8 — Threshold = 0

Verifies strict homogeneity testing.

```scilab
I = [
1 1 1 1;
1 1 1 1;
1 1 2 2;
1 1 2 2
];

S = full(qtdecomp(I,0));
```

**Expected output:** 
* Any intensity variation triggers subdivision.
* Mixed-value regions are recursively split.
* Only perfectly uniform blocks remain unsplit.

**Observation:**
A threshold of zero enforces exact equality within every block.

---

### Test Case: 9 — Threshold = 1

Verifies relaxed decomposition behavior.

```scilab
I = [
1 1 1 1;
1 1 1 1;
1 1 2 2;
1 1 2 2
];

S = full(qtdecomp(I,1));
```

**Expected output:** 
* Fewer subdivisions compared with Test Case 8.
* Regions differing by at most one intensity level may remain unsplit.

**Observation:**
The larger threshold increases tolerance to variation and therefore reduces decomposition depth.

---

### Test Results

Each test case can be checked by comparing the nonzero entries of `S` (their positions and values) against the expected block layout described above; mismatches indicate a regression in either the decision-rule evaluation or the offset/child-generation logic.

---

## Compatibility Notes

This function is a Scilab translation of GNU Octave's `qtdecomp` function (from the Octave `image` package) and preserves the same three decision modes (uniform-value, threshold, and function-handle) and the same `[mindim maxdim]` size-restriction semantics.

### Important Differences from GNU Octave

* **Function-handle detection.** Octave uses `typeinfo()` to detect function handles and inline functions; this port uses Scilab's `typeof()`, checking for `"function"`, `"function handle"`, `"inline function"`, and `"fptr"` to cover variations across Scilab versions. Passing a function-like object whose `typeof()` doesn't match one of these strings will be misinterpreted as a numeric threshold and will likely error out at `isreal(p1)`.

* **`find()` used for boolean selection.** Where Octave can index directly with a logical vector (`offsets(~db,:)`), this port explicitly calls `find(~db)` and `find(db)` to obtain index lists before indexing `offsets`. This is functionally equivalent but means `db` must be a true `%t`/`%f` boolean vector — a numeric `0`/`1` vector returned from a custom `fun` may behave correctly under `find()`'s automatic coercion, but this has not been exhaustively verified for all numeric edge cases.

* **`sparse()` call signature differs from Octave.** Octave builds the result with `S = sparse(res(:,1), res(:,2), res(:,3), size(I,1), size(I,2))` (separate row/column/value vectors). Scilab's `sparse()` instead takes a combined `[row col]` index matrix, a value vector, and a `[rows cols]` size vector: `S = sparse(x, v, [size(I,1), size(I,2)])`. The two calls are equivalent in effect but not in argument layout.

* **`rem()` replaced by `modulo()`.** Both divisibility checks (`maxdim` pre-split, and the odd/even check on `curr_size` inside the main loop) use Scilab's `modulo()` in place of Octave's `rem()`. For the non-negative integer sizes involved here, the two functions agree, but they are not interchangeable in general (they differ in sign handling for negative operands).

* **Threshold rescaling is type-driven, not range-driven.** The threshold is multiplied by `255` or `65535` purely based on `typeof(I)` being `"uint8"` or `"uint16"`; a `double`-typed image holding integer pixel values in `[0,255]` (e.g. loaded but not cast to `uint8`) will **not** receive this rescaling, and the threshold will be interpreted directly against the raw pixel values instead.

* **No explicit validation of `fun`'s return type or size.** If a custom decision function returns a vector of the wrong length (not matching the number of candidate blocks `N`), or a non-boolean type that `find()` cannot meaningfully interpret, the error surfaced will come from a downstream indexing failure rather than a descriptive message from `qtdecomp` itself.

* **`varargin(:)` forwarding to `fun`.** Extra arguments beyond `p1` and `dims` are collected into `varargin` and forwarded to `fun` as `fun(b, varargin(:))`, i.e. as a single list-valued argument, rather than Octave's `feval(fun, b, varargin{:})` argument-splatting. A `fun` written expecting separately-named extra arguments (rather than a single collected list) will need to be adapted.

---

### Recommended Usage

```scilab
// Default: split until every block is internally uniform
S = qtdecomp(I);

// Threshold-based: split until every block's intensity range is within 10
S = qtdecomp(I, 10);

// Threshold-based, with explicit size bounds
S = qtdecomp(I, 10, [2 64]);

// Custom decision rule (e.g. based on variance, entropy, edge content, etc.)
function db = myrule(b, varargin)
    n = size(b, 3);
    db = zeros(1, n);
    for k = 1:n
        db(k) = (stdev(b(:,:,k)) > 3);
    end
endfunction
S = qtdecomp(I, myrule);

// Retrieve the actual block contents afterward
[vals, r, c] = qtgetblk(I, S, 4);
```

* Use the default (no second argument) only on already-segmented or label-style images where exact uniformity is meaningful; for natural images, a numeric `threshold` or custom `fun` is almost always more useful.
* When working with `uint8`/`uint16` images, remember that a numeric `threshold` is automatically rescaled to the image's native range — pass `threshold` as a fraction of full-scale (e.g. in `[0,1]`) if this is the behavior you want, or be aware of the rescaling if you intended an absolute pixel-value threshold.
* Always pair `qtdecomp` with `qtgetblk` to retrieve the actual pixel content of the blocks it identifies; `S` on its own only encodes positions and sizes, not pixel values.
* If you need a guaranteed maximum block size regardless of how uniform the image is, supply `[mindim maxdim]` explicitly rather than relying on the decision rule alone to produce small enough blocks.

---

## References

[1] GNU Octave Image Package Documentation — `qtdecomp`.

[2] MATLAB Image Processing Toolbox Documentation — `qtdecomp`, `qtgetblk`.

[3] S. L. Tanimoto, T. Pavlidis, "A hierarchical data structure for picture processing," *Computer Graphics and Image Processing*, 1975. (Foundational reference for quadtree image representations.)
