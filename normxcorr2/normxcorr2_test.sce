base = get_absolute_file_path("normxcorr2_test.sce");
exec(base + "../postpad/postpad.sci", -1);
exec(base + "normxcorr2.sci", -1);

//--------------------------------------------------
// TEST 1 : Basic Matching Template
//--------------------------------------------------
disp("TEST 1 : Basic Matching Template");

A = [1 2;
     3 4];

B = [0 0 0;
     1 2 0;
     3 4 0];

C = normxcorr2(A,B);
disp("Output:");
disp(C);
mprintf("\n");

//--------------------------------------------------
// TEST 2 : Rectangular Template Matching
//--------------------------------------------------
disp("TEST 2 : Rectangular Template Matching");

A = [2 4 1;
     7 3 5];

B = [1 0 2 1 3;
     4 2 4 1 0;
     7 3 5 2 1;
     2 6 1 4 5;
     3 1 2 7 6];

C = normxcorr2(A, B);
disp("Output:");
disp(C);
mprintf("\n");

//--------------------------------------------------
// TEST 3 : Floating Point Inputs
//--------------------------------------------------
disp("TEST 3 : Floating Point Inputs");

A = [0.5 1.5;
     2.5 3.5];

B = [1.1 2.2 3.3;
     4.4 5.5 6.6;
     7.7 8.8 9.9];

C = normxcorr2(A,B);
disp("Output:");
disp(C);
mprintf("\n");

//--------------------------------------------------
// TEST 4 : Negative Values
//--------------------------------------------------
disp("TEST 4 : Negative Values");

A = [-1 -2;
      3  4];

B = [-4 -3 -2;
     -1  0  1;
      2  3  4];

C = normxcorr2(A,B);
disp("Output:");
disp(C);
mprintf("\n");

//--------------------------------------------------
// TEST 5 : Single Pixel Template
//--------------------------------------------------
disp("TEST 5 : Single Pixel Template");

A = [5];

B = [1 2 3;
     4 5 6;
     7 8 9];

C = normxcorr2(A,B);
disp("Output:");
disp(C);
mprintf("\n");

//--------------------------------------------------
// TEST 6 : Template Equals Image
//--------------------------------------------------
disp("TEST 6 : Template Equals Image");

A = [2 1;
     4 3];

B = [2 1;
     4 3];

C = normxcorr2(A,B);
disp("Output:");
disp(C);
mprintf("\n");

//--------------------------------------------------
// TEST 7 : Template Larger Than Image
//--------------------------------------------------
disp("TEST 7 : Template Larger Than Image");

A = [1 2 3;
     4 5 6;
     7 8 9];

B = [1 2;
     3 4];

C = normxcorr2(A,B);
disp("Output:");
disp(C);
mprintf("\n");

//--------------------------------------------------
// TEST 8 : Constant Template
//--------------------------------------------------
disp("TEST 8 : Constant Template");

A = ones(2,2);

B = [1 2 3;
     4 5 6;
     7 8 9];

C = normxcorr2(A,B);
disp("Output:");
disp(C);
mprintf("\n");

//--------------------------------------------------
// TEST 9 : Larger Image with Repeated Pattern
//--------------------------------------------------
disp("TEST 9 : Larger Image with Repeated Pattern");

A = [1 2;
     3 4];

B = [1 2 1 2;
     3 4 3 4;
     1 2 1 2;
     3 4 3 4];

C = normxcorr2(A,B);
disp("Output:");
disp(C);
mprintf("\n");

//--------------------------------------------------
// TEST 10 : Invalid Number of Arguments
//--------------------------------------------------
disp("TEST 10 : Invalid Number of Arguments");

try
    normxcorr2([1 2;3 4]);
catch
    disp(lasterror());
end
