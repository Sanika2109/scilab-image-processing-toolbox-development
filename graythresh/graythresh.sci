function varargout = graythresh(img, algo, varargin)

    // Default argument handling
    rhs = argn(2);

    if rhs < 1 | rhs > 3 then
        error("graythresh: Wrong number of input arguments.");
    end
    
    // Default algorithm is Otsu
    if rhs < 2 then
        algo = "otsu";
    end

    // Only percentile accepts extra options
    if rhs > 2 & convstr(algo, "l") <> "percentile" then
        error("graythresh: algorithm does not accept any options.");
    end

    hist_in = %f;
    
    // Input validation
    if ~isnumeric(img) then
        error("graythresh: IMG must be numeric");

    elseif size(img, 3) == 3 then
         // Convert RGB image to grayscale if needed
        img = rgb2gray(img);

    elseif isfloat(img) & isvector(img) & ~issparse(img) & ..
           isreal(img) & and(img >= 0) then
        // If input is already histogram-like vector
        hist_in = %t;
        ihist = img;

    end

// SIMPLE MEAN THRESHOLD METHOD

    if convstr(algo, "l") == "mean" then
       varargout = list(mean(im2double(img)(:)));
       return;
    end

    // HISTOGRAM CONSTRUCTION
    if ~hist_in then

        if isa(img, "uint16") | isa(img, "uint8") then
            // do nothing

        elseif isa(img, "int16") then
            img = im2uint16(img);

        else
            img = im2uint8(img);

        end

    // Build histogram
        
        nbins = double(intmax(typeof(img))) + 1;
        ihist = zeros(1, nbins);

        pixels = double(img(:));

        for k = 1:length(pixels)
            ihist(pixels(k) + 1) = ihist(pixels(k) + 1) + 1;
        end

    end

 // SELECT THRESHOLDING METHOD
    select convstr(algo, "l")

        case "concavity" then
            thresh = concavity(ihist);

        case "intermeans" then
            thresh = intermeans(ihist, double(floor(mean(double(img(:))))));

        case "intermodes" then
            thresh = intermodes(ihist);

        case "maxentropy" then
            thresh = maxentropy(ihist);

        case "maxlikelihood" then
            thresh = maxlikelihood(ihist);

        case "minerror" then
            thresh = minerror_iter(ihist, double(floor(mean(double(img(:))))));

        case "minimum" then
            thresh = minimum(ihist);

        case "moments" then
            thresh = moments(ihist);

        case "otsu" then
            thresh = otsu(ihist, argn(1) > 1);

        case "percentile" then
           // Percentile-based threshold
           if length(varargin) == 0 then
              thresh = percentile(ihist);
           else
              thresh = percentile(ihist, varargin(1));
           end

        else
            error(msprintf("graythresh: unknown method", algo));

    end

    // Normalize threshold value to [0,1]
    if numel(ihist) > 1 then
       thresh(1) = double(thresh(1)) / (numel(ihist) - 1);
    end
 
    varargout = thresh;

endfunction

// OTSU THRESHOLDING METHOD
// Finds a threshold that minimizes variance within foreground and background.
function thresh = otsu(ihist, compute_good)

    thresh = list();

    if size(ihist, "*") == 1 | sum(ihist) == 0 then
        thresh(1) = 0;
        thresh(2) = 0;
        return;
    end

    bins = 0:(size(ihist, "*") - 1);
    total = sum(ihist);

    // b = black, w = white
    b_totals = cumsum([0 ihist(1:$-1)]);
    b_weights = b_totals ./ total;

    b_means = [0 cumsum(bins(1:$-1) .* ihist(1:$-1))] ./ b_totals;

    w_totals = total - b_totals;
    w_weights = w_totals ./ total;

    temp = cumsum(bins($:-1:1) .* ihist($:-1:1));
    temp = temp ./ w_totals($:-1:1);
    w_means = temp($:-1:1);

    // between-class variance
    bcv = b_weights .* w_weights .* (b_means - w_means).^2;

    max_bcv = max(bcv);

    if isnan(max_bcv) then

        thresh(1) = 0;
        thresh(2) = 0;

    else

        thresh(1) = mean(find(bcv == max_bcv)) - 2;

        if compute_good then

            norm_hist = ihist ./ total;

            total_mean = sum(bins .* norm_hist);

            total_variance = sum(((bins - total_mean).^2) .* norm_hist);

            thresh(2) = max_bcv / total_variance;

        end

    end

endfunction

