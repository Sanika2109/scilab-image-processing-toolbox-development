cd(get_absolute_file_path("medfilt2_test.sce"));
exec("medfilt2.sci",-1);
Aimg = imread("cameraman.jpeg");

// ==================================================
// Test 1: Default Parameters
// ==================================================
disp("Test 1: Default Parameters");
A = Aimg;
B = medfilt2(double(A));
figure();
subplot(1,2,1); imshow(uint8(A)); title("Original");
subplot(1,2,2); imshow(uint8(B)); title("Default 3x3");
mprintf("\n");

// ==================================================
// Test 2: Square Window [5x5]
// ==================================================
disp("Test 2: Square Window [5x5]");
A = Aimg;
B = medfilt2(double(A), [5 5], "replicate");
figure();
subplot(1,2,1); imshow(uint8(A)); title("Original");
subplot(1,2,2); imshow(uint8(B)); title("5x5 Median");
mprintf("\n");

// ==================================================
// Test 3: Rectangular Window [3x5]
// ==================================================
disp("Test 3: Rectangular Window [3x5]");
A = Aimg;
B = medfilt2(double(A), [3 5], "replicate");
figure();
subplot(1,2,1); imshow(uint8(A)); title("Original");
subplot(1,2,2); imshow(uint8(B)); title("3x5 Median");
mprintf("\n");

// ==================================================
// Test 4: Rectangular Window [5x7]
// ==================================================
disp("Test 4: Rectangular Window [5x7]");
A = Aimg;
B = medfilt2(double(A), [5 7], "replicate");

figure();
subplot(1,2,1);
imshow(uint8(A));
title("Original");

subplot(1,2,2);
imshow(uint8(B));
title("5x7 Median");

// ==================================================
// Test 5: Zero Padding
// ==================================================
disp("Test 5: Zero Padding");

A = [10 20 30;
     40 50 60;
     70 80 90];

B = medfilt2(double(A), [3 3], "zero");

disp("Original:");
disp(A);

disp("Filtered:");
disp(B);

mprintf("\n");

// ==================================================
// Test 6: Replicate Padding
// ==================================================
disp("Test 6: Replicate Padding");

A = [10 20 30;
     40 50 60;
     70 80 90];

B = medfilt2(double(A), [3 3], "replicate");

disp("Original:");
disp(A);

disp("Filtered:");
disp(B);

mprintf("\n");

// ==================================================
// Test 7: Circular Padding
// ==================================================
disp("Test 7: Circular Padding");

A = [10 20 30;
     40 50 60;
     70 80 90];

B = medfilt2(double(A), [3 3], "circular");

disp("Original:");
disp(A);

disp("Filtered:");
disp(B);

mprintf("\n");
// ==================================================
// Test 8: Symmetric Padding
// ==================================================
disp("Test 8: Symmetric Padding");

A = [10 20 30;
     40 50 60;
     70 80 90];

B = medfilt2(double(A), [3 3], "symmetric");

disp("Original:");
disp(A);

disp("Filtered:");
disp(B);

mprintf("\n");

// ==================================================
// Test 9: Reflect Padding
// ==================================================
disp("Test 9: Reflect Padding");

A = [10 20 30;
     40 50 60;
     70 80 90];

B = medfilt2(double(A), [3 3], "reflect");

disp("Original:");
disp(A);

disp("Filtered:");
disp(B);

mprintf("\n");

// ==================================================
// Test 10: Salt-and-Pepper Noise Removal
// ==================================================
disp("Test 10: Salt-and-Pepper Noise Removal");
A = Aimg;
B = medfilt2(double(A), [3 3], "replicate");

figure();
subplot(1,2,1); imshow(uint8(A)); title("Noisy Image");
subplot(1,2,2); imshow(uint8(B)); title("Filtered Image");
mprintf("\n");

// ==================================================
// Test 11: Extreme Noise Pixel
// ==================================================
disp("Test 11: Extreme Noise Pixel");

A = [10 20 30;
     40 255 50;
     60 70 80];

B = medfilt2(double(A), [3 3], "replicate");

disp("Original:");
disp(uint8(A));

disp("Filtered:");
disp(uint8(B));

mprintf("\n");

// ==================================================
// Test 12: Filter Larger Than Image
// ==================================================
disp("Test 12: Filter Larger Than Image");

A = [10 20;
     30 40];

B = medfilt2(double(A), [5 5], "replicate");

disp("Original:");
disp(A);

disp("Filtered:");
disp(B);

mprintf("\n");
// ==================================================
// Test 13: Single Pixel Image
// ==================================================
disp("Test 13: Single Pixel Image");

A = 150;

B = medfilt2(double(A), [3 3], "replicate");

disp("Original:");
disp(A);

disp("Filtered:");
disp(B);

mprintf("\n");

// ==================================================
// Test 14: Invalid Padding Option
// ==================================================
disp("Test 14: Invalid Padding Option");

try
    A = rand(10,10)*255;
    B = medfilt2(A,[3 3],"abc");
catch
    disp(lasterror());
end

mprintf("\n");

// ==================================================
// Test 15: Even Window Size
// ==================================================
disp("Test 15: Even Window Size");

try
    A = rand(10,10)*255;
    B = medfilt2(A,[4 4],"replicate");
catch
    disp(lasterror());
end

mprintf("\n");
