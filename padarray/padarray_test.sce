cd(get_absolute_file_path("padarray_test.sce"));
exec("padarray.sci",-1);

// Test 1 : Default zero padding
A = [1 2; 3 4];
disp("Test 1: Default Zero Padding");
disp(padarray(A,[1 1]));
mprintf("\n");

// Test 2 : Explicit zeros padding
disp("Test 2: zeros Padding");
disp(padarray(A,[1 1],"zeros"));
mprintf("\n");

// Test 3 : Constant numeric padding
disp("Test 3: Constant Padding (5)");
disp(padarray(A,[1 1],5));
mprintf("\n");

// Test 4 : Replicate padding
disp("Test 4: Replicate Padding");
disp(padarray(A,[1 1],"replicate"));
mprintf("\n");

// Test 5 : Circular padding
disp("Test 5: Circular Padding");
disp(padarray(A,[1 1],"circular"));
mprintf("\n");

// Test 6 : Reflect padding
A = [1 2 3;
     4 5 6;
     7 8 9];
disp("Test 6: Reflect Padding");
disp(padarray(A,[1 1],"reflect"));
mprintf("\n");

// Test 7 : Symmetric padding
disp("Test 7: Symmetric Padding");
disp(padarray(A,[1 1],"symmetric"));
mprintf("\n");

// Test 8 : Non-square padding
A = [1 2 3;
     4 5 6];
disp("Test 8: Non-Square Padding [1 3]");
disp(padarray(A,[1 3],"replicate"));
mprintf("\n");

// Test 9 : Single pixel image
A = 7;
disp("Test 9: Single Pixel Image");
disp(padarray(A,[2 2],0));
mprintf("\n");

// Test 10 : No padding
A = [1 2; 3 4];
disp("Test 10: No Padding");
disp(padarray(A,[0 0]));
mprintf("\n");

// Test 11 : Invalid negative padsize
disp("Test 11: Invalid Negative Padsize");
try
    padarray(A,[-1 1]);
catch
    disp("Error handled correctly");
end
mprintf("\n");

// Test 12 : Reflect padding larger than image
disp("Test 12: Invalid Reflect Padding");
try
    padarray([1 2;3 4],[2 2],"reflect");
catch
    disp("Error handled correctly");
end
mprintf("\n");