// MOMENTS METHOD
// Chooses a threshold based on matching statistical moments (mean, variance) of the histogram.
function level = moments(y)

    level = list();

    n = numel (y) - 1;

    // The threshold is chosen such that
    // partial_sumA(y,t)/partial_sumA(y,n)
    // is closest to x0.

    sumY = sum(y);
    Avec = cumsum(y) ./ sumY;

    sumB = partial_sumB(y, n);
    sumC = partial_sumC(y, n);
    sumD = partial_sumD(y, n);

    x2 = (sumB * sumC - sumY * sumD) / (sumY * sumC - sumB^2);
    x1 = (sumB * sumD - sumC^2) / (sumY * sumC - sumB^2);

    x0 = 0.5 - (sumB / sumY + x2 / 2) / sqrt(x2^2 - 4 * x1);

    [dummy, ind] = min(abs(Avec - x0));

    level(1) = ind - 1;

endfunction

// MAX ENTROPY METHOD
// Chooses threshold that maximizes information (entropy) of the two classes.
function T = maxentropy(y)

    T = list();

    n = numel (y) - 1;
    
    //warning ("off", "Octave:divide-by-zero", "local");
    
    // The threshold is chosen such that the following
    // expression is minimized.

    sumY = sum(y);
    negY = negativeE(y, n);

    vec = zeros(1, n + 1);

    for j = 0:n

        sumA = partial_sumA(y, j);
        negE = negativeE(y, j);

        sum_diff = sumY - sumA;

        vec(j + 1) = negE / sumA ..
                   - log10(sumA) ..
                   + (negY - negE) / sum_diff ..
                   - log10(sum_diff);

    end

    [dummy, ind] = min(vec);

    T(1) = ind - 1;

endfunction

// INTERMODES METHOD
// Picks threshold at the valley between two histogram peaks.
function T = intermodes(y)

    T = list();

    n = numel (y) - 1;

    // Smooth the histogram by iterative three-point mean filtering.
    iter = 0;

    while ~bimodtest(y)

        h = ones(1, 3) / 3;

        y = conv2(y, h, "same");

        iter = iter + 1;

        // If the histogram turns out not to be bimodal,
        // set T to zero.
        if iter > 10000 then
            T(1) = 0;
            return;
        end

    end

    // The threshold is the mean of the two peaks
    // of the histogram.

    ind = 0;
    TT = [];

    for k = 2:n

        if y(k-1) < y(k) & y(k+1) < y(k) then

            ind = ind + 1;
            TT(ind) = k - 1;

        end

    end

    T(1) = floor(mean(TT));

endfunction


// PERCENTILE THRESHOLDING METHOD
// Selects a threshold at a chosen cumulative intensity percentage
function T = percentile(y, p)
    
    // Default value of p is 0.5 (median threshold)
    if argn(2) < 2 then
        p = 0.5;
    end
    // Compute cumulative distribution function (CDF)
    Avec = cumsum(y) / sum(y);
    // Find index where CDF is closest to p
    [m, ind] = min(abs(Avec - p));
    // Return threshold index (adjusted for zero-based intensity)
    T = list(ind - 1);

endfunction

// MINIMUM METHOD
// Uses the lowest point in the histogram or intensity distribution as the threshold.
function T = minimum(y)

    T = list();

    n = numel (y) - 1;

    // Step 1: Smooth histogram until it becomes bimodal
    iter = 0;

    while ~bimodtest(y)
        
        // 3-point mean smoothing filter
        h = ones(1, 3) / 3;

        // Apply convolution
        y = conv2(y, h, "same");

        iter = iter + 1;

        // If the histogram turns out not to be bimodal,
        // set T to zero.
        if iter > 10000 then
            T(1) = 0;
            return;
        end

    end

    // Step 2: Find first peak and then valley after it
    peakfound = %f;

    for k = 2:n
        // Detect local maxima (peak)
        if y(k-1) < y(k) & y(k+1) < y(k) then
            peakfound = %t;
        end
        // After peak, find local minimum (valley)
        if peakfound & y(k-1) >= y(k) & y(k+1) >= y(k) then
            T(1) = k - 1;
            return;
        end

    end

    // Fallback if no valley found 
    T(1) = 0;

endfunction

