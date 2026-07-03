base = get_absolute_file_path("padarray_test.sce");
exec(base + "padarray.sci", -1);

A = [1 2;
     3 4];

// --------------------------------------------------
// Test 1 : Default Zero Padding (Both)
// --------------------------------------------------
disp("Test 1 : Default Zero Padding");
disp(padarray(A,[1 1]));
mprintf("\n");

// --------------------------------------------------
// Test 2 : Explicit Zeros Padding (PRE)
// --------------------------------------------------
disp("Test 2 : Explicit Zeros Padding (PRE)");
disp(padarray(A,[2 1],"zeros","pre"));
mprintf("\n");

// --------------------------------------------------
// Test 3 : Constant Padding (POST)
// --------------------------------------------------
disp("Test 3 : Constant Padding (POST)");
disp(padarray(A,[1 2],5,"post"));
mprintf("\n");

// --------------------------------------------------
// Test 4 : Complex Padding (%i) (BOTH)
// --------------------------------------------------
disp("Test 4 : Complex Padding (%i)");
disp(padarray(A,[1 1],%i,"both"));
mprintf("\n");

// --------------------------------------------------
// Test 5 : Circular Padding (Large Padding)
// --------------------------------------------------
disp("Test 5 : Circular Padding");
disp(padarray(A,[4 5],"circular","both"));
mprintf("\n");

// --------------------------------------------------
// Test 6 : Replicate Padding (PRE)
// --------------------------------------------------
disp("Test 6 : Replicate Padding (PRE)");
disp(padarray(A,[2 2],"replicate","pre"));
mprintf("\n");

// --------------------------------------------------
// Test 7 : Symmetric Padding (POST)
// --------------------------------------------------
disp("Test 7 : Symmetric Padding (POST)");
disp(padarray(A,[2 2],"symmetric","post"));
mprintf("\n");

// --------------------------------------------------
// Test 8 : Rectangular Matrix
// --------------------------------------------------
B = [1 2 3;
     4 5 6];

disp("Test 8 : Rectangular Matrix");
disp(padarray(B,[2 1],"replicate","both"));
mprintf("\n");

// --------------------------------------------------
// Test 9 : Row Vector
// --------------------------------------------------
R = [1 2 3 4];

disp("Test 9 : Row Vector");
disp(padarray(R,[0 3],9,"both"));
mprintf("\n");

// --------------------------------------------------
// Test 10 : Column Vector
// --------------------------------------------------
C = [1;
     2;
     3;
     4];

disp("Test 10 : Column Vector");
disp(padarray(C,[3],8,"both"));
mprintf("\n");

// --------------------------------------------------
// Test 11 : Single Element Matrix
// --------------------------------------------------
disp("Test 11 : Single Element Matrix");
disp(padarray(5,[2 2],"replicate"));
mprintf("\n");

// --------------------------------------------------
// Test 12 : int16 Input
// --------------------------------------------------
I = int16([10 20;
           30 40]);

disp("Test 12 : int16 Input");
disp(padarray(I,[1 1],int16(-5),"both"));
mprintf("\n");

// --------------------------------------------------
// Test 13 : 3D Constant Padding
// --------------------------------------------------
X(:,:,1) = [1 2;
            3 4];

X(:,:,2) = [5 6;
            7 8];

disp("Test 13 : 3D Constant Padding");

Y = padarray(X,[1 1 1],0);

disp("Output Size:");
disp(size(Y));

disp("Slice 1");
disp(Y(:,:,1));

disp("Slice 2");
disp(Y(:,:,2));

disp("Slice 3");
disp(Y(:,:,3));

disp("Slice 4");
disp(Y(:,:,4));

mprintf("\n");

// --------------------------------------------------
// Test 14 : 3D Circular Padding (Depth Only)
// --------------------------------------------------
disp("Test 14 : 3D Circular Padding Along Depth");

Y = padarray(X,[0 0 2],"circular");

disp("Output Size:");
disp(size(Y));

disp("Slice 1");
disp(Y(:,:,1));

disp("Slice 3");
disp(Y(:,:,3));

disp("Slice 5");
disp(Y(:,:,5));

disp("Slice 6");
disp(Y(:,:,6));

mprintf("\n");

// --------------------------------------------------
// Test 15 : Mixed Padding Sizes (Rows Only)
// --------------------------------------------------
disp("Test 15 : Mixed Padding Sizes");

disp(padarray(A,[3 0],"symmetric","both"));

mprintf("\n");
