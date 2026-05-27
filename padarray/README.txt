Function Name: padarray

Description:
This function pads an input matrix by adding rows and columns around it.
Padding can be done using a constant value.

Calling Sequence:
padarray(A, [m n])
padarray(A, [m n], padval)

Parameters:
A      : Input matrix (image)
[m n]  : Padding size (m rows, n columns added on each side)
padval : Padding value (optional, default = 0)

Output:
Returns a new matrix with padded values.

Implementation Details:
- Creates a larger matrix initialized with padval
- Inserts original matrix in the center
- Padding is applied symmetrically on all sides

Time Complexity:
O((N+2m) × (M+2n)), where N×M is input size

--------------------------------------------------

Test Cases:

--------------------------------------------------

Test Case 1: Basic Zero Padding

Input:
A = [1 2; 3 4]
padarray(A, [1 1])

Output (Scilab & Octave):
0 0 0 0
0 1 2 0
0 3 4 0
0 0 0 0

--------------------------------------------------

Test Case 2: Custom Padding Value

Input:
A = [1 2; 3 4]
padarray(A, [1 1], 5)

Output (Scilab & Octave):
5 5 5 5
5 1 2 5
5 3 4 5
5 5 5 5

--------------------------------------------------

Test Case 3: Large Padding

Input:
A = [1 2; 3 4]
padarray(A, [3 3])

Output (Scilab & Octave):
Matrix padded with 3 layers of zeros around the original matrix
   0 0 0 0 0 0 0 0 
   0 0 0 0 0 0 0 0 
   0 0 0 0 0 0 0 0 
   0 0 0 1 2 0 0 0
   0 0 0 3 4 0 0 0
   0 0 0 0 0 0 0 0 
   0 0 0 0 0 0 0 0 
   0 0 0 0 0 0 0 0 
--------------------------------------------------

Test Case 4: Non-square Padding

Input:
A = [1 2 3; 4 5 6]
padarray(A, [1 3])

Output (Scilab & Octave):
Matrix padded with 1 row and 3 columns on each side
   0 0 0 0 0 0 0 0 0
   0 0 0 1 2 3 0 0 0
   0 0 0 4 5 6 0 0 0
   0 0 0 0 0 0 0 0 0
--------------------------------------------------

Test Case 5: Single Element

Input:
A = 7
padarray(A, [2 2])

Output (Scilab & Octave):
0 0 0 0 0
0 0 0 0 0
0 0 7 0 0
0 0 0 0 0
0 0 0 0 0

--------------------------------------------------

Test Case 6: Single Row

Input:
A = [1 2 3 4]
padarray(A, [2 1])

Output (Scilab & Octave):
Matrix padded correctly for single row input
0 0 0 0 0 0
0 0 0 0 0 0
0 1 2 3 4 0
0 0 0 0 0 0
0 0 0 0 0 0

--------------------------------------------------

Test Case 7: Single Column

Input:
A = [1; 2; 3]
padarray(A, [1 2])

Output (Scilab & Octave):
Matrix padded correctly for single column input
0 0 0 0 0
0 0 1 0 0
0 0 2 0 0
0 0 3 0 0
0 0 0 0 0

--------------------------------------------------

Test Case 8: Floating Padding Value

Input:
A = [1 2; 3 4]
padarray(A, [1 1], 0.5)

Output (Scilab & Octave):
0.5 0.5 0.5 0.5
0.5 1.  2.  0.5
0.5 3.  4.  0.5
0.5 0.5 0.5 0.5

--------------------------------------------------

Test Case 9: Random Matrix

Input:
A = rand(4,4)
padarray(A, [2 2])

Output (Scilab & Octave):

   0.   0.   0.          0.          0.          0.          0.   0.
   0.   0.   0.          0.          0.          0.          0.   0.
   0.   0.   0.53348     0.9729812   0.9085803   0.3339654   0.   0.
   0.   0.   0.6415191   0.9247447   0.4832384   0.7584898   0.   0.
   0.   0.   0.9838433   0.6269157   0.947345    0.9842256   0.   0.
   0.   0.   0.1047427   0.8968578   0.2367064   0.180841    0.   0.
   0.   0.   0.          0.          0.          0.          0.   0.
   0.   0.   0.          0.          0.          0.          0.   0.

--------------------------------------------------

Test Case 10: No Padding

Input:
A = [1 2; 3 4]
padarray(A, [0 0])

Output (Scilab & Octave):
1 2
3 4

--------------------------------------------------

Test Case 11: Negative Padding (Error Case)

Input:
padarray([1 2; 3 4], [-1 1])

Output (Scilab & Octave):
Error handled correctly

--------------------------------------------------

Test Case 12: Empty Input (Error Case)

Input:
padarray([], [1 1])

Output (Scilab & Octave):
Error handled correctly