// MINIMUM ERROR ITERATIVE METHOD
// Iteratively refines a threshold to minimize classification error between foreground and background.
function Tout = minerror_iter(y, T)

    Tout = list();

    n = numel (y) - 1;
    
    // Previous threshold value (for convergence check)
    Tprev = %nan;
    
    // warning ("off", "Octave:divide-by-zero", "local");
    
    // Global histogram statistics
    sumA = partial_sumA(y, n);
    sumB = partial_sumB(y, n);
    sumC = partial_sumC(y, n);

    while T <> Tprev

        // Compute left class statistics (<= T)
        sumAT = partial_sumA(y, T);
        sumBT = partial_sumB(y, T);
        sumCT = partial_sumC(y, T);
        
        // Right class statistics (> T)
        sumAdiff = sumA - sumAT;

        // Guard against division by zero (empty class)
        if sumAT == 0 | sumAdiff == 0 then
            break;
        end
        
        // Mean of both classes
        mu = sumBT / sumAT;
        nu = (sumB - sumBT) / sumAdiff;

        // Class probabilities
        p = sumAT / sumA;
        q = sumAdiff / sumA;

        // Variances of both classes
        sigma2 = sumCT / sumAT - mu^2;
        tau2   = (sumC - sumCT) / sumAdiff - nu^2;

        // Guard against zero or negative variance
        if sigma2 <= 0 | tau2 <= 0 then
            break;
        end

        // Quadratic equation parameters for threshold update
        w0 = 1 / sigma2 - 1 / tau2;
        w1 = mu / sigma2 - nu / tau2;
        w2 = mu^2 / sigma2 - nu^2 / tau2 ..
           + log10((sigma2 * q^2) / (tau2 * p^2));

       // Check if solution becomes invalid (complex root)
        sqterm = w1^2 - w0 * w2;

        if sqterm < 0 then
            warning('MINERROR:NaN','Warning: th_minerror_iter did not converge.')
            break;
        end

         // Update threshold using quadratic solution
        Tprev = T;
        T = double(floor((w1 + sqrt(sqterm)) / w0));

        // Clamp T to valid histogram range
        T = max(0, min(T, n));

        // Check for invalid result
        if isnan(T) then
            warning('MINERROR:NaN','Warning: th_minerror_iter did not converge.')
            T = Tprev;
        end

    end

    // Final threshold output
    Tout(1) = T;

endfunction

// MAXLIKELIHOOD METHOD
// Chooses the threshold that maximizes the probability of 
// observing the given pixel intensities under assumed distributions.
function Tout = maxlikelihood(y)

    Tout = list();

    n = numel (y) - 1;

    // Initial threshold estimate
    tmp = minimum(y);
    T = tmp(1);

    sumY = sum(y);

    sumB = partial_sumB(y, n);
    sumC = partial_sumC(y, n);

    sumAT = partial_sumA(y, T);
    sumBT = partial_sumB(y, T);
    sumCT = partial_sumC(y, T);

    // Initial class statistics
    mu     = sumBT / sumAT;
    nu     = (sumB - sumBT) / (sumY - sumAT);
    p      = sumAT / sumY;
    q      = (sumY - sumAT) / sumY;
    
    sigma2 = sumCT / sumAT - mu^2;
    tau2   = (sumC - sumCT) / (sumY - sumAT) - nu^2;

    // Return if sigma2 or tau2 are zero
    if sigma2 == 0 | tau2 == 0 then
        Tout(1) = T;
        return;
    end
    
    while %t

        // Store previous iteration values for convergence check
        mu_prev     = mu;
        nu_prev     = nu;
        p_prev      = p;
        q_prev      = q;
        sigma2_prev = nu;
        tau2_prev   = nu;

        phi = zeros(1, n + 1);

        for i = 0:n

            // Posterior probability of class 1
            phi(i + 1) = ..
                (p / sqrt(sigma2)) * exp(-((i - mu)^2) / (2 * sigma2)) ..
                / ..
                ((p / sqrt(sigma2)) * exp(-((i - mu)^2) / (2 * sigma2)) + ..
                 (q / sqrt(tau2))  * exp(-((i - nu)^2) / (2 * tau2)));

        end

        ind = 0:n;

        gamma = 1 - phi;

        // Weighted sums for parameter re-estimation
        F = phi * y';
        G = gamma * y';

        mu = (ind .* phi) * y' / F;
        nu = (ind .* gamma) * y' / G;

        p = F / sumY;
        q = G / sumY;

        sigma2 = ((ind.^2) .* phi) * y' / F - mu^2;
        tau2   = ((ind.^2) .* gamma) * y' / G - nu^2;

        // Convergence check
        if abs(mu - mu_prev) <= %eps | ..
           abs(nu - nu_prev) <= %eps | ..
           abs(p - p_prev) <= %eps | ..
           abs(q - q_prev) <= %eps | ..
           abs(sigma2 - sigma2_prev) <= %eps | ..
           abs(tau2 - tau2_prev) <= %eps then
            break;
        end

    end

    // Parameters for quadratic threshold equation
    w0 = 1 / sigma2 - 1 / tau2;
    w1 = mu / sigma2 - nu / tau2;

    w2 = mu^2 / sigma2 ..
       - nu^2 / tau2 ..
       + log10((sigma2 * q^2) / (tau2 * p^2));

    // If threshold would be imaginary
    sqterm = w1^2 - w0 * w2;

    if sqterm < 0 then
        Tout(1) = 0;
        return;
    end

    // Final threshold value
    Tout(1) = floor((w1 + sqrt(sqterm)) / w0);

endfunction

