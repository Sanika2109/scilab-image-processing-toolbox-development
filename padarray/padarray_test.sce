cd(get_absolute_file_path("padarray_test.sce"));
exec('padarray.sci', -1);

// Test 1: Basic zero padding
A = [1 2; 3 4];
disp("Padarray Test 1 (zero padding):");
disp(padarray(A, [1 1]));
mprintf("\n");

// Test 2: Custom padding value
disp("Padarray Test 2 (padval=5):");
disp(padarray(A, [1 1], 5));
mprintf("\n");

// Test 3: Large padding
disp("Padarray Test 3 (large padding):");
disp(padarray(A, [3 3]));
mprintf("\n");

// Test 4: Non-square padding
A = [1 2 3; 4 5 6];
disp("Padarray Test 4 (non-square):");
disp(padarray(A, [1 3]));
mprintf("\n");

// Test 5: Single element
disp("Padarray Test 5 (single value):");
disp(padarray(7, [2 2]));
mprintf("\n");

// Test 6: Single row
A = [1 2 3 4];
disp("Padarray Test 6 (single row):");
disp(padarray(A, [2 1]));
mprintf("\n");

// Test 7: Single column
A = [1; 2; 3];
disp("Padarray Test 7 (single column):");
disp(padarray(A, [1 2]));
mprintf("\n");

// Test 8: Floating padding value
disp("Padarray Test 8 (float padval):");
disp(padarray([1 2;3 4], [1 1], 0.5));
mprintf("\n");

// Test 9: Random matrix
A = rand(4,4);
disp("Padarray Test 9 (random matrix):");
disp(padarray(A, [2 2]));
mprintf("\n");

// Test 10: No padding
disp("Padarray Test 10 (no padding):");
disp(padarray([1 2;3 4], [0 0]));
mprintf("\n");

// Test 11: Negative padding (error)
disp("Padarray Test 11 (invalid padding):");
try
    padarray([1 2;3 4], [-1 1]);
catch
    disp("Error handled correctly");
end
mprintf("\n");

// Test 12: Empty input
disp("Padarray Test 12 (empty input):");
try
    padarray([], [1 1]);
catch
    disp("Error handled correctly");
end
