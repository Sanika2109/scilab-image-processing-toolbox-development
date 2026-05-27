Function Name: medfilt2 

Description:
medfilt2 (2D Median Filter) is a nonlinear image filtering technique used to remove salt-and-pepper noise while preserving edges better than linear filters such as averaging filters. The median filtering replaces a pixel with the median value of pixels in a neighborhood window.

Calling Sequence:
J = medfilt2(I)
J = medfilt2(I,[m n])
J = medfilt2(___,padopt)

Parameters:
I      : Input matrix (image)
[m n]  : Filter size window - [3 3] (default). Can also be [5 5], [7 7], [9 9]
padopt : Padding Options:-
          "zeros" (default): Pads with the value 0 (same as passing a PADVAL of 0).           
          "circular": Pads with a circular repetition of elements in A.
          "replicate": Pads replicating the values at the border of A.
          "symmetric": Pads with a mirror reflection of A.
          "reflect": Same as "symmetric", but the borders are not used in the padding. 

Output:
Returns as a numeric matrix of the same data type as the input image I.

Algorithm:-

Step 1: Read input image I, window size, and padding option
Step 2: Determine window dimensions and validate they are odd
Step 3: Calculate required padding size
Step 4: Apply selected padding to the image
Step 5: Initialize output matrix
Step 6: Slide the window over each pixel of the image
Step 7: Extract neighboring pixels within the window
Step 8: Convert window values into an array and compute the median
Step 9: Assign the median value to the corresponding output pixel
Step 10: Repeat for all pixels and return the filtered image

Implementation:-

1. Start

2. Read input image 'I', window size 'windowsize', and padding option 'padopt'

3. Determine window dimensions:
   If 'windowsize' is a scalar:
     * m = windowsize
     * n = windowsize
   Else:
     * m = windowsize(1)
     * n = windowsize(2)

4. Check validity of window dimensions:
   If m or n is even:
     * Display "Window dimensions must be odd"
     * Stop execution

5. Obtain image dimensions:
   * row = number of rows
   * col = number of columns

6. Calculate padding sizes:
   * k1 = floor(m/2)
   * k2 = floor(n/2)

