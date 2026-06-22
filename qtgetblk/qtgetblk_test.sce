base = get_absolute_file_path("qtgetblk_test.sce");
exec(base + "qtgetblk.sci", -1);

//--------------------------------------------------
// Test 1 : Single 4x4 Block
//--------------------------------------------------
disp("TEST 1 : Single 4x4 Block");

I = magic(4);

S = zeros(4,4);
S(1,1) = 4;

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

[B,r,c] = qtgetblk(I,S,4);

disp("Blocks:");
disp(B(:,:,1));

disp("Rows:");
disp(r);

disp("Cols:");
disp(c);

mprintf("\n");

//--------------------------------------------------
// Test 2 : Four 2x2 Quadrants
//--------------------------------------------------
disp("TEST 2 : Four 2x2 Quadrants");

I = [ 1  2  5  6;
      3  4  7  8;
      9 10 13 14;
     11 12 15 16];

S = zeros(4,4);
S(1,1) = 2;
S(1,3) = 2;
S(3,1) = 2;
S(3,3) = 2;

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

[B,r,c] = qtgetblk(I,S,2);

disp("Block 1:");
disp(B(:,:,1));

disp("Block 2:");
disp(B(:,:,2));

disp("Block 3:");
disp(B(:,:,3));

disp("Block 4:");
disp(B(:,:,4));

disp("Rows:");
disp(r);

disp("Cols:");
disp(c);

mprintf("\n");


//--------------------------------------------------
// Test 3 : Mixed Block Sizes
//--------------------------------------------------
disp("TEST 3 : Mixed Block Sizes");

I = matrix(1:64,8,8);

S = zeros(8,8);
S(1,1) = 4;
S(1,5) = 2;
S(5,1) = 2;
S(7,7) = 1;

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

[B,r,c] = qtgetblk(I,S,2);

disp("Blocks:");
disp(B);

disp("Rows:");
disp(r);

disp("Cols:");
disp(c);

mprintf("\n");

//--------------------------------------------------
// Test 4 : Corner 1x1 Blocks
//--------------------------------------------------
disp("TEST 4 : Corner 1x1 Blocks");

I = magic(4);

S = zeros(4,4);
S(1,1) = 1;
S(1,4) = 1;
S(4,1) = 1;
S(4,4) = 1;

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

[B,r,c] = qtgetblk(I,S,1);

disp("Blocks:");
disp(B);

disp("Rows:");
disp(r);

disp("Cols:");
disp(c);

mprintf("\n");


//--------------------------------------------------
// Test 5 : Central 2x2 Block
//--------------------------------------------------
disp("TEST 5 : Central 2x2 Block");

I = matrix(1:36,6,6);

S = zeros(6,6);
S(3,3) = 2;

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

[B,r,c] = qtgetblk(I,S,2);

disp("Blocks:");
disp(B(:,:,1));

disp("Rows:");
disp(r);

disp("Cols:");
disp(c);

mprintf("\n");


//--------------------------------------------------
// Test 6 : No Matching Block Size
//--------------------------------------------------
disp("TEST 6 : No Matching Block Size");

I = magic(4);

S = zeros(4,4);
S(1,1) = 4;

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

[B,r,c] = qtgetblk(I,S,2);

disp("Blocks:");
disp(B);

disp("Rows:");
disp(r);

disp("Cols:");
disp(c);

mprintf("\n");

//--------------------------------------------------
// Test 7 : Empty Decomposition Matrix
//--------------------------------------------------
disp("TEST 7 : Empty S");

I = magic(4);

S = zeros(4,4);

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

[B,r,c] = qtgetblk(I,S,2);

disp("Blocks:");
disp(B);

disp("Rows:");
disp(r);

disp("Cols:");
disp(c);

mprintf("\n");


//--------------------------------------------------
// Test 8 : Scattered 2x2 Blocks
//--------------------------------------------------
disp("TEST 8 : Scattered 2x2 Blocks");

I = matrix(1:64,8,8);

S = zeros(8,8);
S(1,5) = 2;
S(5,1) = 2;
S(5,5) = 2;

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

[B,r,c] = qtgetblk(I,S,2);

disp("Rows:");
disp(r);

disp("Cols:");
disp(c);

disp("Block 1:");
disp(B(:,:,1));

disp("Block 2:");
disp(B(:,:,2));

disp("Block 3:");
disp(B(:,:,3));

mprintf("\n");


//--------------------------------------------------
// Test 9 : Two-output form (linear indices)
//--------------------------------------------------
disp("TEST 9 : Two Outputs");

I = matrix(1:16,4,4);

S = zeros(4,4);
S(1,1) = 2;
S(3,3) = 2;

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

[B,idx] = qtgetblk(I,S,2);

disp("Blocks:");
disp(B);

disp("Linear Indices:");
disp(idx);
mprintf("\n");


//--------------------------------------------------
// Test 10 : One-output form
//--------------------------------------------------
disp("TEST 10 : One Output");

I = matrix(1:16,4,4);

S = zeros(4,4);
S(1,1) = 2;

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

B = qtgetblk(I,S,2);

disp("Blocks:");
disp(B);
mprintf("\n");


//--------------------------------------------------
// Test 11 : Error - Invalid number of inputs
//--------------------------------------------------
disp("TEST 11 : Error Case");

try
    qtgetblk();
catch
    disp(lasterror());
end

mprintf("\n");
