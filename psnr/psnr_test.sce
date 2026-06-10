base = get_absolute_file_path("psnr_test.sce");
exec(base + "psnr.sci", -1);
exec(base + "../immse/immse.sci", -1);
exec(base + "../getrangefromclass/getrangefromclass.sci", -1);

// Test 1: Identical Images
A = [10 20; 30 40];
B = [10 20; 30 40];
disp("Test 1: Identical Images");
disp(psnr(A,B));
mprintf("\n");

// Test 2: All Zeros
A = zeros(3,3);
B = zeros(3,3);
disp("Test 2: All Zeros");
disp(psnr(A,B));
mprintf("\n");

// Test 3: Constant Matrices
A = ones(3,3)*50;
B = ones(3,3)*100;
disp("Test 3: Constant Matrices");
disp(psnr(A,B));
mprintf("\n");

// Test 4: Negative Values
A = [-1 -2; 3 4];
B = [1 2; -3 -4];
disp("Test 4: Negative Values");
disp(psnr(A,B));
mprintf("\n");

// Test 5: Floating Values
A = [0.1 0.2; 0.3 0.4];
B = [0.1 0.25; 0.35 0.45];
disp("Test 5: Floating Values");
disp(psnr(A,B));
mprintf("\n");

// Test 6: Single Element
disp("Test 6: Single Element");
disp(psnr(5,10));
mprintf("\n");

// Test 7: Random Matrix
A = rand(3,3);
B = rand(3,3);
disp("Test 7: Random Matrix");
disp(psnr(A,B));
mprintf("\n");

// Test 8: Custom Peak Value
A = [10 20; 30 40];
B = [12 18; 33 39];
disp("Test 8: Custom Peak Value (128)");
disp(psnr(A,B,128));
mprintf("\n");

// Test 9: High Dynamic Range
A = [1000 2000; 3000 4000];
B = [1100 1900; 3100 3900];
disp("Test 9: High Dynamic Range");
disp(psnr(A,B));
mprintf("\n");

// Test 10: Binary Image
A = [0 1; 1 0];
B = [1 0; 0 1];
disp("Test 10: Binary Image");
disp(psnr(A,B));
mprintf("\n");

// Test 11: Mixed Sign Values
A = [-10 0; 10 20];
B = [10 0; -10 -20];
disp("Test 11: Mixed Sign Values");
disp(psnr(A,B));
mprintf("\n");

// Test 12: Large Random Matrix
A = rand(50,50)*255;
B = rand(50,50)*255;
disp("Test 12: Large Random Matrix");
disp(psnr(A,B));
mprintf("\n");
