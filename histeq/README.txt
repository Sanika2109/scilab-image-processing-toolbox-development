Function Name: histeq (available in Octave and MATLAB only)

Description:
This function is used to redistribute the pixels across the image to improve the image contrast. This technique is known as histogram equalization.

Calling Sequence:
histeq(Img)
histeq(Img,bins)

Parameters:
Img    : Input matrix (image)
bins   : Number of intensity levels

Output:
Returns an image with improved image contrast.

Algorithm:
Step 1: Read input image - imread()
Step 2: Convert image into grayscale - rgb2gray() is used and Convert it into uint8()
Step 3: Calculate image histogram for the provided intensity level - hist = zeroes(1, bins) 
Step 4: Compute cumulative histogram for the provided intensity level - cum_hist = zeroes(1, bins)
Step 5: Normalize cumulative values - cum_hist/Number of pixels
Step 6: Remap intensity values
Step 7: Display enhanced image - imshow(enhanced_img)

Implementation:

1. Start
2. Read input image I and histogram level L.
3. Check whether L is provided by the user.

   * If No, set L = 256 (default for an 8-bit image).
   * If Yes, use the provided value.

4. Convert input image I into uint8 format.
5. Convert RGB image into a grayscale image using `rgb2gray()`.
6. Convert grayscale image into double format.
7. Determine image dimensions (rows and columns).
8. Compute total number of pixels: `pixel_val = row × col`
9. Scale image intensity values to the range [0, L−1].
10. Initialize histogram array with zeros of size L.
11. Traverse each pixel of the image and compute the histogram by counting occurrences of intensity values.
12. Compute the cumulative histogram (CDF) using `cumsum()`.
13. Normalize cumulative histogram values: `cumm_norm = cumm_hist / pixel_val`
14. Compute new intensity values using: `new_intensity = round((L−1) × cumm_norm)`
15. Traverse the image again and replace each pixel intensity with the corresponding new intensity value.
16. Rescale intensity values back to [0,255].
17. Convert output image back into uint8 format.
18. Return the histogram-equalized image `equi_hist`.
19. End

Time Complexity:
O(MxN), where MxN is input size

--------------------------------------------------

Test Cases:

--------------------------------------------------
Test Case 1: Bright Image

Input:
A = imread("bright_cimg.jpg");
B = histeq(A);

Output:
Scilab & Octave: Bright image contrast enhanced, details become more balanced after equalization.

--------------------------------------------------

Test Case 2: Dark Image

Input:

A = imread("dark_cimage.jpeg");
B = histeq(A);

Output:
Scilab & Octave: Dark image brightness and visibility improved after histogram equalization.

--------------------------------------------------

Test Case 3: Low Contrast Image

Input:

A = imread("lc_cimage.jpeg");
B = histeq(A);

Output:
Scilab & Octave: Contrast stretched, image details become clearer and sharper.

--------------------------------------------------

Test Case 4: Too Few Bins (4 bins)

Input:

A = imread("dog.jpg");
B = histeq(A,4);

Output:
Scilab & Octave: Image appears over-quantized with loss of detail due to insufficient histogram bins.

--------------------------------------------------

Test Case 5: Too Many Bins (512 bins)

Input:

A = imread("dog.jpg");
B = histeq(A,512);

Output:
Scilab & Octave: Histogram equalization applied with very fine bin distribution; introduces minor noise amplification.

--------------------------------------------------

Test Case 6: Adequate Number of Bins (256 bins)

Input:

A = imread("dog.jpg");
B = histeq(A,256);

Output:
Scilab & Octave: Proper histogram equalization with balanced contrast enhancement and preserved image details.