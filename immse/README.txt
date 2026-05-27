Function Name: immse

Description:
This function computes the Mean Squared Error (MSE) between two images.
It measures the average squared difference between corresponding pixel values.

Calling Sequence:
immse(A, B)

Parameters:
A : First input image (matrix)
B : Second input image (must be same size as A)

Output:
Returns a scalar value representing the Mean Squared Error.

Implementation Details:
- Computes element-wise difference
- Squares the difference
- Takes mean of all elements

Formula:
MSE = mean((A - B)^2)

Time Complexity:
O(N × M), where N×M is the size of the image

--------------------------------------------------

Test Cases:

--------------------------------------------------

Test Case 1: Identical Images

Input:
A = [5 5; 5 5]

Output:
Scilab: 0
Octave: 0

--------------------------------------------------

Test Case 2: Small difference

Input:
B = [4 6; 5 5]

Output:
Scilab: 0.5
Octave: 0.5000

--------------------------------------------------

Test Case 3: Large difference

Input:
B = zeros(2,2)

Output:
Scilab: 25
Octave: 25

--------------------------------------------------

Test Case 4: Floating values

Input:
A = rand(4,4)
B = rand(4,4)

Output:
Scilab: 0.1512799
Octave: 0.1379

--------------------------------------------------

Test Case 5: Negative Values

Input:
A = [-1 -2; 3 4]
B = [1 2; -3 -4]

Output:
Scilab: 30
Octave: 30

--------------------------------------------------

Test Case 6: Size mismatch (error)

Input:
A = [1 2]
B = [1 2 3]

Output:
Scilab: Error handled correctly
Octave: Error handled correctly

--------------------------------------------------

Test Case 7: Zero Images

Input:
A = zeros(3,3)
B = zeros(3,3)

Output:
Scilab: 0
Octave: 0

--------------------------------------------------

Test Case 8: One Zero, One Non-zero

Input:
A = zeros(3,3)
B = ones(3,3)*10

Output:
Scilab: 100
Octave: 100

--------------------------------------------------

Test Case 9: Large Values

Input:
A = [1000 2000; 3000 4000]
B = [1100 1900; 3100 3900]

Output:
Scilab: 10000
Octave: 10000

--------------------------------------------------

Test Case 10: Single Element

Input:
A = 5
B = 10

Output:
Scilab: 25
Octave: 25

--------------------------------------------------

Test Case 11: Floating Precision Check

Input:
A = [0.1 0.2; 0.3 0.4]
B = [0.1 0.25; 0.35 0.45]

Output:
Scilab: 0.0018750
Octave: 1.8750e-03
--------------------------------------------------

Test Case 12: Large Random Matrix

Input:
A = rand(50,50)
B = rand(50,50)

Output:
Scilab: 0.1653938
Octave: 0.1718
