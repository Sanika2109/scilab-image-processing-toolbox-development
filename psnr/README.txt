Function Name: psnr

Description:
This function computes the Peak Signal-to-Noise Ratio (PSNR) between two images.
PSNR is used to measure the quality of a reconstructed or compressed image compared to the original.

Calling Sequence:
psnr(A, B)
psnr(A, B, peakval)

Parameters:
A       : First input image (matrix)
B       : Second input image (must be same size as A)
peakval : Maximum possible pixel value (optional, default = 255)

Output:
Returns a scalar value representing PSNR in decibels (dB).

Implementation Details:
- First computes Mean Squared Error (MSE)
- Then applies formula:
  PSNR = 10 * log10((peakval^2) / MSE)
- If MSE = 0 → PSNR = Infinity

Time Complexity:
O(N × M), where N×M is the size of the image

--------------------------------------------------

Test Cases:

--------------------------------------------------

Test Case 1: Identical Images

Input:
A = [10 20; 30 40]
B = [10 20; 30 40]

Output:
Scilab: Inf
Octave: Inf

--------------------------------------------------

Test Case 2: All Zeros

Input:
A = zeros(3,3)
B = zeros(3,3)

Output:
Scilab: Inf
Octave: Inf

--------------------------------------------------

Test Case 3: Constant Matrices (Different Values)

Input:
A = ones(3,3)*50
B = ones(3,3)*100

Output:
Scilab: -33.979400
Octave: -33.979

--------------------------------------------------

Test Case 4: Negative Values

Input:
A = [-1 -2; 3 4]
B = [1 2; -3 -4]

Output:
Scilab: -14.771213
Octave: -14.771

--------------------------------------------------

Test Case 5: Floating Point Values

Input:
A = [0.1 0.2; 0.3 0.4]
B = [0.1 0.25; 0.35 0.45]

Output:
Scilab: 27.269987
Octave: 27.270

--------------------------------------------------

Test Case 6: Single Element

Input:
A = 5
B = 10

Output:
Scilab: -13.979400
Octave: -13.979

--------------------------------------------------

Test Case 7: Random Matrix

Input:
A = rand(3,3)
B = rand(3,3)

Output:
Scilab: 6.9325084
Octave: 7.9288

--------------------------------------------------

Test Case 8: Different Peak Value

Input:
A = [10 20; 30 40]
B = [12 18; 33 39]
peakval = 255

Output:
Scilab: 41.598678
Octave: 41.599

--------------------------------------------------

Test Case 9: High Dynamic Range Values

Input:
A = [1000 2000; 3000 4000]
B = [1100 1900; 3100 3900]

Output:
Scilab: -40.000000
Octave: -40

--------------------------------------------------

Test Case 10: Binary Image

Input:
A = [0 1; 1 0]
B = [1 0; 0 1]

Output:
Scilab: 0
Octave: 0

--------------------------------------------------

Test Case 11: Mixed Sign Values

Input:
A = [-10 0; 10 20]
B = [10 0; -10 -20]

Output:
Scilab: -27.781513
Octave: -27.782
--------------------------------------------------

Test Case 12: Large Random Matrix

Input:
A = rand(50,50)*255
B = rand(50,50)*255

Output:
Scilab:-40.180783
Octave: -40.320