7. Apply selected padding:
   * If 'padopt' = replicate → Apply replicate padding
   * If 'padopt' = symmetric → Apply symmetric padding
   * If 'padopt' = reflect → Apply reflect padding
   * If 'padopt' = circular → Apply circular padding
   * If 'padopt' = zero → Create zero matrix and insert image
   * Otherwise → Display "Invalid padding option"` and stop

8. Create output matrix median_filter of size row × col

9. Traverse through each pixel of image:
   For each row i
   For each column j
   a. Extract neighborhood window from padded image
   b. Convert window into a vector
   c. Compute median of all values
   d. Store median value in output image

10. Repeat until all pixels are processed

11. Return filtered image median_filter

12. Stop


Time Complexity:
O(MxN), where MxN is input size of image

--------------------------------------------------

Test Cases:

--------------------------------------------------
Test Case 1: Salt-and-Pepper Noise Image

Input:
A = imread("saltandpepper.jpg");
B = medfilt2(A,[3 3],"replicate");

Output:
Scilab & Octave: Salt-and-pepper noise reduced while preserving image edges.

--------------------------------------------------

Test Case 2: Large Filter Window [5×5]

Input:
A = imread("saltandpepper.jpg");
B = medfilt2(A,[5 5],"replicate");

Output:
Scilab & Octave: Stronger noise reduction but image becomes smoother with some detail loss.

--------------------------------------------------

Test Case 3: Zero Padding

Input:
A = imread("saltandpepper.jpg");
B = medfilt2(A,[3 3],"zero");

Output:
Scilab & Octave: Noise reduced; dark borders may appear due to zero padding.

--------------------------------------------------

Test Case 4: Replicate Padding

Input:
A = imread("saltandpepper.jpg");
B = medfilt2(A,[3 3],"replicate");

Output:
Scilab & Octave: Border pixels replicated, preserving edge continuity.

--------------------------------------------------

Test Case 5: Circular Padding

Input:
A = imread("saltandpepper.jpg");
B = medfilt2(A,[3 3],"circular");

Output:
Scilab & Octave: Border values wrap around from opposite sides of image.

--------------------------------------------------

Test Case 6: Single Pixel Image

Input:
A = [150];
B = medfilt2(A,[3 3],"replicate");

Output:
Scilab & Octave: Output remains unchanged as only one pixel exists.

  150

--------------------------------------------------

Test Case 7: Small 2×2 Image

Input:
A = [10 20;
     30 40];
B = medfilt2(A,[3 3],"replicate");

Output:
Scilab & Octave: Median values generated using replicated borders.

  20  20
  30  30

--------------------------------------------------

Test Case 8: Filter Larger Than Image

Input:
A = [10 20;
     30 40];
B = medfilt2(A,[5 5],"replicate");

Output:
Scilab & Octave: Image processed successfully using extensive padding.

  20  20
  30  30

--------------------------------------------------

Test Case 9: Uniform Image

Input:
A = ones(100,100)*128;
B = medfilt2(A,[3 3],"replicate");

Output:
Scilab & Octave: Output image remains unchanged.

--------------------------------------------------

Test Case 10: Extreme Noise Pixel

Input:
A = [10 20 30;
     40 255 50;
     60 70 80];
B = medfilt2(A,[3 3],"replicate");

Output:
Scilab & Octave: Extreme noise value replaced with neighborhood median.

  20  30  30
  40  50  50
  60  70  80

--------------------------------------------------

Test Case 11: Reflect Padding

Input:
A = imread("saltandpepper.jpg");
B = medfilt2(A,[3 3],"reflect");

Output:
Scilab & Octave: Border values reflected excluding edge pixels.

--------------------------------------------------

Test Case 12: Symmetric Padding

Input:
A = imread("saltandpepper.jpg");
B = medfilt2(A,[3 3],"symmetric");

Output:
Scilab & Octave: Border values mirrored including edge pixels.

--------------------------------------------------

Test Case 13: Rectangular Window [3×5]

Input:
A = imread("saltandpepper.jpg");
B = medfilt2(A,[3 5],"replicate");

Output:
Scilab & Octave: Noise reduced using a rectangular filtering window.

--------------------------------------------------

Test Case 14: Rectangular Window [5×7]

Input:
A = imread("saltandpepper.jpg");
B = medfilt2(A,[5 7],"replicate");

Output:
Scilab & Octave: Increased smoothing with larger rectangular window.

--------------------------------------------------

Test Case 15: Window Same Size as Image

Input:
A = [10 20 30;
     40 50 60;
     70 80 90];
B = medfilt2(A,[3 3],"replicate");

Output:
Scilab & Octave: Median calculated using the entire image region.

 20  30  30
 40  50  60
 70  70  80

--------------------------------------------------

Test Case 16: Single Row Image

Input:
A = [10 50 100 200 255];
B = medfilt2(A,[3 3],"replicate");

Output:
Scilab & Octave: Domain array cannot be larger than the data array.

--------------------------------------------------

Test Case 17: Single Column Image

Input:
A = [10;
     50;
     100;
     200;
     255];
B = medfilt2(A,[3 3],"replicate");

Output:
Scilab & Octave: Domain array cannot be larger than the data array.

--------------------------------------------------

Test Case 18: Gradient Image

Input:
A = repmat(1:100,100,1);
B = medfilt2(A,[3 3],"replicate");

Output:
Scilab & Octave: Gradient preserved with slight smoothing.

--------------------------------------------------

Test Case 19: Random Noise Image

Input:
A = rand(100,100)*255;
B = medfilt2(A,[3 3],"replicate");

Output:
Scilab & Octave: Random intensity fluctuations reduced.

--------------------------------------------------

Test Case 20: Invalid Padding Option

Input:
B = medfilt2(A,[3 3],"abc");

Output:
Scilab & Octave: Error displayed — "Invalid padding option".

--------------------------------------------------

Test Case 21: Even Window Size

Input:
B = medfilt2(A,[4 4],"replicate");

Output:
Scilab & Octave: Displayed "Window dimensions must be odd".

--------------------------------------------------

Test Case 22: Empty Image

Input:
A = [];
B = medfilt2(A,[3 3],"replicate");

Output:
Scilab & Octave: A must be a real matrix.
