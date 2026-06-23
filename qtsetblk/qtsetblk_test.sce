base = get_absolute_file_path("qtsetblk_test.sce");
exec(base + "qtsetblk.sci", -1);

//--------------------------------------------------
// Test 1 : Replace top-left 2x2 block in existing image
//--------------------------------------------------
disp("TEST 1 : Replace Top-Left 2x2 Block");

I = [10 11 12 13;
     20 21 22 23;
     30 31 32 33;
     40 41 42 43];

S = zeros(4,4);
S(3,3) = 2;

vals = [100 101;
        102 103];

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

disp("Replacement Block:");
disp(vals);

J = qtsetblk(I,S,2,vals);

disp("Output:");
disp(J);

mprintf("\n");

//--------------------------------------------------
// Test 2 : Four 2x2 Quadrants with unique values
//--------------------------------------------------
disp("TEST 2 : Four 2x2 Quadrants");

I = [10 11 12 13;
     20 21 22 23;
     30 31 32 33;
     40 41 42 43];

S = zeros(4,4);
S(1,1) = 2;
S(1,3) = 2;
S(3,1) = 2;
S(3,3) = 2;

vals(:,:,1) = [101 102;
               103 104];

vals(:,:,2) = [201 202;
               203 204];

vals(:,:,3) = [301 302;
               303 304];

vals(:,:,4) = [401 402;
               403 404];

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

disp("Replacement Blocks:");
disp(vals);

J = qtsetblk(I,S,2,vals);

disp("Output:");
disp(J);

mprintf("\n");

//--------------------------------------------------
// Test 3 : Single 1x1 Block in existing image
//--------------------------------------------------
disp("TEST 3 : Single 1x1 Block");

I = [11 12 13 14 15;
     21 22 23 24 25;
     31 32 33 34 35;
     41 42 43 44 45;
     51 52 53 54 55];

S = zeros(5,5);
S(3,3) = 1;

vals = 999;

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

disp("Replacement Value:");
disp(vals);

J = qtsetblk(I,S,1,vals);

disp("Output:");
disp(J);

mprintf("\n");

//--------------------------------------------------
// Test 4 : 4x4 Block inside a larger image
//--------------------------------------------------
disp("TEST 4 : 4x4 Block in Larger Image");

I = [11 12 13 14 15 16;
     21 22 23 24 25 26;
     31 32 33 34 35 36;
     41 42 43 44 45 46;
     51 52 53 54 55 56;
     61 62 63 64 65 66];

S = zeros(6,6);
S(2,2) = 4;

vals = [100 101 102 103;
        110 111 112 113;
        120 121 122 123;
        130 131 132 133];

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

disp("Replacement Block:");
disp(vals);

J = qtsetblk(I,S,4,vals);

disp("Output:");
disp(J);

mprintf("\n");

//--------------------------------------------------
// Test 5 : Replace center 2x2 block in existing image
//--------------------------------------------------
disp("TEST 5 : Center 2x2 Block");

I = [11 12 13 14 15 16;
     21 22 23 24 25 26;
     31 32 33 34 35 36;
     41 42 43 44 45 46;
     51 52 53 54 55 56;
     61 62 63 64 65 66];

S = zeros(6,6);
S(3,3) = 2;

vals = [100 101;
        102 103];

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

disp("Replacement Block:");
disp(vals);

J = qtsetblk(I,S,2,vals);

disp("Output:");
disp(J);

mprintf("\n");

//--------------------------------------------------
// Test 6 : Mixed Decomposition Sizes
//--------------------------------------------------
disp("TEST 6 : Mixed Decomposition Sizes");

I = [ 1  2  3  4  5  6  7  8;
      9 10 11 12 13 14 15 16;
     17 18 19 20 21 22 23 24;
     25 26 27 28 29 30 31 32;
     33 34 35 36 37 38 39 40;
     41 42 43 44 45 46 47 48;
     49 50 51 52 53 54 55 56;
     57 58 59 60 61 62 63 64];

S = zeros(8,8);

// Different block sizes
S(1,1) = 4;   // Should be ignored
S(1,5) = 2;   // Should be replaced
S(5,1) = 2;   // Should be replaced
S(7,7) = 1;   // Should be ignored

vals(:,:,1) = [100 101;
               102 103];

vals(:,:,2) = [200 201;
               202 203];

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

disp("Replacement Block:");
disp(vals);

J = qtsetblk(I,S,2,vals);

disp("Output:");
disp(J);

mprintf("\n");

//--------------------------------------------------
// Test 7 : No Matching Blocks
//--------------------------------------------------
disp("TEST 7 : No Matching Blocks");

I = [11 12 13 14 15 16;
     21 22 23 24 25 26;
     31 32 33 34 35 36;
     41 42 43 44 45 46;
     51 52 53 54 55 56;
     61 62 63 64 65 66];

S = zeros(6,6);

// Only 4x4 and 1x1 blocks exist
S(1,1) = 4;
S(5,5) = 1;

vals = [100 101;
        102 103];

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

disp("Replacement Block:");
disp(vals);

J = qtsetblk(I,S,2,vals);

disp("Output:");
disp(J);

mprintf("\n");

//--------------------------------------------------
// Test 8 : Empty S with non-empty vals
//--------------------------------------------------
disp("TEST 8 : Empty S");

I = [1 2 3;
     4 5 6;
     7 8 9];

S = zeros(3,3);

vals = [99 98;
        97 96];

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

disp("Replacement Block:");
disp(vals);

J = qtsetblk(I,S,2,vals);

disp("Output:");
disp(J);

mprintf("\n");

//--------------------------------------------------
// Test 9 : Extra Pages in vals
//--------------------------------------------------
disp("TEST 9 : Extra Pages");

I = [11 12 13 14;
     21 22 23 24;
     31 32 33 34;
     41 42 43 44];

S = zeros(4,4);
S(2,2) = 2;

vals(:,:,1) = [100 101;
               102 103];

vals(:,:,2) = [999 999;
               999 999];

vals(:,:,3) = [-1 -1;
               -1 -1];

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

disp("Replacement Block:");
disp(vals);

J = qtsetblk(I,S,2,vals);

disp("Output:");
disp(J);
mprintf("\n");

//--------------------------------------------------
// Test 10 : Error - Insufficient Pages
//--------------------------------------------------
disp("TEST 10 : Error - Insufficient Pages");

I = [1 2 3 4;
     5 6 7 8;
     9 10 11 12;
     13 14 15 16];

S = zeros(4,4);
S(1,1) = 2;
S(3,3) = 2;   // 2 matching blocks

clear vals;

vals(:,:,1) = [100 101;
               102 103];

// Missing vals(:,:,2)

disp("Input Image:");
disp(I);

disp("Decomposition Matrix:");
disp(S);

disp("Replacement Block:");
disp(vals);

try
    J = qtsetblk(I,S,2,vals);
catch
    disp("Error:");
    disp(lasterror());
end

mprintf("\n");
