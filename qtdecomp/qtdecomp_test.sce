base = get_absolute_file_path("qtdecomp_test.sce");
exec(base + "qtdecomp.sci", -1);

//--------------------------------------------------
// Test 1 : 1x1 Image
//--------------------------------------------------
disp("TEST 1 : 1x1 Image");

I = 1;
S = full(qtdecomp(I));

disp(S);
mprintf("\n");


//--------------------------------------------------
// Test 2 : Odd-sized identity matrix (5x5)
//--------------------------------------------------
disp("TEST 2 : eye(5,5)");

I = eye(5,5);
S = full(qtdecomp(I));

disp(S);
mprintf("\n");


//--------------------------------------------------
// Test 3 : Even-sized identity matrix (6x6)
//--------------------------------------------------
disp("TEST 3 : eye(6,6)");

I = eye(6,6);
S = full(qtdecomp(I));

disp(S);
mprintf("\n");


//--------------------------------------------------
// Test 4 : Power-of-two identity matrix (8x8)
//--------------------------------------------------
disp("TEST 4 : eye(8,8)");

I = eye(8,8);
S = full(qtdecomp(I));

disp(S);
mprintf("\n");


//--------------------------------------------------
// Test 5 : Near-uniform image (edge sensitivity test)
//--------------------------------------------------
disp("TEST 5 : Near-uniform Image");

I = ones(8,8);
I(4:5,4:5) = 3;   

S = full(qtdecomp(I));

disp(S);
mprintf("\n");


//--------------------------------------------------
// Test 6 : All zeros image
//--------------------------------------------------
disp("TEST 6 : Zero Image");

I = zeros(8,8);
S = full(qtdecomp(I));

disp(S);
mprintf("\n");


//--------------------------------------------------
// Test 7 : Checkerboard image
//--------------------------------------------------
disp("TEST 7 : Checkerboard");

I = [
0 1 0 1;
1 0 1 0;
0 1 0 1;
1 0 1 0
];

S = full(qtdecomp(I));

disp(S);
mprintf("\n");


//--------------------------------------------------
// Test 8 : Threshold = 0
//--------------------------------------------------
disp("TEST 8 : Threshold 0");

I = [
1 1 1 1;
1 1 1 1;
1 1 2 2;
1 1 2 2
];

S = full(qtdecomp(I,0));

disp(S);
mprintf("\n");


//--------------------------------------------------
// Test 9 : Threshold = 1
//--------------------------------------------------
disp("TEST 9 : Threshold 1");

I = [
1 1 1 1;
1 1 1 1;
1 1 2 2;
1 1 2 2
];

S = full(qtdecomp(I,1));

disp(S);
mprintf("\n");


//--------------------------------------------------
// Test 10 : mindim = 2 (strict stopping validation)
//--------------------------------------------------
disp("TEST 10 : mindim = 2 (strict behavior)");

I = [
1 1 2 2 3 3 4 4;
1 1 2 2 3 3 4 4;
5 5 6 6 7 7 8 8;
5 5 6 6 7 7 8 8;
9 9 10 10 11 11 12 12;
9 9 10 10 11 11 12 12;
13 13 14 14 15 15 16 16;
13 13 14 14 15 15 16 16
];

S = full(qtdecomp(I, 0, 4));

disp(S);

// ---- validation check ----
disp("Block uniqueness check (should NOT contain 1x1 splitting artifacts):");
disp(length(find(S == 1)));
mprintf("\n");


//--------------------------------------------------
// Test 11 : mindim/maxdim restriction 
//--------------------------------------------------
disp("TEST 11 : mindim=2 maxdim=4");

I = [
1 1 1 1  2 2 2 2;
1 1 1 1  2 2 2 2;
1 1 1 1  2 2 2 2;
1 1 1 1  2 2 2 2;

3 3 3 3  4 4 4 4;
3 3 3 3  4 4 4 4;
3 3 3 3  4 4 4 4;
3 3 3 3  4 4 4 4
];

S = full(qtdecomp(I, 0, [2 4]));

disp(S);
mprintf("\n");


//--------------------------------------------------
// Test 12 : Octave regression matrix A
//--------------------------------------------------
disp("TEST 12 : Octave Regression A");

A=[ 1, 4, 2, 5,54,55,61,62;
    3, 6, 3, 1,58,53,67,65;
    3, 6, 3, 1,58,53,67,65;
    3, 6, 3, 1,58,53,67,65;
   23,42,42,42,99,99,99,99;
   27,42,42,42,99,99,99,99;
   23,22,26,25,99,99,99,99;
   22,22,24,22,99,99,99,99];

S = full(qtdecomp(A));

disp(S);
mprintf("\n");


//--------------------------------------------------
// Test 13 : Regression matrix A threshold=5
//--------------------------------------------------
disp("TEST 13 : A threshold=5");

S = full(qtdecomp(A,5));

disp(S);
mprintf("\n");


//--------------------------------------------------
// Test 14 : Regression matrix A threshold=10
//--------------------------------------------------
disp("TEST 14 : A threshold=10");

S = full(qtdecomp(A,10));

disp(S);
mprintf("\n");


//--------------------------------------------------
// Test 15 : Function-handle mode
//--------------------------------------------------
disp("TEST 15 : Function Handle");
function y = first_eq(B, varargin)
    y = squeeze(B(1,1,:) <> 54);
    y = y(:);
endfunction

S = full(qtdecomp(A, first_eq));

disp(S);
mprintf("\n");


//--------------------------------------------------
// Test 16 : Non-square image 
//--------------------------------------------------
disp("TEST 16 : Non-square image");

try
    I = rand(4,5);
    qtdecomp(I);
catch
    disp(lasterror());
end

mprintf("\n");


//--------------------------------------------------
// Test 17 : Invalid mindim/maxdim
//--------------------------------------------------
disp("TEST 17 : Invalid dimensions");

try
    I = eye(8,8);
    qtdecomp(I,0,[4 2]);
catch
    disp(lasterror());
end

mprintf("\n");


//--------------------------------------------------
// Test 18 : Large uniform image
//--------------------------------------------------
disp("TEST 18 : Large Uniform Image");

I = ones(64,64);

S = full(qtdecomp(I));

disp(S(1:8,1:8));
mprintf("\n");

//--------------------------------------------------
// Test 19: uint8 scaling behavior
//--------------------------------------------------
disp("TEST 19 : uint8 image");

I = uint8(ones(4,4)*10);
S = full(qtdecomp(I, 0.1));
disp(S);

//--------------------------------------------------
// Test 20 : Sparse structure 
//--------------------------------------------------
disp("TEST 20 : Sparse Output");

I = [
1 1 2 2;
1 1 2 2;
3 3 4 4;
3 3 4 4
];

S = qtdecomp(I);

disp(typeof(S));
disp(full(S));

mprintf("\n");