// INTERMEANS METHOD
// Repeatedly sets threshold as the average of foreground 
// and background means until convergence.
function Tout = intermeans(y, T)

    Tout = list();

    n = numel (y) - 1;

    Tprev = %nan;

    sumY = sum(y);
    sumB = partial_sumB(y, n);

    // Iteratively update threshold 
    while double(T) <> double(Tprev)

        sumAT = partial_sumA(y, T);
        sumBT = partial_sumB(y, T);

        // Guard against an empty class (all pixels on one side of T),
        // which would otherwise divide by zero and send T to nan/inf,
        // crashing the next call to partial_sumA.
        if sumAT == 0 | (sumY - sumAT) == 0 then
            break
        end

        mu = sumBT / sumAT;
        nu = (sumB - sumBT) / (sumY - sumAT);

        Tprev = T;
        
        // New threshold is midpoint of class means
        T = double(floor((mu + nu) / 2));

    end

    Tout(1) = T;

endfunction

// CONCAVITY METHOD
// Finds threshold based on curvature change (concave region) in the histogram, 
// often near valley points between peaks.
function T = concavity(h)

    T = list();

    n = numel (h) - 1;

    H = hconvhull(h);

    // Local maxima of deviation from convex hull
    lmax = flocmax(H - h);

    // Balance measure for each histogram index
    E = zeros(1, n + 1);

    for k = 0:n
        E(k + 1) = hbalance(h, k);
    end

    // Select best local maximum based on balance
    E = E .* lmax;

    [dummy, ind] = max(E);

    T(1) = ind - 1;

endfunction


function x = partial_sumA (y, j)
  j = double(j);
  x = sum (y(1:j+1));
endfunction

function x = partial_sumB (y, j)
  j = double(j);
  ind = 0:j;
  x = ind*y(1:j+1)';
endfunction

function x = partial_sumC (y, j)
  j = double(j);
  ind = 0:j;
  x = ind.^2*y(1:j+1)';
endfunction

function x = partial_sumD (y, j)
  j = double(j);
  ind = 0:j;
  x = ind.^3*y(1:j+1)';
endfunction

// Test if a histogram is bimodal.
function b = bimodtest(y)
  len = length(y);
  b = %f;
  modes = 0;

// Count local maxima; reject if more than 2 modes
  for k = 2:len-1
    if y(k-1) < y(k) & y(k+1) < y(k)
      modes = modes+1;
      if modes > 2
        return
      end
    end
  end

  // Valid bimodal only if exactly 2 modes
  if modes == 2
    b = %t;
  end
endfunction

// Find the local maxima of a vector using a three point neighborhood.
function y = flocmax(x)

    // y : binary vector with maxima of x marked as ones

    len = length(x);

    y = zeros(1, len);

    for k = 2:(len - 1)

        [dummy, ind] = max(x(k - 1 : k + 1));

        if ind == 2 then
            y(k) = 1;
        end

    end

endfunction

// Calculate the balance measure of the histogram around a histogram index.

function E = hbalance(y,ind)
//  y    histogram
//  ind  index about which balance is calculated
//
// Out:
//  E    balance measure
  n = length(y)-1;
  E = partial_sumA(y,ind)*(partial_sumA(y,n)-partial_sumA(y,ind));
  
endfunction

//// Find the convex hull of a histogram.
function H = hconvhull(h)

    // In:
    //   h : histogram
    //
    // Out:
    //   H : convex hull of histogram

    len = length(h);

    K = [];
    K(1) = 1;

    k = 1;

    // The vector K gives the locations
    // of the vertices of the convex hull.

    while K(k) <> len

        theta = zeros(1, len - K(k));

        for i = (K(k) + 1):len

            x = i - K(k);
            y = h(i) - h(K(k));

            theta(i - K(k)) = atan(y, x); 

        end

        maximum = max(theta);

        maxloc = find(theta == maximum);

        k = k + 1;

        K(k) = maxloc($) + K(k - 1);

    end

    H = zeros(1, len);

    // Linear interpolation between hull points
    for i = 2:length(K)

        H(K(i - 1):K(i)) = ..
            h(K(i - 1)) ..
          + (h(K(i)) - h(K(i - 1))) ..
          / (K(i) - K(i - 1)) ..
          * (0:(K(i) - K(i - 1)));

    end

endfunction

//Entropy function for histogram segment
function x = negativeE(y, j)

    y = y(1:j+1);
    

    // Keep only nonzero elements to avoid log issues
    y = y(find(y <> 0));

    x = sum(y .* log10(y));

endfunction


//Helper functions

//isnumeric function
function tf = isnumeric(x)
    tf = or(type(x) == [1 5 8]);
endfunction

//isfloat function
function tf = isfloat(x)
    tf = (type(x) == 1);
endfunction

//numel function
function n = numel(x)
    n = size(x, "*");
endfunction
