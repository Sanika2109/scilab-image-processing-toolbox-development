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
