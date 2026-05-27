cd(get_absolute_file_path("immse_test.sce"));
exec('immse.sci', -1);

// Test 1: Identical images
A = [5 5; 5 5];
disp("IMMSE Test 1 (identical):");
disp(immse(A, A)); 
mprintf("\n");

// Test 2: Small difference
B = [4 6; 5 5];
disp("IMMSE Test 2:");
disp(immse(A, B));
mprintf("\n");

// Test 3: Large difference
B = zeros(2,2);
disp("IMMSE Test 3:");
disp(immse(A, B));
mprintf("\n");

// Test 4: Floating values
A = rand(4,4);
B = rand(4,4);
disp("IMMSE Test 4 (float input):");
disp(immse(A, B));
mprintf("\n");

// Test 5: Negative values
A = [-1 -2; 3 4];
B = [1 2; -3 -4];
disp("IMMSE Test 5 (negative values):");
disp(immse(A, B));
mprintf("\n");

// Test 6: Size mismatch (error)
disp("IMMSE Test 6 (size mismatch):");
try
    immse([1 2], [1 2 3]);
catch
    disp("Error handled correctly");
end
mprintf("\n");

// Test 7: Zero Images
A = zeros(3,3);
B = zeros(3,3);
disp("IMMSE Test 7 (all zeros):");
disp(immse(A, B)); 
mprintf("\n");

// Test 8: One Zero, One Non-zero
A = zeros(3,3);
B = ones(3,3)*10;
disp("IMMSE Test 8:");
disp(immse(A, B));
mprintf("\n");

// Test 9: Large Values
A = [1000 2000; 3000 4000];
B = [1100 1900; 3100 3900];
disp("IMMSE Test 9 (large values):");
disp(immse(A, B));
mprintf("\n");

// Test 10: Single Element
A = 5;
B = 10;
disp("IMMSE Test 10 (single value):");
disp(immse(A, B));
mprintf("\n");

// Test 11: Floating Precision Check
A = [0.1 0.2; 0.3 0.4];
B = [0.1 0.25; 0.35 0.45];
disp("IMMSE Test 11 (float precision):");
disp(immse(A, B));
mprintf("\n");

// Test 12: Large Random Matrix
A = rand(50,50);
B = rand(50,50);
disp("IMMSE Test 12 (large random):");
disp(immse(A, B));

